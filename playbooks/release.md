# Release Playbook

1. Confirm all intended backlog tickets are complete and quality artifacts show QA `PASS` and review `APPROVE`.
2. Update milestone documentation only where behavior or operations changed.
3. Ask for explicit human approval to deploy; do not infer it from release readiness.
4. Build the project, then use the relevant provider procedure, such as `deploy-vercel`.
5. Record release evidence and update dynamic workflow state. Handle monitoring only if requested.
