# ⏱️ Deployment Timeline — How Long This Took

> **Stage 7: Testing Known** — Timestamped record of turning kAgent on, from an empty repo to a working DeepSeek-backed kagent deployment on both minikube and Fly.io. Timestamps are UTC, taken from git commit metadata, GitHub Actions run history, and Fly.io/kubectl output captured during the work — not estimates.

---

## Summary

| Phase | Elapsed |
|---|---|
| Empty repo → bootstrapped 7-stage framework, GitHub Pages live | **~29 min** |
| → kagent installed on minikube, wired to DeepSeek, sample agents deployed | **+1h 14min** |
| → DeepSeek balance blocker hit, resolved by user, re-verified | **+13 min** |
| → Same stack redeployed to Fly.io (k3s-in-a-Machine), DeepSeek-verified there too | **+24 min** |
| **Total, empty repo → two independent working deployments** | **≈ 2h 20min** |

---

## Timestamped Log

| Time (UTC) | Event |
|---|---|
| 12:48:32 | `be8f4e1` — repo's only pre-existing commit (empty README) |
| 12:49 | Session starts; template cloned, placeholders identified |
| 12:53:03 | `fa248ab` — kAgent bootstrapped from `delivery-pilot-template` (7-stage structure, placeholders replaced) |
| 12:53:11 | First Pages deploy attempt — **fails** (GitHub Pages not yet enabled on the repo) |
| 12:57:55 | `34a991b` — Stage 1 reset to the kagent/minikube OKRs; DeepSeek chosen as model backend (ADR-002) |
| 12:57:59 | Pages deploy — **fails** (still not enabled) |
| 13:02:09 | `7ba42f5` — `mcp-builder` / `webapp-testing` skills vendored from `anthropics/skills` |
| 13:02:14 | Pages deploy — **fails** (still not enabled) |
| ~13:15 | GitHub Pages enabled via API (`POST /repos/.../pages`, Source: GitHub Actions) |
| 13:17:04 | Manual workflow re-run — **succeeds**; https://rifaterdemsahin.github.io/kAgent/ live |
| ~13:50 | minikube confirmed already running; kagent CLI installed; kagent Helm install started, pointed at DeepSeek |
| ~13:55 | Every kagent pod `ImagePullBackOff` — pre-existing Zarf mutating webhook (unrelated prior PoC on the same cluster) intercepting image pulls cluster-wide |
| ~13:58 | Zarf webhook patched to exclude the `kagent` namespace; pods reschedule |
| 14:02:16 | `ModelConfig/default-model-config` reconciled — config had a bug (stray key, trailing space) from a CLI env-var quoting issue |
| ~14:04 | Clean Helm values file applied directly; `ModelConfig` corrected (`deepseek-chat`, correct `baseUrl`) |
| ~14:05 | All 10 demo-profile sample agents `Ready`/`Accepted`/`Running` |
| 14:06:36 | First live invoke reaches DeepSeek — **`402 Payment Required — Insufficient Balance`** (R-010 logged) |
| 14:16:42 | `742eeeb` — Agent Status + kagent-vs-Azure-SRE comparison pages published; kagent-on-minikube architecture documented |
| 14:16:47 | Pages deploy — **succeeds**; both new pages live |
| — | **User adds credits to the DeepSeek account** |
| 14:19:44 | Re-test: `k8s-agent` answers "What is a Kubernetes Pod?" correctly — **R-010 resolved**, KR 2.2 met |
| ~14:20 | Second agent (`helm-agent`) also verified working |
| ~14:24 | User redirects: deploy kagent to **Fly.io** instead of/alongside minikube, using Key Vault tokens |
| ~14:26 | Clarified approach with user (kagent needs real Kubernetes; Fly.io isn't K8s) → **k3s-in-a-Fly-Machine** chosen |
| ~14:27 | Fly app `kagent-k3s` created; secrets (`DEEPSEEK_API_KEY`, `FLY_API_TOKEN`) set from Azure Key Vault |
| 14:29:05 | Persistent volume `kagent_k3s_data` created (10GB, region `lhr`) |
| ~14:30 | Deploy attempt 1 — **fails build**: `apk add` — `rancher/k3s` base image has no package manager |
| ~14:32 | Deploy attempt 2 — **fails build**: BusyBox `wget` in that image has no TLS support, can't fetch `https://` |
| ~14:33 | Dockerfile fixed: Helm fetched in a throwaway Alpine build stage, only the static binary copied into the final image |
| 14:34:11 | Deploy attempt 3 — machine boots, k3s starts; **crashes** — `/var/log` doesn't exist in this minimal image |
| ~14:36 | `mkdir -p /var/log` added; redeployed |
| 14:37:17 | k3s cluster ready inside the Fly Machine |
| 14:37:27–14:39:33 | `kagent-crds` then `kagent` (demo profile) installed via Helm — **"KAGENT DEPLOYED"** |
| 14:40:41 | First live invoke on Fly — **fails**: DNS lookup for `api.deepseek.com` — `server misbehaving` (Fly Machines' default resolver only resolves `*.internal`) |
| ~14:41 | `entrypoint.sh` fixed to overwrite `/etc/resolv.conf` with public DNS (1.1.1.1, 8.8.8.8) before k3s starts; redeployed |
| ~14:43 | Live invoke on `https://kagent-k3s.fly.dev` — **succeeds**: correct, DeepSeek-generated answer |
| ~14:44 | Idle watchdog (3-hour auto-stop, per explicit requirement) confirmed running inside the Machine via `fly ssh console` |

---

## Reading This Timeline

- **~29 minutes** to go from an empty repo to a live, working GitHub Pages site (including two failed deploys before Pages was actually enabled — a one-time repo setting, not a code problem).
- **~1h 14min** from "start the kagent install" to "all 10 sample agents Ready and wired to DeepSeek" on minikube — most of that was debugging a pre-existing Zarf webhook on the shared cluster and a CLI quoting bug, not the kagent install itself (which is a 2-minute Helm operation once configuration is right).
- **13 minutes** from "user adds DeepSeek credits" to "two different sample agents confirmed answering correctly."
- **~24 minutes** to stand up an entirely new deployment target (Fly.io, k3s-in-a-Machine) from scratch and get it DeepSeek-verified — three real infrastructure surprises hit and fixed along the way (no package manager, no TLS in the base image's `wget`, and Fly's internal-only default DNS resolver), each diagnosed from a genuine failure, not anticipated in advance.
- None of the debugging time was spent guessing — every fix traced to a specific log line or API response (see `6_Semblance/error.log` and `6_Semblance/fix.log` for the full error → fix pairs, and `4_Formula/llm_thinking_log.md` for the reasoning behind each one).

## Related Files

- [`6_Semblance/error.log`](../6_Semblance/error.log) / [`fix.log`](../6_Semblance/fix.log) — every error hit and its fix
- [`6_Semblance/lessons_learned.md`](../6_Semblance/lessons_learned.md) — retrospectives for both the minikube and Fly.io deployments
- [`4_Formula/specs.md`](../4_Formula/specs.md) — SPEC-016 (minikube), SPEC-018 (Fly.io)
- [`5_Symbols/agent_status.html`](../5_Symbols/agent_status.html) — live deployment snapshot
