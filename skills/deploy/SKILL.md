---
name: deploy
description: Use only for a human-requested deployment after QA PASS and review APPROVE have been recorded.
---

# Deploy

Require an explicit human deployment request. Verify `qa-report.md` says `PASS` and `review.md` says `APPROVE`; otherwise stop. Run the project build, report its result, then delegate provider-specific mechanics to the appropriate deployment procedure. Never expose credentials or imply deployment occurred without provider evidence.
