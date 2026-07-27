# Engineering Workflow Toolkit

This project uses an engineering workflow with distinct phases: orchestrator, developer, and quality. Follow these conventions for all engineering work.

## Hard gates — never skip these

1. **Developer always hands off to quality.** After writing code, run your quality review before declaring work done. "It was just a typo" is not a reason to skip quality.
2. **Quality must produce artifacts.** Before telling the user the work is complete, write `.agents/artifacts/qa-report.md` and `.agents/artifacts/review.md`. If they do not exist, quality has not finished.
3. **Never declare work done without quality artifacts.** Do not say "done", "complete", "finished", or "ready" unless `qa-report.md` says `PASS` and `review.md` says `APPROVE`.
4. **Never infer quality from your own output.** Writing code and saying "tests pass" is not a quality review. Quality must run its own verification.
5. **Never silently skip a workflow step.** The cost of an unnecessary quality review is 2 minutes. The cost of a missed bug is a broken production app.

## Workflow

### Phase 1 — Diagnose
When something is broken, first establish where the problem actually is: code, configuration, environment, infrastructure, or user error. Never modify code to fix a problem that has not been diagnosed.

### Phase 2 — Classify
- **Tier 1 (clearly bounded, obvious approach):** Go directly to development.
- **Tier 2 (probably small, scope unclear):** Ask 1-2 quick questions first.
- **Tier 3 (clearly complex, multi-step):** Plan first — establish goal, users, constraints, success criteria. Get approval before development.

### Phase 3 — Develop
Work test-first at three levels:
1. **Unit tests**: write failing tests for core logic, implement to pass. Cover edge cases.
2. **Feature tests**: verify each acceptance criterion through observable behavior.
3. **End-to-end tests**: simulate the real user journey in the actual application.

For a bug fix, write regression tests at each applicable level before the fix.

### Phase 4 — Quality (mandatory)

Three sequential phases. Do not skip a phase.

**Phase 4a — Run tests.** Read the ticket's acceptance criteria, the diff, and test conventions. Run unit, feature, and end-to-end tests. Record exact commands and output. Confirm acceptance criteria are verified. For a bug fix, confirm regression tests exist at all three applicable levels. If a test level is not applicable, state why.

**Phase 4b — Inspect the diff.** Focus on three things only: correctness (does the code do what the ticket requires?), security (are inputs handled safely?), and scope (did you stay within the ticket?). Do not review for subjective style or naming preferences.

**Phase 4c — Write artifacts and decide.** Classify findings as blocking (must fix) or advisory (should fix). Write `.agents/artifacts/qa-report.md`, `.agents/artifacts/review.md`, and `.agents/artifacts/local-test.md`. Outcome is `APPROVE` only if no blocking findings exist.

### Phase 5 — Report
After quality passes, give exact local test commands and URL. Ask: test, fix, adjust, or start the next feature?

## Commands
- Install: (check package.json or equivalent)
- Test: (check package.json scripts)
- Build: (check package.json scripts)
- Dev server: (check package.json scripts)

## Conventions
- Respect existing code patterns and naming
- Choose the smallest working solution
- Do not add infrastructure or abstractions unless required
- Deployment requires explicit human request
