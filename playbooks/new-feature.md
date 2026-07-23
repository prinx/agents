# New Feature Playbook

1. Orchestrator classifies the request as full path and records state.
2. Planner creates or updates requirements, plan, backlog, and project memory; orchestrator relays any question batch to the human.
3. At planning approval, human resolves material decisions and selects checkpointed or autonomous delivery if not already stated; orchestrator records the choice.
4. Before each milestone, orchestrator checks it against requirements and confirmed decisions. In checkpointed delivery, the human reviews before it starts.
5. Developer implements one ready ticket test-first and gives quality discovered local-test evidence. Quality writes `local-test.md`, QA `PASS`, `FAIL`, `BLOCKED`, or `PASS_WITH_NOTES`, and review `APPROVE` or `REQUEST CHANGES`.
6. Orchestrator updates backlog, memory, and state. At each completed user-facing milestone, summarize the exact local commands and URL from `local-test.md` to the human; do not call `BLOCKED` or `PASS_WITH_NOTES` work fully complete. Complete and review the milestone before starting the next; in checkpointed delivery, the human reviews the completed milestone.
7. Update documentation only at a meaningful milestone. Deploy only on explicit human request after both quality gates pass.
