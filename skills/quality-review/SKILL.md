---
name: quality-review
description: Use when reviewing a ticket diff for correctness, regressions, architecture, security, and maintainability.
---

# Quality Review

Review the diff against ticket acceptance criteria and project conventions. Prioritize correctness, security, architecture alignment, maintainability, and scope. Confirm quality has documented an evidence-based local test path in `.agents/artifacts/local-test.md` before a final user-facing `PASS`. Write actionable findings with severity and produce only `APPROVE` or `REQUEST CHANGES`. Return concise evidence to the orchestrator; keep detailed findings in the review artifact and never claim checks that were not run.
