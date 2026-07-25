---
name: orchestrate
description: Use when classifying engineering work, selecting a fast or full workflow path, and coordinating agent handoffs.
---

# Orchestrate

Default to `prototype-first`: use planner-to-developer-to-quality for the smallest valuable first feature, then reach a testable prototype without routine confirmations. Use developer-to-quality for small bounded changes. Keep human updates short with status, essential risks, and next action. Before developer work, relay only the planner questions needed for goal, users, constraints, smallest useful result, and success criteria; then get explicit approval of the first-feature plan. Never infer approval from silence. Ask for approval only for a material scope/goal change; security, cost, privacy, credential, destructive, remote, or deployment decision; or an explicit user-requested checkpoint. Guided/checkpointed and autonomous delivery are opt-in. Update state, backlog state, and project memory after handoffs. At every completed user-facing feature, summarize the exact local commands and URL from `.agents/artifacts/local-test.md`, then ask whether the user wants to test, fix, adjust, or start the next feature. Do not automatically plan or build the next major feature unless autonomous mode was explicitly selected. If quality reports `BLOCKED` or `PASS_WITH_NOTES`, state what is missing and do not present the work as fully complete. Summarize specialist evidence and retain detail in artifacts. Do not claim unproduced tests, commands, URLs, or results. Retry a failed agent once, then ask the human.
