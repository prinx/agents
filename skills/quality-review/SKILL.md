---
name: quality-review
description: Use when reviewing a ticket diff for correctness, regressions, architecture, security, and maintainability.
---

# Quality Review

Review in three sequential phases. Do not skip a phase.

**Phase 1 — Run tests.** Execute unit, feature, and end-to-end tests. Record exact commands and output. Confirm acceptance criteria are verified. If a test level is not applicable, state why.

**Phase 2 — Inspect the diff.** Focus on correctness (does the code do what the ticket requires?), security (are inputs handled safely?), and scope (did the developer stay within the ticket?). Do not review for subjective style or naming preferences.

**Risk-triggered security and accessibility evidence:** Require evidence only when triggered. Security triggers are authentication, authorization, sessions, secrets/credentials, payments, sensitive personal data, security controls, or an untrusted-input/external-data boundary. Accessibility triggers are a user-facing interface, navigation, form, or interactive control. Record the trigger, change-specific checks, results, and remaining risk: security covers the relevant boundary, access control, data exposure, and safe handling; accessibility covers keyboard path, semantic/accessible name, focus behavior, and visual readability. Missing triggered evidence or an unresolved issue is blocking and requires `REQUEST CHANGES`; non-triggered changes require no evidence. This is not a scanner, formal compliance, performance, reliability, or architecture review.

**Phase 3 — Write artifacts and decide.** Classify findings as blocking (must fix) or advisory (should fix). Write `qa-report.md`, `review.md`, and `local-test.md`. Outcome is `APPROVE` only if no blocking findings exist.

Write actionable findings with severity and location in the diff. Return concise evidence to the orchestrator; keep detailed findings in the review artifact and never claim checks that were not run.
