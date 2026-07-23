# Workflow Toolkit

Read `AGENTS.md` and use relevant skills from `.agents/skills`. Follow the artifact-driven workflow: use a developer then quality path for small bounded work; for a new or complex feature, dynamically define and invoke planner, developer, and quality subagents. The planner owns requirements, plan, backlog, and project memory; the orchestrator owns transient state; quality writes QA and review outcomes. Deployment needs an explicit human request and passing quality gates. Follow the Git safety policy in the `branch-safely` skill before implementation.
