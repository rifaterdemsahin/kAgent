#!/bin/sh
# Stops this Fly Machine once it has been running for at least IDLE_STOP_HOURS
# and no agent has been invoked (no POST /api/a2a/... in kagent-controller's
# own request log) within the trailing IDLE_STOP_HOURS window (SPEC-018).
# POSIX sh — no jq/python available in this BusyBox-based image; uses grep -c
# against kubectl's own --since window instead of parsing timestamps.
set -eu

IDLE_STOP_HOURS="${IDLE_STOP_HOURS:-3}"
IDLE_STOP_SECONDS=$((IDLE_STOP_HOURS * 3600))
POLL_SECONDS=300
NAMESPACE=kagent
DEPLOYMENT=deploy/kagent-controller

START_TIME=$(date +%s)

stop_this_machine() {
  if [ -z "${FLY_API_TOKEN:-}" ] || [ -z "${FLY_APP_NAME:-}" ] || [ -z "${FLY_MACHINE_ID:-}" ]; then
    echo "[idle-watchdog] missing FLY_API_TOKEN/FLY_APP_NAME/FLY_MACHINE_ID - cannot self-stop"
    return
  fi
  # This BusyBox image's wget has no TLS support (statically-linked, no OpenSSL),
  # so make the HTTPS call from a short-lived pod that has a real curl instead of
  # trying to bundle a TLS-capable client in the node image itself.
  if kubectl run kagent-idle-stop --restart=Never --rm -i --quiet \
      --image=curlimages/curl:8.10.1 \
      --env="FLY_API_TOKEN=${FLY_API_TOKEN}" \
      --env="FLY_APP_NAME=${FLY_APP_NAME}" \
      --env="FLY_MACHINE_ID=${FLY_MACHINE_ID}" \
      --command -- sh -c 'curl -fsS -X POST -H "Authorization: Bearer $FLY_API_TOKEN" "https://api.machines.dev/v1/apps/$FLY_APP_NAME/machines/$FLY_MACHINE_ID/stop"'; then
    echo "[idle-watchdog] stop request sent to Fly Machines API"
  else
    echo "[idle-watchdog] failed to call Fly Machines API"
  fi
}

echo "[idle-watchdog] armed: will stop this machine after ${IDLE_STOP_HOURS}h with no agent activity"

while true; do
  sleep "$POLL_SECONDS"

  uptime_sec=$(( $(date +%s) - START_TIME ))
  if [ "$uptime_sec" -lt "$IDLE_STOP_SECONDS" ]; then
    echo "[idle-watchdog] up $((uptime_sec / 60))min, below the ${IDLE_STOP_HOURS}h floor — skipping check"
    continue
  fi

  hits=$(kubectl logs -n "$NAMESPACE" "$DEPLOYMENT" --since="${IDLE_STOP_HOURS}h" 2>/dev/null | grep -c '/api/a2a/' || true)
  if [ "${hits:-0}" -eq 0 ]; then
    echo "[idle-watchdog] no agent activity in the last ${IDLE_STOP_HOURS}h — stopping this machine"
    stop_this_machine
    break
  fi
  echo "[idle-watchdog] $hits agent request(s) in the last ${IDLE_STOP_HOURS}h — staying up"
done
