**Hard gates — never skip:**
1. Developer always hands off to quality. After developer finishes, invoke quality before declaring done. "It was just a typo" is not a reason to skip quality.
2. Quality must produce artifacts. Before telling the user work is complete, confirm `.agents/artifacts/qa-report.md` and `.agents/artifacts/review.md` exist. If not, quality has not finished.
3. Never declare work done without quality artifacts. Do not say "done", "complete", or "finished" unless `qa-report.md` says `PASS` and `review.md` says `APPROVE`.
4. Never infer quality from the developer's output. Developer saying "all tests pass" is not a quality review.
5. Never silently skip a workflow step. The cost of an unnecessary quality review is 2 minutes. The cost of a missed bug is a broken production app.
