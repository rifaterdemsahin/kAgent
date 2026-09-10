# 🏆 Objectives and Key Results (OKRs)

> **Stage 1: Real Unknown** — Define measurable and time-bound goals for the project.

---

## 🎯 Objective 1: Set up kagent

*Get [kagent](https://kagent.dev/) — a Kubernetes-native agent framework — installed and operational.*

- ✅ **KR 1.1:** minikube cluster running locally and reachable via `kubectl` — reused the existing local minikube profile
- ✅ **KR 1.2:** kagent CLI/Helm chart installed into the cluster with all CRDs and controllers healthy (`kubectl get pods -n kagent` all `Running`) — kagent 0.10.1, demo profile
- ✅ **KR 1.3:** Installation steps and versions captured in `2_Environment/architecture.md` and `2_Environment/dependencies.md`

---

## 🎯 Objective 2: Run sample agents in Kubernetes

*Prove the framework works end-to-end by running kagent's sample agent(s) against the minikube cluster.*

- ✅ **KR 2.1:** At least one sample agent from a public open-source source deployed and reaching `Running`/`Ready` state — all 10 demo-profile agents Ready
- ✅ **KR 2.2:** Agent observed producing expected output (logs or a sample task response) captured as evidence in `7_Testing_Known/` — `k8s-agent` and `helm-agent` both returned correct, on-topic `deepseek-chat` answers on 2026-09-10 (see [`smoke_tests.md`](../7_Testing_Known/smoke_tests.md))
- **KR 2.3:** Full setup reproducible from a clean minikube by following `2_Environment/setup_ai.md` / `local_server.md` — not yet re-validated from a truly clean cluster (this run reused an existing minikube with pre-existing Zarf webhook complications; see `2_Environment/architecture.md`)

---

## 🧪 Outcome Tracking & Validation

*How and when will these Key Results be evaluated?*

- Final validation checklist is located in [7_Testing_Known/README.md](../7_Testing_Known/README.md)
- Smoke test evidence recorded in [7_Testing_Known/smoke_tests.md](../7_Testing_Known/smoke_tests.md)
