# 📋 Project Kanban Board

> **Stage 1 of 7 (Real Unknown):** Track setup tasks, ongoing development, and pilot status.
> This file is a live Kanban board. AI agents and human developers must keep this updated as they do their work.

---

## 📖 How to Use This Kanban

1. **Move Tasks**: Move task items between sections (`Backlog 📥`, `Planned 📋`, `In Progress 🔄`, `In Review 👀`, `Done ✅`) as work progresses.
2. **Assignee**: Designate who is working on the task (e.g., `Claude`, `Human`).
3. **Traceability**: Link each task to its relevant stage documentation or source code.
4. **Update Logs**: When an AI agent performs a task, they must update this kanban board in the same commit to ensure real-time status accuracy.

---

## 📥 Backlog

- [ ] **TSK-104: Add a second sample agent**
  - **Assignee:** Human / Claude
  - **Details:** Once one sample agent runs cleanly, try a second kagent example to broaden coverage.
  - **Stage Reference:** N/A

---

## 📋 Planned / To Do

- [ ] **TSK-101: Install minikube + start local cluster**
  - **Assignee:** Human / Environment Agent
  - **Details:** Install minikube and kubectl, start a cluster with sufficient resources for kagent.
  - **Stage Reference:** [2_Environment/local_server.md](../2_Environment/local_server.md)

- [ ] **TSK-102: Install kagent into the cluster**
  - **Assignee:** Environment Agent
  - **Details:** Install kagent via its documented Helm chart/CLI, verify CRDs and controller pods are healthy.
  - **Stage Reference:** [2_Environment/architecture.md](../2_Environment/architecture.md)

- [ ] **TSK-103: Deploy and run a kagent sample agent**
  - **Assignee:** Symbols Agent
  - **Details:** Apply a sample agent manifest, confirm it reaches Running/Ready, capture logs/output as evidence.
  - **Stage Reference:** [7_Testing_Known/smoke_tests.md](../7_Testing_Known/smoke_tests.md)

---

## 🔄 In Progress

*No active tasks in progress.*

---

## 👀 In Review

*No tasks awaiting review.*

---

## ✅ Done

- [x] **TSK-001: Bootstrap repo from delivery-pilot-template**
  - **Assignee:** Claude
  - **Details:** Copied the 7-stage framework, replaced placeholders with kAgent project identity.
  - **Stage Reference:** [README.md](../README.md)

---

## ⚙️ Maintenance

- [ ] Go over git commits periodically, reread changed files, and create/update Kanban tasks to stay on track
- [ ] Update the environment folder > 1_Real_Unknown
- [ ] Update the environment folder > 2_Environment
- [ ] Add new features incoming as visuals folder > 3_Simulation
- [ ] Add new ways of doing the implementation to formula folder > 4_Formula
- [ ] Update the Symbols and pay technical debt > 5_Symbols
- [ ] Add new errors in semblance > 6_Semblance
- [ ] Update the tests folder > 7_Testing_Known
