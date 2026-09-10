# 📓 Lessons Learned & Active Reflection Journal

> This log captures retrospectives, insights, and lessons learned during development milestones.

---

## 📅 2026-05-31: Stage 1 Kanban Implementation & Navigation Setup

### What went well
- Created a standard Markdown-based `kanban.md` that traces tasks back to the 7-Stage Framework.
- Updated the centralized navigation menus (`navigation_config.json`, fallback JSON objects in `index.html`, and `markdown_renderer.html`) to expose the Kanban board as a direct debug option.
- Verified how `markdown_renderer.html` resolves directory paths (defaults to `README.md`) and correctly formatted links.

### Gaps & Challenges
- Navigation fallbacks are duplicated in `index.html` and `markdown_renderer.html`. In the future, it might be cleaner to isolate the fallback menu logic to a shared JS utility, but keeping them synchronized manually works for now and maintains resilience.

### Takeaway for Future AI Agents
- When completing tasks, make sure to update the status of the tasks in `1_Real_Unknown/kanban.md` using matching commit messages.

## 📅 2026-05-31: Stage 1 Cost Tracker Setup

### What went well
- Established a unified structure to track both system infrastructure costs and API token consumption in `1_Real_Unknown/costs.md`.
- Kept navigation fallbacks in sync so that the project menu operates reliably.

### Gaps & Challenges
- Estimates for Key Vault and container execution can fluctuate. Agents should update the log on every significant run/operation to prevent budget surprises.

## 📅 2026-05-31: Agent Git Rule & Error Resolution Update

### What went well
- Clarified the requirement for git error resolution across all core agent documentation (`agents.md`, `gemini.md`, `claude.md`, `copilot.md`, `kilocode.md`).
- Practiced granular commit-and-push cycles for each file modification.

### Gaps & Challenges
- None. Maintaining step-by-step git push commands helps identify remote changes or conflicts early.

## 📅 2026-05-31: Console Debugging & Debug Menu Sync Update

### What went well
- Added custom `debugLog` function to output descriptive messages into browser console when debug mode (`debug=true` cookie) is active.
- Documented Debug Menu synchronization rule across all agent personas to prevent stale menu links when markdown documents are added or updated.

### Gaps & Challenges
- Since debug console logs only print when the debug cookie is active, it protects console cleanliness for standard users while providing rich instrumentation for developers.

## 📅 2026-05-31: Architecture Setup & Sync Rules Update

### What went well
- Created a comprehensive `2_Environment/architecture.md` containing dynamic Mermaid charts showing system components (GitHub Pages, Cloudflare Workers, Fly.io, Azure Key Vault, GitHub Actions).
- Standardized rules in `agents.md` and agent profiles instructing teams to update `architecture.md` as soon as system configurations change.

### Gaps & Challenges
- None. Ensuring all components are mapped visually helps human stakeholders and subsequent AI agents maintain correct contextual orientation.

## 📅 2026-05-31: Kanban Maintenance Section Added

### What went well
- Appended the 7-stage folder structure maintenance checklist directly into `1_Real_Unknown/kanban.md` as requested.
- Tracked this update in the logs to maintain proper execution transparency.

### Gaps & Challenges
- None. Having this checklist helps ensure each stage directory is systematically maintained during development runs.

## 📅 2026-07-12: Smoke Test Runner, Menu Backfill & the 7→1 Sanity Loop

### What went well
- The SPEC-008 runner (`5_Symbols/toolbox/smoke_test.py`) proved its worth on its very first cloud run: it caught a real production bug (stage folder links 404 on GitHub Pages) that local checks could not see. The full error workflow was exercised end-to-end — GitHub Issue #1 → fix → error.log/fix.log → VERIFIED → issue closed.
- Making the runner template-adapted (driven by `navigation_config.json`, stdlib only) means every project bootstrapped from this template inherits working smoke tests with zero changes.
- Regenerating all 3 navigation sources from one script eliminated the manual 3-way sync problem that caused R-003; the runner now guards it automatically.

### Gaps & Challenges
- A parallel push race (R-001) occurred mid-cycle when `static.yml` landed on the remote — resolved with `git pull --rebase`, exactly as the documented mitigation prescribes. The mitigation works; keep pushes sequential.
- The deploy workflow (`static.yml`) still deploys unconditionally — wiring the smoke runner in as a gate is the single remaining step to close R-007.
- Lesson: local-only testing gave a false "all green" — the folder-link bug was only visible against the deployed site. Always run both modes, as the Test Agent rule requires.

## 📅 2026-07-12: Template Restructure — Moves, Placeholders, Skills, CI/CD Gate

### What went well
- All three file moves (`supabase/`, `prompts.md`, `markdown_renderer.html`) landed with zero broken links because the smoke runner validated every step — the renderer move (the risky one) worked first try by keeping `?file=` parameters root-relative and adding a single `../` fetch base.
- The CI/CD gate is now real: `static.yml` runs the smoke job before deploy, and the first gated pipeline went green in 26 seconds. Formula Agent owns the pipeline end to end.
- Template-reuse hardening: the GitHub edit URL now derives user/repo from the Pages URL, and SPEC-010 enumerates exactly which six values a consumer project replaces.

### Gaps & Challenges
- Blind search-and-replace on `prompts.md` mangled the folder-tree diagrams in the persona files — caught immediately and fixed. Lesson: path renames in prose need per-context review, not one regex.
- The Supabase CLI expects `supabase/` at the repo root; after the move, CLI commands need `--workdir 2_Environment` (documented in `4_Formula/database.md`). Moving conventional-location folders trades tidiness for tool friction — acceptable here, but worth flagging to consumers.

## 📅 2026-09-10: Agent Operating Rules (spec what you did + commit/push)

### What went well
- Put standing orders in `5_Symbols/rules/` next to coding/git/file rules so agents have one folder to load.
- RULE-001 closes the gap between "spec before code" and "record what was actually delivered" in Formula.
- RULE-002 restates commit-and-push as a numbered standing order instead of only a buried coordinator bullet.

### Gaps & Challenges
- Specs-before-code already existed; agents still skipped the after-work spec. A dedicated file with two numbered rules is easier to load than re-reading all of `agents.md`.

### Takeaway for Future AI Agents
- Load `5_Symbols/rules/agent_operating_rules.md` at session start. After work: write the spec in `4_Formula/specs.md`, then commit and push.

## 📅 2026-09-10: kagent on minikube — from ImagePullBackOff to a real DeepSeek answer

### What went well
- Reading the actual CRD Go source (`api/v1alpha3/modelconfig_types.go`) and the Helm template before guessing paid off immediately — `provider: OpenAI` + `openAI.baseUrl` was exactly right for pointing kagent at DeepSeek's OpenAI-compatible API, first try.
- Verified with a real end-to-end call instead of trusting `kubectl wait --for=condition=Ready`. That distinction mattered twice: it caught the corrupted Helm values (trailing space in the model name) that pod-readiness alone would never surface, and later it's what proved KR 2.2 was actually met (a real DeepSeek-generated answer), not just "pods are green."
- When credits were added, the fix loop closed cleanly: same key pulled fresh from Key Vault, same two agents (`k8s-agent`, `helm-agent`) re-invoked, both returned correct, on-topic answers with `state: completed`.

### Gaps & Challenges
- **Shared-cluster surprise:** this minikube cluster already carried a Zarf mutating webhook from unrelated prior work (`zarf`/`hello-world` PoC). It silently rewrote every new pod's image reference cluster-wide (any namespace but `kube-system`), which is a much wider blast radius than its own `zarf` namespace would suggest. Lesson: before installing anything new into a cluster you didn't just create, check `kubectl get mutatingwebhookconfigurations` / `validatingwebhookconfigurations` — cluster-wide admission webhooks from past experiments are invisible until something breaks.
- **CLI helper env vars can silently corrupt values:** `KAGENT_HELM_EXTRA_ARGS`'s naive string-split on `"--set"` ate whitespace into the actual Helm values. Lesson: when a CLI wrapper's "extra args passthrough" mechanism is string-based rather than a real arg array, don't trust it for anything beyond a single trivial value — go straight to `helm upgrade` with an explicit values file instead.
- **A diagnostic command leaked a secret to output:** `helm get values <release>` prints `apiKey` in plaintext by default. Caught it, didn't re-print or persist it, rebuilt the fix from the source env var instead of the dumped file. Lesson: treat `helm get values` on any release with API keys as sensitive output — redact (`sed`) before ever displaying or logging it.
- **The blocker that wasn't fixable by config:** DeepSeek's `402 Insufficient Balance` looked identical in shape to a config error until the raw JSON-RPC response was inspected directly (the `kagent invoke` CLI itself has a bug parsing this exact error shape in v0.10.1). Lesson: when a CLI's own error handling looks suspicious, drop to `curl` against the underlying API and read the raw response before assuming the setup is wrong.

### Takeaway for Future AI Agents
- On a cluster you didn't just create, check for pre-existing mutating/validating webhooks before installing anything new.
- Don't rely on a CLI's ad-hoc "extra helm args" string env var for structured multi-value overrides — build the values file yourself.
- Never let a secret-bearing command's output (like `helm get values`) get echoed back into a transcript, log, or file without redacting it first.
- "Pods are Ready" is not "the objective is met" — send one real request through the whole path before declaring a key result done.

## 📅 2026-09-10: kagent on Fly.io — k3s-in-a-Machine, two build-time surprises, one runtime surprise

### What went well
- Asking one clarifying question before building — "kagent needs real Kubernetes, Fly.io isn't Kubernetes, how do you want to reconcile that?" — surfaced the user's actual intent (k3s-in-a-Machine) instead of guessing and building the wrong thing. Fly Machines being full Firecracker micro-VMs (not shared-kernel containers) is exactly what makes nested containerd/k3s workable there.
- Kept the runtime image minimal by fetching Helm in a throwaway Alpine build stage and copying only the static binary in, rather than trying to bolt a package manager onto a deliberately minimal BusyBox base.
- For the one HTTPS call the idle-watchdog needs (the Fly Machines stop API) but the base image can't make (no TLS-capable client at all), reused the cluster's own working container runtime — a short-lived `curlimages/curl` pod via `kubectl run --rm` — instead of fighting the base image.

### Gaps & Challenges
- **BusyBox base images can be TLS-crippled in ways that only show up at the exact line that needs HTTPS.** `apk`, `python3`, and even a compiled-without-SSL `wget` all failed differently in `rancher/k3s`. Lesson: when a minimal base image's shell utilities behave oddly on `https://`, check whether the tool was compiled without TLS at all before assuming a syntax or network problem.
- **A working build does not mean a working deployment.** The Helm/kagent install succeeded and pods went healthy, but the very first live agent call failed on DNS — because Fly Machines default to an internal-only resolver (`fdaa::3`) that CoreDNS silently inherited as its upstream. This was invisible until the exact moment an in-cluster pod tried to resolve a public hostname. Lesson: on any new hosting platform, test one real outbound HTTPS call from inside the workload early — don't wait until the feature that needs it is the first thing you test.
- **Environment parity matters for OKRs.** The original OKR said "environment is minikube"; the user later redirected to Fly.io mid-session. Both are now real, documented, DeepSeek-verified deployments (SPEC-016 and SPEC-018) rather than one replacing the other — kept both specs rather than silently overwriting the minikube one, since the user never said to tear it down.

### Takeaway for Future AI Agents
- On any minimal/BusyBox-based container image, verify each tool (`wget`, `curl`, package managers) actually supports HTTPS before relying on it in a Dockerfile `RUN` step — don't assume "has wget" means "can fetch https://".
- On a new hosting platform (first time deploying there), send one real outbound network call from inside the workload as an explicit smoke test — DNS/resolver quirks are platform-specific and invisible from the build log.
- When a user changes the deployment target mid-task, keep the earlier working deployment's spec intact unless told to remove it — document both rather than treating the pivot as a silent replacement.
