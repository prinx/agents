---
name: monitoring
description: Use for standalone, on-demand checks of production health, errors, performance, or uptime.
---

# Monitoring

Monitoring is an on-demand request, not a mandatory step. The agent helps the user check their app's health or set up basic monitoring. Keep it simple.

## If the user asks to check production health

Do not set up anything. Just check what is available:

1. Read `.agents/skills/deploy-project/SKILL.md` to find the deployment URL.
2. If a URL exists: fetch it and check for a successful response. Report status, response time, and any obvious errors.
3. If no URL: ask the user for the URL.
4. If the app is down or returning errors, report what you see. Do not fix anything unless asked.

## If the user wants to set up monitoring

Ask: **What do you want to monitor?**

- Uptime (is the site alive?)
- Errors (are there failures in logs?)
- Performance (is it slow?)

Then ask: **Do you already use a monitoring service?** (Sentry, UptimeRobot, BetterStack, etc.)

- If yes: help them configure it for this project. Use the service's CLI or dashboard — never handle API keys directly.
- If no: suggest the simplest free option based on what they want:

| Need | Free option | What it does |
|---|---|---|
| Uptime | [UptimeRobot](https://uptimerobot.com) | Checks your URL every 5 minutes, sends email if down |
| Uptime | [BetterStack](https://betterstack.com) | Uptime + status page, free tier |
| Errors | [Sentry](https://sentry.io) | Error tracking, free tier for small projects |
| Simple | A cron job + curl | `curl -f https://yourapp.com/health \|\| echo "DOWN"` — no external service needed |

For the simplest possible setup with no external service: suggest a health check endpoint and a cron job.

### Health check endpoint

If the project does not have one, create a simple `/health` route that returns `200 OK`. This is enough for basic uptime monitoring.

### Simple cron monitoring (no external service)

Tell the user to add a cron job on their VPS or local machine:

```sh
# Check every 5 minutes, log failures
*/5 * * * * curl -sf https://yourapp.com/health || echo "$(date): DOWN" >> /var/log/monitor.log
```

For VPS deployments with Docker: add a lightweight monitoring container to `docker-compose.yml` only if the user wants it. Do not add it by default.

## Save as project skill

After setting up monitoring, save to `.agents/skills/monitor-project/SKILL.md`:

```markdown
---
name: monitor-project
description: Basic monitoring for this project.
---

# Monitor Project

- **URL**: https://yourapp.com
- **Health endpoint**: /health
- **Uptime check**: UptimeRobot (free) or cron job
- **How to check**: visit the URL or run `curl -sf https://yourapp.com/health`
- **Logs**: SSH to VPS, run `docker compose logs --tail 50`
```

## Rules

- Never set up complex monitoring stacks (Prometheus + Grafana + Alertmanager) unless the user explicitly asks and understands the maintenance cost.
- Never handle API keys or tokens. Guide the user to add them in the service dashboard.
- If the user does not know what monitoring is, explain it in one sentence: "Monitoring tells you when your app is down or broken, so you can fix it before users notice."
- Keep it to one free tool maximum. Do not overwhelm with options.
