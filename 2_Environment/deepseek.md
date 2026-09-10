# DeepSeek as the Sample Agent's Model Backend

> **Stage 2: Environment** — Tool rationale for the LLM backend behind the kagent sample agent (see [1_Real_Unknown/questions.md](../1_Real_Unknown/questions.md) Q3, [1_Real_Unknown/risks.md](../1_Real_Unknown/risks.md) R-002, [4_Formula/decisions.md](../4_Formula/decisions.md)).

---

## Can DeepSeek be used "over OpenAPI"? — Yes, via the OpenAI-compatible API

DeepSeek does not publish its own bespoke client protocol for this use case — its hosted API is **wire-compatible with the OpenAI Chat Completions API** (the same REST/OpenAPI schema most agent frameworks, including kagent's, already speak). That means:

- **No custom SDK needed.** Any OpenAI-compatible client (the official `openai` Python/Node SDK, LangChain's `ChatOpenAI`, LiteLLM, or kagent's own OpenAI-provider config) works against DeepSeek by changing two things:
  - `base_url` → `https://api.deepseek.com` (or `https://api.deepseek.com/v1`)
  - `api_key` → the DeepSeek key (sourced from Azure Key Vault, never hardcoded)
- **Model names** are DeepSeek's own: `deepseek-chat` (general purpose, DeepSeek-V3) and `deepseek-reasoner` (DeepSeek-R1, chain-of-thought reasoning). Everything else — request/response shape, streaming, function/tool calling — follows the OpenAI schema.

### Example (OpenAI SDK pointed at DeepSeek)

```python
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["DEEPSEEK_API_KEY"],  # from Azure Key Vault at runtime
    base_url="https://api.deepseek.com",
)

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[{"role": "user", "content": "Hello from kAgent"}],
)
```

### How this applies to kagent

- If kagent's sample agent (or the underlying framework, e.g. an OpenAI-provider-based agent) accepts a custom `base_url` / `OPENAI_BASE_URL`, pointing it at DeepSeek requires no code changes — only environment configuration.
- In Kubernetes, that configuration is a `Secret` (the DeepSeek key) plus a `ConfigMap`/env var for the base URL, referenced by the agent's Deployment manifest — never a plaintext key in the manifest itself (RULE-003/004: credentials come from Azure Key Vault, loaded into the cluster as a Secret at deploy time).
- Function/tool calling, if the sample agent uses it, is supported by DeepSeek's OpenAI-compatible endpoint the same way — verify against the specific sample agent's tool-call format before relying on it end-to-end.

## Rationale

| Option | Verdict | Why |
|--------|---------|-----|
| DeepSeek via OpenAI-compatible API | ✅ Chosen | No new client library, drop-in `base_url` swap, key already in the project's Key Vault |
| A bespoke DeepSeek-only SDK | ❌ Not needed | DeepSeek doesn't require one for this use case |
| Local model (Ollama) | Considered, not chosen | User decided on DeepSeek explicitly |

## Related Files

- [1_Real_Unknown/questions.md](../1_Real_Unknown/questions.md) — Q3 resolution
- [1_Real_Unknown/risks.md](../1_Real_Unknown/risks.md) — R-002 mitigation
- [2_Environment/setup_azure.md](setup_azure.md) — how the key is loaded from Key Vault
- [4_Formula/decisions.md](../4_Formula/decisions.md) — architectural decision record
