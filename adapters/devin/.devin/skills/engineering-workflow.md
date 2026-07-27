---
name: engineering-workflow
description: Full engineering workflow — diagnose, classify, develop, quality review, report. Use for all engineering tasks.
trigger: When working on any engineering task, feature, bug fix, or code change in this repository.
---

# Engineering Workflow

Follow these phases in order. Never skip a phase.

## Hard gates
1. Developer always hands off to quality.
2. Quality must produce qa-report.md and review.md.
3. Never declare work done without quality artifacts.
4. Never skip the quality phase.

## Phase 1 — Diagnose
When something is broken, establish where the problem is before changing code. Check: environment (server running, Docker up, database connected), configuration (env vars set, config valid), user error, then code.

## Phase 2 — Classify
- Tier 1 (bounded, obvious): go to Phase 3.
- Tier 2 (unclear): ask 1-2 questions, then Phase 3.
- Tier 3 (complex): plan first, get approval, then Phase 3.

## Phase 3 — Develop
Work test-first at three levels:
- Unit tests: failing test → implement → pass. Cover edge cases.
- Feature tests: verify each acceptance criterion.
- E2E tests: simulate real user journey.

For bug fix: regression tests at each level before the fix.

## Phase 4 — Quality
1. Run all tests at all levels, record results.
2. Inspect diff for correctness, regressions, security.
3. Write `.agents/artifacts/local-test.md`.
4. Write `.agents/artifacts/qa-report.md` (PASS/FAIL/BLOCKED/PASS_WITH_NOTES).
5. Write `.agents/artifacts/review.md` (APPROVE/REQUEST CHANGES).

### Risk-triggered security and accessibility evidence
Trigger security review only for authentication, authorization, sessions, secrets/credentials, payments, sensitive personal data, security controls, or an untrusted-input/external-data boundary. Trigger accessibility review only for a user-facing interface, navigation, form, or interactive control. Record the trigger, change-specific checks, results, and remaining risk; security covers boundary, access control, data exposure, and safe handling, while accessibility covers keyboard path, semantic/accessible name, focus behavior, and visual readability. Missing triggered evidence or an unresolved issue blocks QA/review; non-triggered changes need no evidence. This is not a scanner, formal compliance, performance, reliability, or architecture review.

## Phase 5 — Report
Give exact test commands and URL. Ask: test, fix, adjust, or next feature?
