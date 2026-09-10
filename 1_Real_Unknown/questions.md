# ❓ Open Questions

> **Stage 1: Real Unknown** — Document the specific questions and unknowns that this project must answer.

---

## 📋 Active Unknowns

| Question | Owner / Agent | Target Stage for Resolution | Resolution Notes / Link |
| :--- | :--- | :--- | :--- |
| **Q1:** Which kagent version/Helm chart should be installed, and what are minikube's minimum CPU/RAM requirements for it? | Environment Agent | `2_Environment` | |
| **Q2:** Which sample agent ships with kagent (or its docs) and what does it need to run (an LLM backend, API keys)? | Environment Agent | `2_Environment` | |
| **Q3:** Does the sample agent need a model API key, or can it run against a local/free model? | Environment Agent | `2_Environment` | Resolved 2026-09-10 — user decided to use the **DeepSeek API** as the model backend for the sample agent. Key stored in Azure Key Vault (`/vaults/dp-kv-deliverypilot/secrets`), never committed. See `2_Environment/setup_azure.md` and `4_Formula/decisions.md`. |
| **Q4:** What minikube driver (Docker, HyperKit, etc.) and resource profile (`minikube start --cpus --memory`) works reliably on this Mac? | Environment Agent | `2_Environment` | |
| **Q5:** What does "success" look like for the sample agent (logs, HTTP response, CRD status) so the smoke test can check it objectively? | Test Agent | `7_Testing_Known` | |

---

## 📌 Instructions
1. Document questions **before** writing code.
2. Update the "Resolution Notes" column as soon as a decision is made or implemented.
3. Move fully resolved questions into the relevant `2_Environment` doc once answered.
