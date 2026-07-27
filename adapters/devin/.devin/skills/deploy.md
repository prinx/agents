---
name: deploy
description: Deployment guidance — check for existing process, guide setup if none exists. Use when deploying.
trigger: When deploying the application, setting up CI/CD, or configuring deployment pipelines.
---

# Deploy Skill

Deployment requires explicit human request. Never deploy without asking.

## Before deploying
1. Confirm tests pass
2. Run the project build
3. Confirm qa-report.md says PASS and review.md says APPROVE

## Check for existing process
Read `.agents/skills/deploy-project/SKILL.md` if it exists. Use the established process.

## If no process exists
Guide the user through choosing one:
- Ask: Do you have a VPS? A service like Vercel? Or nothing?
- Suggest the simplest free option
- Help set up the process step by step
- Save as `.agents/skills/deploy-project/SKILL.md` for future use

## Credential handling
Never handle credentials directly. Use `gh` CLI (already authenticated) or guide the user to add secrets in their service dashboard.
