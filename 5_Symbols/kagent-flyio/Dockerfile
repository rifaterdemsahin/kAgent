# k3s + kagent, packaged to run as a single Fly Machine (SPEC-018).
# Fly Machines are Firecracker micro-VMs (not shared-kernel containers), which is
# what makes running k3s's own containerd-in-a-container workable here.
#
# rancher/k3s is a minimal BusyBox image (no apk/apt/python, and its wget has
# no TLS support) — kubectl already ships in it; fetch Helm in a stage that
# has real HTTPS, then copy the static binary in.
FROM alpine:3.20 AS helm-fetch
RUN apk add --no-cache curl \
    && curl -fsSL -o /tmp/helm.tgz https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz \
    && tar -xzf /tmp/helm.tgz -C /tmp \
    && chmod +x /tmp/linux-amd64/helm

FROM rancher/k3s:v1.31.4-k3s1
COPY --from=helm-fetch /tmp/linux-amd64/helm /usr/local/bin/helm

COPY entrypoint.sh /entrypoint.sh
COPY idle-watchdog.sh /idle-watchdog.sh
RUN chmod +x /entrypoint.sh /idle-watchdog.sh

ENTRYPOINT ["/entrypoint.sh"]
