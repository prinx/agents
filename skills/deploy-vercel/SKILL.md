---
name: deploy-vercel
description: Use when an approved, human-requested deployment specifically targets Vercel.
---

# Deploy Vercel

Guide the user through deploying to Vercel. Keep it simple, one step at a time.

## Gate check

Confirm the generic deploy gate: explicit human request, QA `PASS`, review `APPROVE`, and a successful build.

## Setup (first time only)

If the project has never been deployed to Vercel:

1. Ask: **Do you have a Vercel account?** If no, guide them to create one at vercel.com (free tier is enough).
2. Ask: **Is the project on GitHub?** If yes, guide them to connect Vercel to their GitHub repo through the Vercel dashboard (Import Project). This is the simplest path — no CLI needed for basic deploys.
3. If the project is not on GitHub, suggest installing the Vercel CLI: `npm i -g vercel`. Then run `vercel login` (opens browser for auth — no token handling needed).
4. Confirm the Vercel project name and environment (production or preview).
5. Save the deployment process to `.agents/skills/deploy-project/SKILL.md` with:
   - Platform: Vercel
   - Method: GitHub push-to-deploy (or `vercel --prod` for CLI)
   - Project name
   - Any required environment variables (names only, never values)

## Deploy

- **GitHub connected**: tell the user to push to their deploy branch. Vercel auto-deploys. Report the expected Vercel URL format: `https://<project-name>.vercel.app`.
- **CLI**: run `vercel --prod` (or `vercel` for preview). Report the URL from the output.
- Never print tokens. If `vercel login` is needed, ask the user to run it themselves.

## After deploy

- Ask the user to visit the URL and confirm it works.
- If it fails, check: build logs in Vercel dashboard, environment variables set correctly, framework settings.
- Offer to set up monitoring (load `monitoring` skill).
