# Project Risks

> **Stage 1: Real Unknown** — Track active risks, solved risks, and the risk update log. Add new risks with every project update and mention those that are solved.

## Risk Matrix

| Severity | Symbol | Meaning |
|----------|--------|---------|
| Critical | 🔴 | Blocks delivery — must resolve immediately |
| High | 🟠 | Significantly impacts quality or timeline |
| Medium | 🟡 | Should be addressed in current milestone |
| Low | 🟢 | Monitor — address when convenient |

---

## ⚠️ Active Risks

### R-001: minikube resource limits on this Mac
- **Status:** 🟡 Active
- **Severity:** Medium
- **Likelihood:** Medium
- **Impact:** kagent's control plane plus a sample agent may need more CPU/RAM than the default minikube profile allocates, causing pods to stay `Pending`.
- **Trigger:** `minikube start` with default `--cpus`/`--memory`
- **Mitigation:** Document a tested resource profile in `2_Environment/local_server.md`; bump `--cpus`/`--memory` if pods don't schedule.
- **Last Updated:** 2026-09-10

### R-002: Sample agent's LLM API key must never leak into git
- **Status:** 🟢 Active (mitigated)
- **Severity:** Low
- **Likelihood:** Low
- **Impact:** The sample agent's model backend is the **DeepSeek API** (decided 2026-09-10). The key already exists in Azure Key Vault (`/vaults/dp-kv-deliverypilot/secrets`) — the risk is a future step accidentally hardcoding it into a manifest, Helm values file, or committed config instead of a Kubernetes Secret sourced from the vault.
- **Trigger:** Pasting the DeepSeek key directly into a YAML manifest or `.env` committed to git
- **Mitigation:** Load the DeepSeek key from Azure Key Vault into a Kubernetes `Secret` at deploy time (never in plain YAML); reference it via `secretKeyRef` in the agent manifest. Document the flow in `2_Environment/setup_azure.md`. `.env.example` keeps only the placeholder variable name.
- **Last Updated:** 2026-09-10

### R-003: kagent Helm chart / CRD version drift
- **Status:** 🟢 Active
- **Severity:** Low
- **Likelihood:** Low
- **Impact:** kagent is an actively developed project; a chart or CRD change between install and re-run could break reproducibility.
- **Trigger:** Re-running setup weeks/months later with a newer kagent release
- **Mitigation:** Pin the kagent chart/CLI version used in `2_Environment/dependencies.md`.
- **Last Updated:** 2026-09-10

---

## ✅ Solved Risks

*None yet — this is a fresh project instance.*
