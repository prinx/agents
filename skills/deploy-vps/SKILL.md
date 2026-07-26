---
name: deploy-vps
description: Use when deploying to a VPS via GitHub Actions and Docker.
---

# Deploy VPS

Deploy to a VPS using GitHub Actions and Docker. This is the simplest repeatable setup for VPS deployment: push to GitHub, GitHub Actions builds and deploys.

## Prerequisites

Before starting, confirm:

1. The project has a GitHub repository.
2. The user has a VPS with SSH access.
3. Docker is installed on the VPS (or will be installed).

## Step 1 — Check Docker on VPS

Ask: **Do you have Docker installed on your server?**

Run on the VPS: `docker --version`

If not installed, guide them:
- Ubuntu/Debian: `curl -fsSL https://get.docker.com | sh`
- Then: `sudo usermod -aG docker $USER` (they may need to log out and back in)

## Step 2 — Create Dockerfile

If the project does not have a `Dockerfile`, create one. Keep it simple:

```dockerfile
# Use the smallest appropriate base image
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

Adjust for the project's stack (Python, Go, etc.). Ask the user what their project uses if unclear.

## Step 3 — Create GitHub Actions workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to VPS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /opt/${{ github.event.repository.name }}
            git pull
            docker compose down
            docker compose build
            docker compose up -d
```

If the project uses `docker-compose.yml` at the root, this works as-is. If not, suggest a simple one:

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    restart: unless-stopped
```

## Step 4 — Set up GitHub secrets

Tell the user to add three secrets in their GitHub repo (Settings > Secrets and variables > Actions):

1. `VPS_HOST` — their server IP or domain
2. `VPS_USER` — the SSH username (e.g. `root` or `deploy`)
3. `VPS_SSH_KEY` — the private SSH key for connecting

For the SSH key, tell them:
- If they already have one: copy the private key content.
- If not: run `ssh-keygen -t ed25519 -f deploy_key` on their local machine, then add the public key to the VPS `~/.ssh/authorized_keys`.

The agent never handles these values. The user adds them in GitHub.

## Step 5 — First deploy

Push to `main`. GitHub Actions will run the workflow. Tell the user to:
1. Check the Actions tab in GitHub for the workflow run.
2. If it passes, visit `http://<their-vps-ip>:3000` (or their configured port).
3. If it fails, check the SSH step output for the specific error.

## Save as project skill

After successful deployment, save to `.agents/skills/deploy-project/SKILL.md`:

```markdown
---
name: deploy-project
description: Deploy this project to the VPS via GitHub Actions.
---

# Deploy Project

Push to `main` on GitHub. GitHub Actions builds and deploys to the VPS automatically.

- **VPS**: <host>
- **Port**: 3000 (or as configured)
- **Check**: visit http://<host>:3000
- **Logs**: SSH to VPS, run `docker compose logs -f`
- **Restart**: SSH to VPS, run `docker compose restart`
```

## Rules

- Never print or log the SSH key, VPS credentials, or any secrets.
- Keep the Dockerfile minimal. Do not add monitoring agents, log shippers, or complexity unless the user asks.
- If the deploy fails, diagnose the specific step (build? SSH? Docker?) before suggesting fixes.
