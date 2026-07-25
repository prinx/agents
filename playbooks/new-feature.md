# New Feature Playbook

1. Orchestrator records `prototype-first` delivery unless the human explicitly requests guided/checkpointed or autonomous delivery.
2. Planner asks only the short questions needed to establish goal, users, constraints, smallest useful first result, and success criteria.
3. Planner creates proposed first-feature requirements, a simple stack, lightweight plan, small backlog, and optional short future-ideas list. The human explicitly approves this first-feature plan.
4. Developer implements the approved first feature test-first without routine confirmations. For user-facing work, use `ui-ux`; choose the smallest working solution and avoid unnecessary infrastructure or abstractions.
5. Quality writes `local-test.md`, QA `PASS`, `FAIL`, `BLOCKED`, or `PASS_WITH_NOTES`, and review `APPROVE` or `REQUEST CHANGES`. It gives the simplest evidence-based test path: a local URL when known, otherwise exact commands and short steps.
6. Orchestrator updates backlog, memory, and state, gives the local test handoff, and asks whether the human wants to test, fix, adjust, or start the next feature. Do not automatically plan or build the next major feature unless autonomous mode was explicitly selected.
7. Pause for approval only for a material scope/goal change; security, cost, privacy, credential, destructive, remote, or deployment decision; or an explicit user-requested checkpoint. Deploy only on explicit human request after both quality gates pass.
