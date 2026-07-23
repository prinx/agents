# Release Playbook

1. Confirm all intended backlog tickets are complete, quality artifacts show QA `PASS` and review `APPROVE`, and `local-test.md` provides a valid local test path. `BLOCKED` or `PASS_WITH_NOTES` is not full completion.
2. Update milestone documentation only where behavior or operations changed.
3. Ask for explicit human approval to deploy; do not infer it from release readiness.
4. Build the project, then use the relevant provider procedure, such as `deploy-vercel`.
5. Record release evidence and update dynamic workflow state. Before the final workflow summary, give the human the exact local commands and URL from `local-test.md`, then the next action. Handle monitoring only if requested.
