---
name: deployment-decisions
description: Use when the user wants to deploy but the method, platform, or process is not yet established.
---

# Deployment Decisions

Guide the user through choosing how to deploy. Keep it simple. Ask one question at a time. Never assume knowledge. Prefer free options. Save the chosen process as a project skill for future use.

## Step 1 — Check for an existing process

Ask: **Do you already have a way to deploy this project?**

- If yes: ask what it is (GitHub Actions, a script, a service, manual steps). Verify it works by asking how they normally run it. Save it as a project skill at `.agents/skills/deploy-project/SKILL.md` so future runs reuse it. Done.
- If no: go to step 2.

## Step 2 — Assess infrastructure

Ask: **Do you have a server or VPS?** (for example a DigitalOcean droplet, Hetzner, AWS EC2, a home server)

- If yes: go to VPS path (step 3a).
- If no: go to step 3b.

## Step 3a — VPS path

Ask: **Do you already have Docker set up on the server?**

- If yes: suggest GitHub Actions + Docker. Create a GitHub Actions workflow that builds a Docker image and deploys to the VPS via SSH. This is simple, free (GitHub Actions has generous free minutes), and repeatable. Save as project skill.
- If no: suggest installing Docker first, then the same workflow. Walk them through Docker install on their server (one command per distro).

Credentials: use GitHub Actions secrets. The agent generates the workflow file; the user adds secrets (`VPS_HOST`, `VPS_USER`, `VPS_SSH_KEY`) in the GitHub repo settings. The agent never handles these directly.

## Step 3b — No server

Present the free options with one-line pros and cons:

| Platform | Pros | Cons |
|---|---|---|
| **Vercel** | Zero config for Next.js/React, free tier, automatic HTTPS, instant deploys | Free tier limits, framework-focused |
| **Netlify** | Similar to Vercel, generous free tier, form handling | Same framework bias |
| **Cloudflare Pages** | Fast, free, edge network | Less flexible for backends |
| **GitHub Pages** | Free, simple | Static only, no server-side |
| **Railway** | Free tier, supports any stack, simple | Free tier limited hours |
| **Render** | Free tier, Docker support | Cold starts on free tier |

Suggest the simplest option that fits their stack. For a Next.js app, suggest Vercel. For a static site, suggest Cloudflare Pages or GitHub Pages. For a full-stack app with a database, suggest Railway or Render.

If the user says **"I don't know"** or **"just pick one"**: choose the simplest free option for their stack and explain why in one sentence.

## Step 4 — Set up and save

After the user chooses:

1. Walk through the setup step by step, one command or action at a time.
2. For services (Vercel, Netlify, etc.): guide them to create an account and connect their repo. Prefer `gh` CLI or the service's own CLI for auth — the agent should not handle tokens directly.
3. For VPS: generate the GitHub Actions workflow and any Dockerfiles needed.
4. Save the deployment process as `.agents/skills/deploy-project/SKILL.md` with:
   - Platform chosen
   - How to deploy (command or push-to-deploy)
   - Any required environment variables (names only, never values)
   - How to verify deployment worked (URL or health check)
5. If the user wants, also save to `~/.agents/skills/deploy-project/SKILL.md` for global reuse.

## Rules

- Never suggest paid services unless the user explicitly asks.
- Never handle tokens, passwords, or API keys directly. Use `gh` CLI, service CLIs, or tell the user what to add in their dashboard.
- Keep the setup under 5 steps. If it needs more, simplify.
- If something fails, diagnose the specific step before suggesting fixes.
