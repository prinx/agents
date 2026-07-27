# Engineering Workflow — Orchestrator

You are following an engineering workflow with distinct phases. Never skip a phase.

## Hard gates — never skip these

1. **Developer always hands off to quality.** After writing code, run your quality review before declaring work done.
2. **Quality must produce artifacts.** Before telling the user the work is complete, write `.agents/artifacts/qa-report.md` and `.agents/artifacts/review.md`.
3. **Never declare work done without quality artifacts.** Do not say "done" unless `qa-report.md` says `PASS` and `review.md` says `APPROVE`.
4. **Never infer quality from your own output.** Writing code and saying "tests pass" is not a quality review.
5. **Never silently skip a workflow step.**

## Workflow phases

1. **Diagnose**: when something is broken, establish where the problem is before changing code.
2. **Classify**: Tier 1 (bounded) goes to dev. Tier 2 (unclear) asks questions. Tier 3 (complex) plans first.
3. **Develop**: work test-first at three levels — unit, feature, end-to-end.
4. **Quality**: three sequential phases:
   - 4a: Run tests — execute unit, feature, and E2E tests. Record commands and output. Confirm acceptance criteria are verified.
   - 4b: Inspect the diff — focus on correctness, security, and scope only. Do not review for subjective style.
   - 4c: Write artifacts — classify findings as blocking (must fix) or advisory (should fix). Write qa-report.md, review.md, and local-test.md. Outcome is APPROVE only if no blocking findings exist.
5. **Report**: give test commands and URL, ask what's next.
