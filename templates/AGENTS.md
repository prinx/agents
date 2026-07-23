# Project Conventions

- Keep durable project conventions here.
- Store mutable workflow artifacts in `.agents/artifacts/`.
- The orchestrator owns `state.md`; planner initializes project memory; quality generates and owns `local-test.md` from repository evidence.
- Record the selected delivery mode and confirmed material decisions in project memory; do not start a new milestone before the current one is complete and reviewed.
- Commit `requirements.md`, `plan.md`, `backlog.md`, `project-memory.md`, `local-test.md`, and this `AGENTS.md`.
- Do not commit transient `state.md` or `failure-log.md`.
- Deployment requires an explicit human request and passing quality gates.
- Before implementation, inspect Git status and branch in an existing repository; never work on `main` or `master`, and preserve unrelated work.
- Without a repository, ask whether to initialize and explain rollback/branch value. If the human is unsure or requests the default, use `git init -b main`; do not set global identity or commit without explicit human request. Check local identity before a requested baseline commit. A newly initialized repository may remain on `main` until that requested baseline commit, then use task feature branches.
