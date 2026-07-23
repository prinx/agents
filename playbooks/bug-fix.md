# Bug Fix Playbook

1. Orchestrator determines whether the bug is small and bounded.
2. For a small bug, use fast path: developer, then quality.
3. For unclear impact, cross-cutting behavior, or material design change, use full path: planner, developer, quality.
4. Developer reproduces or writes a focused regression test before the smallest safe fix.
5. Quality determines the repository-backed local test path, writes `local-test.md`, and records explicit QA and review outcomes. It reports `BLOCKED` or `PASS_WITH_NOTES` if the path cannot be determined.
6. Orchestrator updates state, backlog, and memory. At completed user-facing work, it gives the human exact local commands and URL from `local-test.md` and does not present a blocked or noted path as fully complete. Deployment still requires an explicit human request and passing gates.
