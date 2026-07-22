# New Feature Playbook

1. Orchestrator classifies the request as full path and records state.
2. Planner creates or updates requirements, plan, backlog, and project memory; orchestrator relays any question batch to the human.
3. Human resolves material scope or irreversible design decisions.
4. Developer implements one ready ticket test-first.
5. Quality writes QA `PASS` or `FAIL` and review `APPROVE` or `REQUEST CHANGES`.
6. Orchestrator updates backlog, memory, and state. Repeat tickets as needed.
7. Update documentation only at a meaningful milestone. Deploy only on explicit human request after both quality gates pass.
