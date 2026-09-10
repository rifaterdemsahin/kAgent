# 🏛️ Architecture Decision Records (ADRs)

> **Stage 4: Formula** — Documenting major architectural decisions, their context, and consequences.

---

## 📋 ADR Index

- **ADR 001:** Choice of Secrets Manager (Azure Key Vault)
- **ADR 002:** DeepSeek API as the Sample Agent's Model Backend

---

## 📌 ADR 001: Choice of Secrets Manager (Azure Key Vault)

### **Status:** Accepted
**Date:** YYYY-MM-DD  
**Decided By:** [Human / AI Agent]

### **Context & Problem Statement**
*What is the context of this decision? What problem are we solving? (e.g. "We need a secure way to manage database credentials and API keys across environments without committing them to git.")*

### **Decision Drivers**
1. Zero secrets committed to version control.
2. Low cost for development operations.
3. Ease of integration with GitHub Actions and deployment platforms.

### **Considered Options**
- **Option 1:** Local `.env` files (Committed, high-risk).
- **Option 2:** Vault by HashiCorp (High configuration complexity, higher cost).
- **Option 3:** Azure Key Vault (FIPS compliance, pay-per-operation pricing).

### **Decision Outcome**
**Chosen Option:** **Option 3 (Azure Key Vault)**.
- **Why:** Fits enterprise-grade requirements, costs ~$0.03 per 10K requests (Standard tier), and interfaces natively with cloud pipelines.

### **Consequences**
- **Pros:** High security, audit logging, simple credential rotation.
- **Cons:** Requires active Azure credentials during CLI initialization and deployment pipelines.

---

## 📌 ADR 002: DeepSeek API as the Sample Agent's Model Backend

### **Status:** Accepted
**Date:** 2026-09-10
**Decided By:** Human (rifaterdemsahin)

### **Context & Problem Statement**
kagent's sample agent needs an LLM backend to run against. `1_Real_Unknown/questions.md` (Q3) asked whether a paid model API is required given the project's "public open-source libraries only" sourcing constraint.

### **Decision Drivers**
1. A DeepSeek API key already exists in the project's Azure Key Vault (`/vaults/dp-kv-deliverypilot/secrets`) — no new secret to provision.
2. DeepSeek's hosted API is OpenAI-compatible (see [2_Environment/deepseek.md](../2_Environment/deepseek.md)), so no bespoke SDK or agent-framework fork is needed.
3. User explicitly chose it over a local model (e.g. Ollama).

### **Considered Options**
- **Option 1:** Local model via Ollama (no API key, but heavier local resource use on top of minikube + kagent).
- **Option 2:** DeepSeek API, OpenAI-compatible endpoint (`base_url` swap only).
- **Option 3:** OpenAI API directly (would need a new key; not chosen).

### **Decision Outcome**
**Chosen Option:** **Option 2 (DeepSeek API)**.
- **Why:** Reuses an existing Key Vault secret, drop-in OpenAI-compatible client config, no new provisioning.

### **Consequences**
- **Pros:** Minimal integration work; standard OpenAI-shaped tool/function calling if the sample agent needs it; cost stays low (DeepSeek pricing is well below most alternatives).
- **Cons:** Adds an external network dependency (DeepSeek's hosted API) — the sample agent cannot run fully offline; the key must be threaded into the cluster as a Kubernetes `Secret`, never a plaintext manifest value (see R-002 in [1_Real_Unknown/risks.md](../1_Real_Unknown/risks.md)).
