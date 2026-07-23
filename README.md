# Engineering Workflow Toolkit

A reusable engineering workflow for coding assistants. It does not choose a model or provider; it uses the model already selected in your assistant.

## Why this workflow

The orchestrator coordinates the work. For larger changes, a planner gathers missing requirements and creates a plan. Developer and quality roles then complete and verify one feature at a time. The human approves requirements, plans, and deployment.

Small bug fixes can go directly from developer to quality. Deployment runs only on an explicit human request. Monitoring is available when needed.

## Install

For interactive installation, run:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s --
```

This does not leave `install.sh` in your current folder. The installer downloads to a temporary directory and removes it when finished.

## How to use

For all install options and detailed usage, read [DOCS.md](DOCS.md).

Start in a bootstrapped project and state your goal. For a larger project, answer the planner's questions and review the plan before implementation. Ask for guided delivery if you want milestone checkpoints, or ask for autonomous delivery when you prefer fewer checkpoints.

## What's inside

`core/` holds portable role behavior. `adapters/` provide hand-maintained configuration for each supported assistant. `skills/`, `playbooks/`, and `templates/` provide reusable workflow material.

| Assistant | Support | Project assets |
| --- | --- | --- |
| OpenCode | Full | `.opencode/agents`, `.opencode/skills`, `AGENTS.md` |
| Claude Code | Full | `.claude/agents`, `.claude/skills`, `CLAUDE.md` |
| Codex CLI | Full | `.codex/agents/*.toml`, `.agents/skills`, `AGENTS.md` |
| Grok Build | Full | `.grok/agents`, `.grok/skills`, `AGENTS.md` |
| Antigravity | Partial | `.agents/skills`, `.agents/rules`, `.agents/workflows`, `AGENTS.md` |

## Safety note

An AI gateway may retain submitted code or use it for training, depending on its terms and settings. Do not submit sensitive, proprietary, regulated, or credential-bearing code unless the selected service and your organization explicitly permit it.

## License

This project is licensed under the [MIT License](LICENSE).
