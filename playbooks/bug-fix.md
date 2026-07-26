# Bug Fix Playbook

1. Orchestrator receives the bug report. Before routing any code changes, diagnose where the problem actually is.
2. **Diagnose first**: check environment (is the server running, is Docker up, is the database connected), check configuration (are environment variables set, is the config valid), check for user error (is the user doing the right thing). Only after confirming the problem is in the code should code changes begin. If the problem is not in the code, state the actual cause and how to fix it without code changes.
3. Once the diagnosis confirms a code issue, orchestrator determines whether the bug is small and bounded.
4. For a small bug, use fast path: developer, then quality.
5. For unclear impact, cross-cutting behavior, or material design change, use full path: planner, developer, quality.
6. Orchestrator identifies which skills match the bug context and tells the developer to load them (for example `ui-ux` for a UI bug, `unit-testing` for logic bugs).
7. Developer reproduces the bug, then writes regression tests at all three applicable levels before the fix:
   - **Unit test**: a focused test that reproduces the bug in the isolated logic. Confirm it fails.
   - **Feature test**: a test that reproduces the broken behavior against the acceptance criteria. Confirm it fails.
   - **End-to-end test**: a test that reproduces the exact user scenario that triggered the bug in the real application. Confirm it fails.
   If a level is not applicable (for example no UI for a pure library), skip it and note why.
8. Developer applies the smallest safe fix, then confirms all regression tests pass at each level.
9. Quality runs all three test levels, verifies the regression tests exist and pass, and confirms the original bug scenario is fixed. It determines the repository-backed local test path, writes `local-test.md`, and records explicit QA and review outcomes. It reports `BLOCKED` or `PASS_WITH_NOTES` if the path cannot be determined or if regression tests are missing.
10. Orchestrator updates state, backlog, and memory. At completed user-facing work, it gives the human exact local commands and URL from `local-test.md` and does not present a blocked or noted path as fully complete. Deployment still requires an explicit human request and passing gates.
