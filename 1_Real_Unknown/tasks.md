# Tasks & Phases

> **Stage 1: Real Unknown** — Project phases and task breakdown managed by the **Real Agent**. Each task is assigned to a specific agent. Complex tasks are coordinated by the Real Agent across multiple agents.

## Phase 1: Framework Bootstrap (Completed)

| ID | Task | Agent | Done |
|----|------|-------|------|
| TSK-001 | Copy the 7-stage delivery-pilot framework from the template | Real Agent | [x] |
| TSK-002 | Replace template placeholders (project name, repo, Pages URL) | Symbols Agent | [x] |
| TSK-003 | Reset `1_Real_Unknown` content to the kagent/minikube problem statement and OKRs | Real Agent | [x] |
| TSK-004 | Pull skills into `.claude/skills` and `.kilo/skills` | Environment Agent | [ ] |

## Phase 2: Environment Setup (Completed — blocked on DeepSeek balance for live output)

| ID | Task | Agent | Coordination | Done |
|----|------|-------|-------------|------|
| TSK-101 | Install minikube + start local cluster | Environment Agent | minikube was already running (Docker driver); reused it | [x] |
| TSK-102 | Install kagent (Helm chart/CLI) into the cluster | Environment Agent | `kagent install --profile demo`, ModelConfig pointed at DeepSeek (OpenAI-compatible). Had to patch the cluster's pre-existing Zarf mutating webhook to exclude the `kagent` namespace (it was rewriting image pulls cluster-wide from unrelated prior work) | [x] |
| TSK-103 | Deploy and run a kagent sample agent | Symbols Agent | `demo` profile deployed 10 sample agents (k8s-agent, helm-agent, istio-agent, etc.), all `Ready`/`Accepted`/`Running`. Live invoke reaches DeepSeek but is blocked by R-010 (insufficient balance) | [x] |

## Phase 3: Design & Specs (Pending)

| ID | Task | Agent | Done |
|----|------|-------|------|
| TSK-104 | Diagram the kagent-on-minikube architecture (Mermaid) | Environment Agent | [ ] |
| TSK-105 | Write SPEC for the kagent install + sample-agent run in `4_Formula/specs.md` | Formula Agent | [ ] |

## Phase 4: Testing & Validation (Pending)

| ID | Task | Agent | Coordination | Done |
|----|------|-------|-------------|------|
| TSK-106 | Run smoke test confirming sample agent reaches Running/Ready | Test Agent | Real Agent coordinates: Test Agent defines pass criteria → Symbols provides deployed agent → Semblance logs any failures | [ ] |
| TSK-107 | Capture setup lessons learned | Semblance Agent | Real Agent coordinates: gathers lessons from all agents → Semblance compiles retrospective | [ ] |

## Task Management Rules

1. **Real Agent owns this file** — breaks the project into phases and tasks, assigns agents, coordinates complex tasks
2. **Every task names its agent** — the Agent column identifies which stage agent is responsible for execution
3. **Complex tasks describe coordination** — tasks involving 2+ agents include a Coordination column explaining how the Real Agent orchestrates the workflow
4. **Status tracking**: `[ ]` Pending, `[x]` Completed, `[~]` In Progress, `[!]` Blocked
5. **Link to specs** — tasks that implement a spec should reference the SPEC-XXX number
6. **Task granularity** — a task should be completable in a single coding session
7. **Real Agent as coordinator** — for complex tasks, the Real Agent defines the scope, dispatches to agents, and validates the result against OKRs
