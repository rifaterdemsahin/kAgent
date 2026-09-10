# Technical Specifications

> **Stage 4: Formula** — Living specs document. All features must be specced here before code touches `5_Symbols`.

## Spec System Rules
1. **Before implementation** — every feature gets a spec entry here
2. **New tasks arriving** — check this file for affected specs, flag changes with `[NEEDS UPDATE]`
3. **Warn on mismatch** — if a task would alter behavior covered by an existing spec, flag and warn before coding
4. **Post-implementation** — update the spec to reflect final decisions
5. **Code drift detection** — After implementation in `5_Symbols`, diff the code against active specs. Flag deviations with `[DRIFT]` and document in `llm_thinking_log.md`
6. **Formulate what you did** — After completing work, always write or update a spec in this file that describes the behavior **as delivered**, then add it to the Formula folder. Standing orders: `5_Symbols/rules/agent_operating_rules.md` (RULE-001). Then commit and push (RULE-002).

---

## Active Specs

### SPEC-001: Two-Menu Navigation Architecture
- **Status:** Active
- **Description:** Project Menu (always visible) + Debug Menu (toggle via bottom-right button, persisted via cookie)
- **Key Behaviors:**
  - **Project Menu** — always visible, shows project-specific links (Home, Docs, API). End-user facing. Every project HTML output must include this menu.
  - **Debug Menu** — hidden by default, toggled via bottom-right debug button. Shows the delivery pilot framework: all 7 stages, agent files, config files. Developer-facing.
  - Both menus read from `navigation_config.json` as a single source of truth
  - Fallback arrays in `index.html` and `5_Symbols/markdown_renderer.html` must stay in sync
  - Search with autocomplete in debug menu
  - `index.html` (root, GitHub Pages entry point) is a **project page** → gets Project Menu + Debug Menu (for developers)
  - `5_Symbols/markdown_renderer.html` renders markdown files → gets both menus so any doc page has full navigation
  - New HTML outputs created by the project should use the shared menu loading code so menus stay consistent
- **Related Files:** `index.html`, `5_Symbols/markdown_renderer.html`, `navigation_config.json`, `4_Formula/navigation.md`
- **Last Updated:** 2026-07-12

### SPEC-002: Markdown Renderer with GitHub Edit
- **Status:** Active
- **Description:** `5_Symbols/markdown_renderer.html` renders any markdown file via URL query parameter, with Edit on GitHub button. Lives in `5_Symbols` (it is source code, not a root entry point); only `index.html` stays at the root for GitHub Pages.
- **Key Behaviors:**
  - Loads markdown from `?file=` query parameter; the parameter is always a **root-relative** path (e.g. `1_Real_Unknown/risks.md`)
  - All internal fetches/links inside the renderer are prefixed with `../` (site root is one level up from the renderer)
  - Renders via marked.js + PrismJS syntax highlighting
  - "Edit on GitHub" button derives `{user}/{repo}` from `location.hostname`/`pathname` on `*.github.io` (template-reusable); falls back to the configured repo when served locally
  - Debug menu toggle available in renderer
- **Related Files:** `5_Symbols/markdown_renderer.html`, `index.html`, `navigation_config.json`
- **Last Updated:** 2026-07-12

### SPEC-003: Image Carousel
- **Status:** Active
- **Description:** Auto-updating image carousel on `index.html` loaded dynamically from `3_Simulation/`
- **Key Behaviors:**
  - Reads image list from `carousel_config.json`
  - Supports `.png`, `.jpg`, `.gif`, `.webp`
  - Manual navigation with prev/next buttons
  - Auto-advance with CSS transitions
- **Related Files:** `index.html`, `3_Simulation/carousel_config.json`
- **Last Updated:** 2026-05-30

### SPEC-004: Secrets Management via Azure Key Vault
- **Status:** Active
- **Description:** All secrets stored in Azure Key Vault, loaded at runtime, never in git
- **Key Behaviors:**
  - `.env.example` lists required variables with empty values
  - Secrets loaded via Azure SDK or GitHub Actions
  - One Key Vault per environment (dev/staging/prod)
  - Supabase keys, Axiom tokens, Fly.io tokens, Cloudflare tokens, and Azure Storage keys all in Key Vault
  - Fly.io and Cloudflare Workers both take credentials from Key Vault (SPEC-012 / RULE-003)
- **Related Files:** `.env.example`, `2_Environment/setup_azure.md`, `5_Symbols/rules/agent_operating_rules.md`
- **Last Updated:** 2026-09-10

### SPEC-005: Specs System (this file)
- **Status:** Active
- **Description:** All features must be specced in `4_Formula/specs.md` before implementation. New tasks check specs, flag updates, warn on conflicts.
- **Key Behaviors:**
  - Spec lives in `4_Formula/specs.md`
  - New tasks check for affected specs
  - `[NEEDS UPDATE]` flag for specs requiring changes
  - Warning emitted when a task contradicts an active spec
  - After delivery, formulate what was done as a spec in this file (RULE-001 / SPEC-011)
- **Related Files:** `4_Formula/specs.md`, `AGENTS.md`, all agent persona files, `5_Symbols/rules/agent_operating_rules.md`
- **Last Updated:** 2026-09-10

### SPEC-006: Stage Dependency Chain (1 → 2 → 3)
- **Status:** Active
- **Description:** Defines how upstream stages feed each other and what each stage contributes to the downstream stages.
- **Key Behaviors:**
  - `1_Real_Unknown` defines the objective: problem statement, OKRs, hypotheses, and open questions. This drives what tools and environment are needed.
  - `2_Environment` defines the tooling: blueprints, architecture (Mermaid/Excalidraw), setup guides, dependencies, libraries, and packages. Changes here determine what is possible in 3_Simulation designs.
  - `3_Simulation` defines the vision: visual designs, mockups, wireframes, flow diagrams. These must reflect both the objectives (from stage 1) and the technical constraints (from stage 2).
  - The chain flows: `1_Real_Unknown` (why) → `2_Environment` (what tools) → `3_Simulation` (visual vision) → `4_Formula` (specs + approval) → `5_Symbols` (code).
  - When a dependency changes in stage 2 (e.g., a new library or tool), stage 3 designs must be reviewed for compatibility and updated if needed.
  - Stage 1 OKR changes ripple through stage 2 (do we need new tools?) and stage 3 (does the design still match the objective?).
- **Related Files:** `1_Real_Unknown/problem_statement.md`, `1_Real_Unknown/okrs.md`, `2_Environment/architecture.md`, `2_Environment/dependencies.md`, `2_Environment/tools.md`, `3_Simulation/design_workflow.md`, `4_Formula/specs.md`
- **Last Updated:** 2026-07-11

### SPEC-007: Code Drift Detection
- **Status:** Active
- **Description:** Formula Agent identifies when code in `5_Symbols` deviates from active specs in `specs.md`
- **Key Behaviors:**
  - After `5_Symbols` implementation, compare code behavior against the active spec
  - Any deviation is flagged with `[DRIFT]` in the relevant spec entry
  - Drift is documented in `llm_thinking_log.md` with the gap analysis
  - Drift must be resolved before the spec gate passes (spec + designs reviewed)
  - If drift is intentional, update the spec first to capture the new behavior, then flag drift as resolved
- **Related Files:** `4_Formula/specs.md`, `4_Formula/llm_thinking_log.md`, `5_Symbols/*`
- **Last Updated:** 2026-07-11

### SPEC-008: Template-Adapted Smoke Test Runner
- **Status:** Active
- **Description:** A dependency-free Python script (`5_Symbols/toolbox/smoke_test.py`) that scans the project's pages and structure, runs the smoke test suite, and generates `6_Semblance/smoke_test_report.md`. Template-adapted: it reads `navigation_config.json` as its source of truth, so any project bootstrapped from this template gets working smoke tests without code changes.
- **Key Behaviors:**
  - Reads `navigation_config.json` (projectMenu + debugMenu) and derives the page/file inventory from it — no hardcoded file lists
  - Checks: config JSON validity, every menu URL resolves to an existing file/folder, required root files exist (`index.html`, `markdown_renderer.html`, `README.md`, `robots.txt`, `sitemap.xml`), social links present in `index.html`, GitHub Pages URL present in `README.md`, 3-way navigation sync (config = `index.html` fallback = `markdown_renderer.html` fallback), stage markdown files not orphaned from the debug menu, no committed secrets patterns, **Root Layout (RULE-005)** — no extra top-level folders/files outside the allowed set
  - Optional `--base-url` mode fetches the deployed site over HTTP and verifies pages return 200 (cloud smoke test); default mode is local filesystem
  - Writes results to `6_Semblance/smoke_test_report.md` in the report format defined in `7_Testing_Known/smoke_tests.md`; exit code 0 = all pass, 1 = failures (CI gate compatible)
  - Failures must be raised as GitHub Issues per the Smoke Tests & GitHub Issues rule
- **Related Files:** `5_Symbols/toolbox/smoke_test.py`, `6_Semblance/smoke_test_report.md`, `7_Testing_Known/smoke_tests.md`, `navigation_config.json`
- **Last Updated:** 2026-09-10

### SPEC-009: Sanity Check Report Loop (7 → 1)
- **Status:** Active
- **Description:** The canonical sanity check report lives in `1_Real_Unknown/sanity_check_report.md`, owned by the Real Agent's sanity check sub-agent. Stage 7 (`7_Testing_Known`) produces the validation data (smoke test results, validation reports, logic chains); the Real Agent consumes that data and publishes the report in Stage 1 — completing the 7 → 1 loop back to the "why".
- **Key Behaviors:**
  - `7_Testing_Known/sanity_check_report.md` is a data-source pointer document, not the report itself; historical reports move to `7_Testing_Known/_obsolete/`
  - The Stage-1 report cites its Stage-7 data inputs (`smoke_tests.md`, `validation_report.md`, `logic.md`, latest `6_Semblance/smoke_test_report.md`)
  - Every sanity check run updates `1_Real_Unknown/risks.md` (new risks added, solved risks moved)
  - Loop: 1 (objectives) → … → 7 (test evidence) → 1 (sanity verdict against objectives)
- **Related Files:** `1_Real_Unknown/sanity_check_report.md`, `1_Real_Unknown/risks.md`, `7_Testing_Known/sanity_check_report.md`, `6_Semblance/smoke_test_report.md`
- **Last Updated:** 2026-07-12

### SPEC-010: Template Consumption by Downstream Projects
- **Status:** Active
- **Description:** This repository is a **template** — other projects start from it. Every consumer-facing file must be reusable without manual archaeology: placeholders are explicit, project-specific values are concentrated, and each agent persona file tells the consumer LLM agent how to bootstrap.
- **Key Behaviors:**
  - All 5 agent files (`agents.md`, `claude.md`, `gemini.md`, `copilot.md`, `kilocode.md`) carry a "Using This Template" section with the placeholder table and bootstrap steps for consumer LLM agents
  - Standard placeholders: `{{PROJECT_NAME}}`, `{{GITHUB_USER}}`, `{{REPO_NAME}}`, `{{PAGES_URL}}`, `{{LINKEDIN_URL}}`, `{{YOUTUBE_URL}}` — consumers search-and-replace these six values
  - Project-specific values live in: `navigation_config.json` (projectMenu), `index.html` (social links, titles), `README.md` (Pages URL), `sitemap.xml`/`robots.txt` (absolute URLs), `supabase/config.toml` under `2_Environment/` (project id)
  - Runtime code must not hardcode the repo where it can derive it (e.g. renderer's GitHub edit URL derives user/repo from the Pages URL)
  - Bootstrap validation: run `python3 5_Symbols/toolbox/smoke_test.py` after replacing placeholders — it is config-driven and needs no adaptation
  - CI/CD is owned by the **Formula Agent**: `.github/workflows/static.yml` runs the smoke test gate, then deploys to GitHub Pages (Continuous Integration → Continuous Delivery → Continuous Deployment)
  - **Refactor / Init prompts** live in `README.md` and must tell the consumer agent to follow RULE-001–005, use Key Vault `/vaults/dp-kv-deliverypilot/secrets` (do not create a new vault), place files in allowed root folders, then nav-sync + smoke-test + commit/push
- **Related Files:** `agents.md`, `claude.md`, `gemini.md`, `copilot.md`, `kilocode.md`, `.github/workflows/static.yml`, `5_Symbols/toolbox/smoke_test.py`, `README.md`
- **Last Updated:** 2026-09-10

### SPEC-011: Agent Operating Rules (Spec What You Did + Commit/Push)
- **Status:** Active
- **Description:** All agents load `5_Symbols/rules/agent_operating_rules.md` at session start. Standing orders include formulate-as-spec, commit/push, backend deploy target, and default Azure storage.
- **Key Behaviors:**
  - **RULE-001** — After completing work, write or update a `SPEC-XXX` in `4_Formula/specs.md` that describes the behavior as delivered (not only as planned). Docs-only and process work still get a spec or spec update. Reasoning goes in `4_Formula/llm_thinking_log.md`.
  - **RULE-002** — After every logical change, commit and push. Do not batch unrelated changes. If git errors occur, troubleshoot until the push succeeds. Never force-push `main`. Never commit secrets. Follow `5_Symbols/rules/git_conventions.md`.
  - **RULE-003 / RULE-004** — Backend deploy and default storage are specified in SPEC-012.
  - **RULE-005** — Allowed root folders and move-extras are specified in SPEC-013.
  - Agents read the operating-rules file together with `agents.md` and the LLM persona file. The coordinator (`agents.md`) points at this file; it does not replace the 7-stage flow.
  - Debug menu lists the operating-rules file under Stage 5 (`5_Symbols/rules/`).
- **Related Files:** `5_Symbols/rules/agent_operating_rules.md`, `5_Symbols/rules/git_conventions.md`, `4_Formula/specs.md`, `4_Formula/llm_thinking_log.md`, `agents.md`
- **Last Updated:** 2026-09-10

### SPEC-012: Backend Deploy Target + Azure Project Storage
- **Status:** Active
- **Description:** Apps with a backend deploy to Fly.io or Cloudflare Workers based on requirements. Heavy container workloads go to Fly.io. Both platforms take credentials from Azure Key Vault. Default file/blob storage is Azure project-based storage.
- **Key Behaviors:**
  - Static frontends stay on GitHub Pages. Backend services choose **Cloudflare Workers** (lightweight, stateless, edge) or **Fly.io** (Docker / persistent / heavy containers).
  - Heavy container requirements (Docker, filesystem, WebSockets, GPU, long-running jobs) **must** deploy to Fly.io.
  - Fly.io and Cloudflare Workers load all credentials from **Azure Key Vault** — never from git, Worker source, Docker images, or committed config.
  - **Default storage** is Azure project-based storage (Storage account / blob containers scoped to this project). Fly volumes, Cloudflare R2, local disk, and git LFS are not the default. Structured data may still use Supabase; exceptions go in `4_Formula/decisions.md`.
- **Related Files:** `5_Symbols/rules/agent_operating_rules.md`, `2_Environment/fly_io.md`, `2_Environment/cloudflare_workers.md`, `2_Environment/setup_azure.md`, `2_Environment/architecture.md`, `4_Formula/specs.md` (SPEC-004)
- **Last Updated:** 2026-09-10

### SPEC-013: Allowed Root Folders (Move Extras Into Stages)
- **Status:** Active
- **Description:** The only allowed root folders are `.claude/skills`, `.github/workflows`, `.kilo/skills`, and the seven stage folders. Agents must move any other root file or folder into the related subfolder of those. A small set of root *files* stays for GitHub Pages, git, and the coordinator.
- **Key Behaviors:**
  - **RULE-005** — Do not create new top-level project folders. Place new work inside the matching allowed folder.
  - Placement: OKRs/tasks → `1_Real_Unknown/`; architecture/tools → `2_Environment/`; designs → `3_Simulation/`; specs → `4_Formula/`; code → `5_Symbols/`; errors/lessons → `6_Semblance/`; tests → `7_Testing_Known/`; Claude skills → `.claude/skills/`; Actions → `.github/workflows/`; Kilo skills → `.kilo/skills/`.
  - After a move: `git mv`, update references, run `nav_sync.py` if a markdown path changed, commit and push.
  - Root **files** that stay: `index.html`, `README.md`, `robots.txt`, `sitemap.xml`, `.gitignore`, `.env.example`, `navigation_config.json`, `agents.md` + LLM persona files. `markdown_renderer.html` stays in `5_Symbols/`.
  - Tool caches (`.antigravitycli/`, `node_modules/`, `.env`) are gitignored, not stage folders.
  - Kilo config lives at `.kilo/kilo.json` (not the repo root). Smoke test **Root Layout (RULE-005)** fails if extra root files or folders appear.
- **Related Files:** `5_Symbols/rules/agent_operating_rules.md`, `5_Symbols/rules/file_organization.md`, `agents.md`, `5_Symbols/toolbox/smoke_test.py`, `README.md`
- **Last Updated:** 2026-09-10

### SPEC-014: kAgent Project Init (kagent on minikube) + DeepSeek Model Backend
- **Status:** Active
- **Description:** This repo (`kAgent`) was initialized from `delivery-pilot-template` with the objective of installing kagent (a Kubernetes-native agent framework) on minikube and running a sample agent, sourced from public open-source libraries only. The sample agent's LLM backend is the DeepSeek API.
- **Key Behaviors:**
  - Template placeholders replaced (`README.md`, `index.html`, `sitemap.xml`, `robots.txt`) with kAgent's project identity; `agents.md`'s own explanation of the template origin is left untouched.
  - `1_Real_Unknown` (`problem_statement.md`, `okrs.md`, `hypotheses.md`, `questions.md`, `kanban.md`, `tasks.md`, `risks.md`) reset to the kagent/minikube goal, replacing template-authoring history with this project's actual OKRs and risks.
  - **DeepSeek as model backend:** DeepSeek's hosted API is OpenAI-compatible (`base_url` swap, no bespoke SDK) — see `2_Environment/deepseek.md`. The API key already exists in Azure Key Vault (`/vaults/dp-kv-deliverypilot/secrets`) and must be loaded into the cluster as a Kubernetes `Secret` at deploy time, never hardcoded in a manifest (RULE-003/004).
  - Recorded as ADR-002 in `4_Formula/decisions.md`.
- **Related Files:** `README.md`, `1_Real_Unknown/*`, `2_Environment/deepseek.md`, `4_Formula/decisions.md`, `4_Formula/llm_thinking_log.md`
- **Last Updated:** 2026-09-10

### SPEC-015: Vendored Skills from anthropics/skills
- **Status:** Active
- **Description:** Pulled `mcp-builder` and `webapp-testing` skills from the official [anthropics/skills](https://github.com/anthropics/skills) repo into `.claude/skills/`, with matching pointer files in `.kilo/skills/`.
- **Key Behaviors:**
  - `.claude/skills/mcp-builder/` and `.claude/skills/webapp-testing/` are full vendored copies (SKILL.md, reference/examples/scripts, LICENSE.txt) — use them as-is; do not fork/rewrite the upstream guides in place.
  - `.kilo/skills/mcp-builder.md` and `.kilo/skills/webapp-testing.md` are short pointers (this project's Kilo-skill style) referencing the vendored Claude skills — not duplicates of the full guide.
  - Registered in `2_Environment/superskills.md` (catalog table) and `.kilo/kilo.json` (skills array).
  - `mcp-builder` applies when the kagent sample agent needs a custom tool/MCP server; `webapp-testing` applies when verifying a kagent UI/dashboard (via `kubectl port-forward`) in a real browser, complementing the static-only `smoke_test.py`.
- **Related Files:** `.claude/skills/mcp-builder/`, `.claude/skills/webapp-testing/`, `.kilo/skills/mcp-builder.md`, `.kilo/skills/webapp-testing.md`, `2_Environment/superskills.md`, `.kilo/kilo.json`
- **Last Updated:** 2026-09-10

### SPEC-016: kagent Installed on minikube, Wired to DeepSeek, Sample Agents Deployed
- **Status:** Active — **KR 2.2 blocked on DeepSeek account balance (R-010)**
- **Description:** kagent (Helm chart `0.10.1`, `demo` profile) is installed in the `kagent` namespace of the existing local minikube cluster. `ModelConfig/default-model-config` targets DeepSeek via kagent's `OpenAI` provider type with `openAI.baseUrl` overridden. 10 sample `Agent` CRs are deployed and `Ready`/`Accepted`/`Running`.
- **Key Behaviors:**
  - Reused the pre-existing `minikube` profile rather than creating a second cluster.
  - Installed via `kagent install --profile demo`; the DeepSeek key was pulled from Azure Key Vault (`az keyvault secret show --vault-name dp-kv-deliverypilot --name deepseek-api-key`) directly into an env var — never printed or written to a committed file.
  - **Cluster conflict fixed:** this minikube cluster already carried a Zarf mutating webhook (from unrelated prior `zarf`/`hello-world` work) that rewrites image pulls in every namespace except `kube-system`. It broke every kagent pod with `ImagePullBackOff`. Fixed by patching the `agent-pod.zarf.dev` webhook's `namespaceSelector` to also exclude the `kagent` namespace (`kubectl patch mutatingwebhookconfigurations zarf --type=json ...`) — a minimal, reversible, namespace-scoped exclusion; `zarf`/`hello-world` namespaces are untouched.
  - **Helm values bug fixed:** the kagent CLI's `KAGENT_HELM_EXTRA_ARGS` env var does a naive `strings.Split` on the literal `"--set"`, so surrounding whitespace leaks into the split values. This corrupted the first install (stray `' providers'` top-level key, trailing space in the model name). Fixed with a direct `helm upgrade` using a clean values file instead of relying on that CLI env var for multi-value overrides.
  - **Verified end-to-end**, not just pod readiness: port-forwarded the controller and sent a real `message/send` JSON-RPC call. Confirmed the full path works (kagent → ModelConfig → DeepSeek's `/chat/completions`) — DeepSeek returned `402 Payment Required — Insufficient Balance`, a billing/funding issue on the DeepSeek account, not a configuration defect.
  - The `kagent` CLI's own `invoke` subcommand has a client-side bug parsing this error shape (`json: cannot unmarshal object into Go struct field ClientResponse.error.data`) in v0.10.1 — worked around by calling the controller's JSON-RPC endpoint directly.
- **Related Files:** `2_Environment/architecture.md` (kagent-on-minikube Architecture section), `2_Environment/deepseek.md`, `1_Real_Unknown/risks.md` (R-010), `1_Real_Unknown/tasks.md`, `4_Formula/llm_thinking_log.md`
- **Last Updated:** 2026-09-10

### SPEC-017: Agent Status Page + kagent vs Azure SRE Agent Comparison Page
- **Status:** Active
- **Description:** Two static HTML pages published under `5_Symbols/`, linked from the Project Menu (always-visible nav) so a visitor sees, without digging through markdown, which agents are deployed and how kagent compares to Azure SRE Agent on cost/capability.
- **Key Behaviors:**
  - `5_Symbols/agent_status.html` is a **static snapshot** (explicitly labeled as such — GitHub Pages cannot reach a local minikube cluster) of the 2026-09-10 install: platform pod table, all 10 sample-agent CRs and their Ready/Accepted/Running state, and the live-invoke test result (reaches DeepSeek, blocked by R-010).
  - `5_Symbols/comparison_kagent_vs_azure_sre.html` compares cost (kagent: $0 license + your compute/LLM bill vs Azure SRE Agent: ~4 AAU/agent-hour baseline, illustrative ~$288–292/agent/month before any work, per Microsoft's own published example rate) and capability, cited to Microsoft's own SRE Agent product and pricing docs (accessed 2026-09-10).
  - Both pages registered in the Project Menu in all three nav sources (`navigation_config.json`, `index.html` fallback, `5_Symbols/markdown_renderer.html` fallback) to keep `smoke_test.py`'s Menu Links Resolve / Nav sync checks green.
  - Internal links to project markdown docs go through `markdown_renderer.html?file=...` (rendered), not raw `.md` files.
- **Related Files:** `5_Symbols/agent_status.html`, `5_Symbols/comparison_kagent_vs_azure_sre.html`, `navigation_config.json`, `index.html`, `5_Symbols/markdown_renderer.html`
- **Last Updated:** 2026-09-10

### SPEC-018: kagent on Fly.io (k3s-in-a-Fly-Machine) with 3-Hour Idle Auto-Stop
- **Status:** Active — deployed and DeepSeek-verified
- **Description:** Runs kagent on Fly.io per RULE-003 ("heavy containers → Fly.io"), reconciling that with kagent's hard requirement for a real Kubernetes API by running single-node **k3s inside one Fly Machine** (Fly Machines are Firecracker micro-VMs, not shared-kernel containers, which is what makes nested containerd/k3s workable). This is a deliberate deviation from the original "environment is minikube" OKR wording, done at explicit user request; minikube setup (SPEC-016) remains valid and documented separately — both deployments now exist independently.
- **Key Behaviors:**
  - App `kagent-k3s` in the `personal` Fly org, region `lhr`, VM size `shared-cpu-4x` / 8GB RAM, with a 10GB persistent volume (`kagent_k3s_data`) for k3s's data dir so a Machine restart doesn't lose cluster state.
  - `Dockerfile` uses a **multi-stage build**: `rancher/k3s` (a minimal BusyBox image — no package manager, no bash, and a `wget` compiled without TLS support) is the runtime base; Helm's static binary is fetched in a throwaway `alpine:3.20` stage (which has real `curl`) and copied in via `COPY --from=`. kubectl ships with the k3s image already.
  - `entrypoint.sh` (POSIX `sh`, not bash — none available) first overwrites `/etc/resolv.conf` with public DNS (`1.1.1.1`, `8.8.8.8`) — **required** because Fly Machines default to an internal-only 6PN resolver that only resolves `*.internal` names, which k3s's CoreDNS otherwise inherits as its upstream forwarder, breaking every external LLM API call. Then starts `k3s server` (Traefik disabled), waits for the API, installs `kagent-crds` then `kagent` (demo profile) via Helm with the same DeepSeek `ModelConfig` override pattern as SPEC-016 (`providers.openAI.model=deepseek-chat`, `.config.baseUrl=https://api.deepseek.com`), then `kubectl port-forward --address 0.0.0.0` exposes `kagent-ui` on :8080 (Fly's `http_service.internal_port`) and `kagent-controller` on :8083 within the Machine's own network namespace.
  - **Secrets from Azure Key Vault, never committed:** `DEEPSEEK_API_KEY` (from `dp-kv-deliverypilot/deepseek-api-key`) and `FLY_API_TOKEN` (from `dp-kv-deliverypilot/FLYIOTOKEN`) are set via `fly secrets set` directly from the vault into Fly's own secret store — not written to `fly.toml` or any file in this repo.
  - **3-hour idle auto-stop (explicit user requirement):** `idle-watchdog.sh` (POSIX `sh` — no Python/jq in this image) runs inside the Machine. Once uptime exceeds `IDLE_STOP_HOURS` (default 3), it polls every 5 minutes whether `kubectl logs --since=${IDLE_STOP_HOURS}h` on `kagent-controller` contains any `/api/a2a/...` request (an agent invoke); if none, it stops the Machine via the Fly Machines REST API. Since this BusyBox image has no TLS-capable HTTP client at all, that one HTTPS call is made by spinning up a short-lived `curlimages/curl` pod with `kubectl run --rm`, passing `FLY_API_TOKEN`/`FLY_APP_NAME`/`FLY_MACHINE_ID` (the latter two auto-injected by Fly into every Machine) as env vars — reusing the cluster's own working container runtime rather than bundling a static TLS client into the node image. This is a custom watchdog, not Fly's native `auto_stop_machines` connection-based idling, which reacts to dropped HTTP connections on a much shorter timescale and doesn't map to "3 hours of no agent usage."
  - `fly.toml` sets `auto_stop_machines = false` deliberately so Fly's own proxy-driven auto-stop doesn't fight the custom watchdog; `min_machines_running = 0` still lets the Machine stay stopped between uses.
  - **Verified end-to-end:** a live `message/send` call to `k8s-agent` on `https://kagent-k3s.fly.dev` returned a correct, DeepSeek-generated answer (see `7_Testing_Known/deployment_timeline.md`).
- **Related Files:** `5_Symbols/kagent-flyio/Dockerfile`, `5_Symbols/kagent-flyio/entrypoint.sh`, `5_Symbols/kagent-flyio/idle-watchdog.sh`, `5_Symbols/kagent-flyio/fly.toml`, `2_Environment/fly_io.md`, `2_Environment/architecture.md`, `7_Testing_Known/deployment_timeline.md`
- **Last Updated:** 2026-09-10

---

## Spec Template

```markdown
### SPEC-XXX: [Feature Name]
- **Status:** Active | Draft | Deprecated
- **Description:** What this feature does
- **Key Behaviors:**
  - Behavior point 1
  - Behavior point 2
- **Related Files:** `path/to/file`
- **Last Updated:** YYYY-MM-DD
```
