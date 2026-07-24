---
name: deploy
description: Use only for a human-requested deployment after QA PASS and review APPROVE have been recorded.
---

# Deploy

Require an explicit human deployment request, even when command permissions would otherwise allow the deployment tool. Verify `qa-report.md` says `PASS` and `review.md` says `APPROVE`; otherwise stop. Run the project build, report its result, then delegate provider-specific mechanics to the appropriate deployment procedure. Ask before reading credential-bearing configuration and never print, copy, log, or report credentials. Never imply deployment occurred without provider evidence.
