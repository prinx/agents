# Bug Fix Playbook

1. Orchestrator determines whether the bug is small and bounded.
2. For a small bug, use fast path: developer, then quality.
3. For unclear impact, cross-cutting behavior, or material design change, use full path: planner, developer, quality.
4. Developer reproduces or writes a focused regression test before the smallest safe fix.
5. Quality records explicit QA and review outcomes.
6. Orchestrator updates state, backlog, and memory. Deployment still requires an explicit human request and passing gates.
