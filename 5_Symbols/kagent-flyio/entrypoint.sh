#!/bin/sh
# Boots a single-node k3s cluster inside this Fly Machine, installs kagent
# pointed at DeepSeek, exposes the kagent UI on the Machine's own network
# namespace (so Fly's edge proxy can reach it), and starts the idle watchdog
# that stops this Machine after 3 hours with no agent activity (SPEC-018).
# POSIX sh (ash/BusyBox) — no bashisms, this base image has no bash.
set -eu

mkdir -p /var/log

# Fly Machines default to /etc/resolv.conf pointing only at Fly's internal
# 6PN resolver (fdaa::3), which resolves *.internal but not public hostnames.
# k3s's CoreDNS forwards upstream queries to this file by default, so without
# this override every external LLM API call (DeepSeek, OpenAI, etc.) fails
# DNS resolution with "server misbehaving". Point it at public resolvers instead.
echo "[entrypoint] rewriting /etc/resolv.conf to use public DNS (Fly's default only resolves *.internal)..."
cat > /etc/resolv.conf <<'RESOLV'
nameserver 1.1.1.1
nameserver 8.8.8.8
RESOLV

echo "[entrypoint] starting k3s server..."
/bin/k3s server \
  --disable=traefik \
  --write-kubeconfig-mode=644 \
  --data-dir=/var/lib/rancher/k3s \
  > /var/log/k3s.log 2>&1 &
K3S_PID=$!

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "[entrypoint] waiting for k3s API to become ready..."
until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done
kubectl wait --for=condition=Ready node --all --timeout=120s
echo "[entrypoint] k3s is ready."

if [ -z "${DEEPSEEK_API_KEY:-}" ]; then
  echo "[entrypoint] FATAL: DEEPSEEK_API_KEY not set (should come from a Fly secret sourced from Azure Key Vault)" >&2
  exit 1
fi

VALUES_FILE=/tmp/kagent-values.yaml
cat > "$VALUES_FILE" <<YAML
argo-rollouts-agent: {enabled: true}
cilium-debug-agent: {enabled: true}
cilium-manager-agent: {enabled: true}
cilium-policy-agent: {enabled: true}
helm-agent: {enabled: true}
istio-agent: {enabled: true}
k8s-agent: {enabled: true}
kgateway-agent: {enabled: true}
observability-agent: {enabled: true}
promql-agent: {enabled: true}
providers:
  default: openAI
  openAI:
    provider: OpenAI
    model: "deepseek-chat"
    apiKey: "${DEEPSEEK_API_KEY}"
    config:
      baseUrl: "https://api.deepseek.com"
YAML

echo "[entrypoint] installing kagent-crds..."
helm upgrade --install kagent-crds "oci://ghcr.io/kagent-dev/kagent/helm/kagent-crds" \
  --version "${KAGENT_VERSION:-0.10.1}" -n kagent --create-namespace --wait --timeout 5m

echo "[entrypoint] installing kagent (demo profile, DeepSeek backend)..."
helm upgrade --install kagent "oci://ghcr.io/kagent-dev/kagent/helm/kagent" \
  --version "${KAGENT_VERSION:-0.10.1}" -n kagent -f "$VALUES_FILE" --wait --timeout 5m

rm -f "$VALUES_FILE"

echo "[entrypoint] exposing kagent-ui on 0.0.0.0:8080 for Fly's proxy..."
kubectl port-forward --address 0.0.0.0 -n kagent svc/kagent-ui 8080:8080 \
  > /var/log/kagent-ui-portforward.log 2>&1 &

echo "[entrypoint] exposing kagent-controller on 0.0.0.0:8083 (internal API)..."
kubectl port-forward --address 0.0.0.0 -n kagent svc/kagent-controller 8083:8083 \
  > /var/log/kagent-controller-portforward.log 2>&1 &

echo "[entrypoint] starting idle watchdog (auto-stop after ${IDLE_STOP_HOURS:-3}h of no agent activity)..."
/idle-watchdog.sh &

echo "[entrypoint] ready. kagent UI on :8080, controller API on :8083."
wait "$K3S_PID"
