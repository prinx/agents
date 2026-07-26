---
name: deploy
description: Use only for a human-requested deployment after QA PASS and review APPROVE have been recorded.
---

# Deploy

Guide the user through deploying. Do not assume they know how. Do not handle credentials directly.

## Gate check

Before anything else, confirm all three:

1. Explicit human deployment request.
2. `qa-report.md` says `PASS` (or `PASS_WITH_NOTES` with the limitation noted).
3. `review.md` says `APPROVE`.

If any is missing, stop and tell the user what is missing. Do not proceed.

## Check for an existing deployment process

Read `.agents/skills/deploy-project/SKILL.md` if it exists. This is a project-level deployment skill saved from a previous run or set up manually.

- If it exists and looks correct: use it. Tell the user what you are about to do and run the deployment. Report the result.
- If it does not exist: load `deployment-decisions` and guide the user through choosing and setting up a deployment process.

## During deployment

- Run the project build first. Report success or failure. Do not proceed to deploy if the build fails.
- For commands that need credentials (pushing to a remote, deploying to a service): use the project's established CLI method. Prefer `gh` CLI when available (already authenticated). If a service CLI is needed, ask the user to run `service login` first, then continue.
- Never print, copy, log, or report tokens, passwords, or API keys.
- Never deploy to production without explicit human approval.

## After deployment

- Report the deployment URL or confirmation evidence from the provider.
- If the deployment failed, diagnose the specific step before suggesting fixes.
- Ask the user if they want to set up monitoring (load `monitoring` skill).
- Save the deployment process to `.agents/skills/deploy-project/SKILL.md` if one was created during this run, so future deployments skip the decision phase.
