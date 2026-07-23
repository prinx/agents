# New Feature Playbook

1. Orchestrator classifies the request as full path and records state.
2. Planner creates or updates requirements, plan, backlog, and project memory; orchestrator relays any question batch to the human.
3. At planning approval, human resolves material decisions and selects checkpointed or autonomous delivery if not already stated; orchestrator records the choice.
4. Before each milestone, orchestrator checks it against requirements and confirmed decisions. In checkpointed delivery, the human reviews before it starts.
5. Developer implements one ready ticket test-first; quality writes QA `PASS` or `FAIL` and review `APPROVE` or `REQUEST CHANGES`.
6. Orchestrator updates backlog, memory, and state. Complete and review the milestone before starting the next; in checkpointed delivery, the human reviews the completed milestone.
7. Update documentation only at a meaningful milestone. Deploy only on explicit human request after both quality gates pass.
