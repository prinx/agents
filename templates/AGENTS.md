# Project Conventions

- Keep durable project conventions here.
- Store mutable workflow artifacts in `.agents/artifacts/`.
- The orchestrator owns `state.md`; planner initializes project memory; quality generates and owns `local-test.md` from repository evidence.
- Default to `prototype-first`: approve the smallest first-feature plan, then implement and test it without routine confirmation. Record the selected delivery mode and confirmed material decisions in project memory. Guided/checkpointed and autonomous delivery require an explicit request.
- Ask for approval only for the first-feature plan, material scope or goal changes, security/cost/privacy/credential decisions, destructive or remote actions, deployment, or an explicit user-requested checkpoint.
- After each completed user-facing feature, give the simplest actual local test path and ask whether the user wants to test, fix, adjust, or start the next feature. Do not automatically build the next major feature unless autonomous delivery was explicitly selected.
- Commit `requirements.md`, `plan.md`, `backlog.md`, `project-memory.md`, `local-test.md`, and this `AGENTS.md`.
- Do not commit transient `state.md` or `failure-log.md`.
- Deployment requires an explicit human request and passing quality gates.
- Before implementation, inspect Git status and branch in an existing repository; never work on `main` or `master`, and preserve unrelated work.
- Without a repository, ask whether to initialize and explain rollback/branch value. If the human is unsure or requests the default, use `git init -b main`; do not set global identity or commit without explicit human request. Check local identity before a requested baseline commit. A newly initialized repository may remain on `main` until that requested baseline commit, then use task feature branches.
- Developer and quality may inspect project files, use normal non-force branch commands, stage changes, run known local build, test, and dev commands, and list Docker containers or images without repeated approval. Package installation, publishing, destructive, remote, and secret-related commands ask first. Ask before commits, remote Git operations, sensitive Docker commands, external-system actions not explicitly requested, and deployment.
- Ask before reading, searching, or scanning `.env`, `.env.*`, `.secrets`, `*.secrets`, `*.pem`, `*.key`, credential-named paths, `secrets/`, `.ssh/`, `.aws/`, or similar credential locations. Never print, copy, log, or report secrets.
