# Engineering Workflow Toolkit

A reusable engineering workflow for coding assistants.

The toolkit does not choose the model. It uses the model you already chose in your coding assistant.

## Why this workflow

SDLC is how we build software whether we follow it very strictly or only partly; the main principles stay the same. We understand the problem, make a plan, build in small parts, test and review, then release.

In this workflow, agents act like team members. The orchestrator guides the work. For bigger work, the planner handles it and breaks it into small tasks. The developer and quality roles complete one task at a time. Outcomes are passed between roles through project files. The human approves important decisions and deploys the software.

The human approves requirements and plans. Deployment runs only when the human asks for it. Monitoring is available when needed. Small bug fixes can go straight from developer to quality.

### Interaction style

Human-facing updates use plain language and stay short: current status, the few important decisions or risks, and the next action. After planning, the orchestrator summarizes the proposed requirements, plan, and backlog, then waits for explicit approval before implementation in both checkpointed and autonomous delivery. It never treats silence as approval. Detailed test and review evidence stays in artifacts unless you ask to see it.

## Install

For interactive installation, run:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s --
```

This does not leave `install.sh` in your current folder. The installer also removes its temporary download files.

With no scope or tool flags, it presents this numbered menu. Press Enter to detect installed assistants automatically (choice 7).

1. OpenCode
2. Claude Code
3. Codex
4. Grok Build
5. Antigravity
6. All supported assistants
7. Detect installed assistants automatically

It then asks whether to install globally or into the current project; Enter selects global. Choosing project uses the current directory by default and shows the target. `all` with global scope warns before installing multiple tool configurations. `detect` reports available executables (`opencode`, `claude`, `codex`, `grok`, or `agy`) and asks for confirmation. If none are found, the installer asks you to choose an assistant explicitly.

For OpenCode, you can choose the scope directly:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global

curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project .
```

`curl | sh` is convenient. Inspect the source first, or use a temporary file if you want to review it before running it:

```sh
tmp=$(mktemp)
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh -o "$tmp"
# Read "$tmp" before running it.
sh "$tmp" --project .
rm -f "$tmp"
```

Interactive installs use `main` and state that `--ref` selects a tag or commit. Existing toolkit files are skipped by default, without per-file prompts. Use `--force` to overwrite all selected toolkit files in one run; `--yes` remains a backwards-compatible alias for `--force`. Use `--no-color` to disable terminal colors; colors are also disabled for non-terminal output and when `NO_COLOR` is set. The installer ends with a file summary listing installed, skipped, and overwritten paths. `--force` affects files only: global installation for `all` still requires its high-level confirmation. After installation, the installer prints the absolute locations for each installed tool. Paths are quoted by the scripts. The downloaded bootstrap script performs only archive download/extraction; the archive's local bundled installer performs the actual copy.

To replace an existing OpenCode configuration deliberately:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --force
```

### Versions

`main` means the current GitHub branch at `prinx/agents`, not a release. The interactive flow installs that branch and explains that a tag or commit requires `--ref`; it does not pretend it can re-download a different archive after startup. Pin a workshop to a reviewed tag or commit:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --ref <tag-or-commit> --tool codex --project .
```

## How to use

Start in your bootstrapped project and describe what you want. Each tool handles roles differently; do not expect the OpenCode primary-agent picker everywhere.

### Tool-specific use

- **OpenCode:** Select or switch to the `orchestrator` as your primary agent, then simply state your goal. OpenCode lets you switch primary agents during a session. See the [OpenCode agents documentation](https://opencode.ai/docs/agents/).
- **Codex CLI / ChatGPT Codex app:** Installed roles are named subagents, not a primary-agent picker. Ask Codex to use or spawn `orchestrator` to coordinate the work. In the interactive CLI, `/agent` lets you inspect and switch between agent threads while they run. See the [Codex subagents documentation](https://developers.openai.com/codex/agent-configuration/subagents).
- **Claude Code:** Installed roles are subagents. Ask Claude to delegate explicitly, for example: `Use the orchestrator agent to coordinate this work.` See the [Claude Code subagents documentation](https://code.claude.com/docs/en/sub-agents).
- **Grok Build:** Select the installed `orchestrator` with `/agents`, then state your goal. Grok Build supports project agent definitions and agent selection. See the [Grok Build subagents documentation](https://docs.x.ai/build/features/subagents).
- **Google Antigravity:** Support is partial. This toolkit installs rules and workflows, not a selectable static orchestrator role. State your goal and ask the agent to follow the installed workflow; the rule directs it to define and use planner, developer, and quality subagents when needed. See the [Antigravity rules and workflows documentation](https://antigravity.google/docs/rules-workflows) and [subagents documentation](https://antigravity.google/docs/subagents).

### New project

After selecting the orchestrator where your tool supports it, tell your coding assistant:

> I want to build a link shortener web app.

Use this fallback in any tool:

> I want to build a link shortener web app. Use the orchestrator to coordinate the work.

For a bigger project, the orchestrator brings in the planner. The planner asks questions before making a plan when key product facts are missing. Answer the questions and review the plan. The developer and quality roles then work through one feature at a time.

### Ask for a guided project

For more control, ask for guided delivery:

> Help me build this in small milestones. Ask questions first, show me the plan, and pause for my review before and after each milestone.

You can instead ask for autonomous delivery. The assistant still confirms requirements and the plan before building, and asks before deployment.

### Add a feature

For example:

> Add custom aliases so users can choose the short code for a link.

The orchestrator decides if this needs a planner. The work then moves through one feature at a time.

### Fix a bug

For example:

> Some shortened links send users to a 404 page. Please investigate and fix it.

Small bugs usually go to the developer, then quality. The planner is not needed for every bug.

### Monitor

Ask for monitoring when you need it, for example:

> Check production health for the link shortener.

### Deploy

Deployment is explicit. For example:

> Deploy the approved link shortener to Vercel.

The toolkit has a general deployment workflow and currently includes Vercel support (`deploy-vercel`). It does not deploy by itself. Add skills for the tools you use, such as Netlify, Cloudflare, AWS, Docker, or Kubernetes.

## What's inside this repo

`core/` holds the main role behavior, portable `SKILL.md` skills, playbooks, templates, and the `AGENTS.md` template. `adapters/` are hand-maintained wrappers that put the relevant role behavior into each tool's agent or configuration format and express that tool's permission or tool rules. When a tool needs self-contained agent files, their short bodies identify their core source; update both deliberately.

| Assistant | Support | Installed project assets |
| --- | --- | --- |
| OpenCode | Full | `.opencode/agents`, `.opencode/skills`, `AGENTS.md` |
| Claude Code | Full | `.claude/agents`, `.claude/skills`, `CLAUDE.md` shim importing `@AGENTS.md` |
| Codex CLI | Full | `.codex/agents/*.toml`, `.agents/skills`, `AGENTS.md` |
| Grok Build | Full | `.grok/agents`, `.grok/skills`, `AGENTS.md` |
| Antigravity | Partial | `.agents/skills`, `.agents/rules`, `.agents/workflows`, `AGENTS.md` |

Antigravity's documented project customization uses skills, rules, and workflows. Its role subagents are dynamically defined and invoked during a conversation, so this toolkit does not claim static project-local Antigravity role definitions. Its installed rule instructs the parent to dynamically define planner, developer, and quality roles.

All project installs also add `.agents/playbooks`, `.agents/templates`, and `.agents/artifacts/.gitkeep`.

The orchestrator routes a small bounded change through developer then quality. A complex feature goes planner, developer, then quality. Planner questions return through the orchestrator. Deployment always needs an explicit human request plus `PASS` QA and `APPROVE` review artifacts.

## Artifact and Git policy

Commit adapters and durable workflow artifacts: `AGENTS.md`, `requirements.md`, `plan.md`, `backlog.md`, and `project-memory.md`. `.gitignore` ignores transient `.agents/artifacts/state.md` and `failure-log.md`.

Before implementation, the developer role and `branch-safely` skill check whether Git exists. In an existing repository they inspect status and branch, preserve unrelated work, and create a task feature branch rather than modifying `main` or `master`. In a non-repository they ask whether to initialize Git and explain rollback/branch value; when the human is unsure or requests the default, they use `git init -b main`. They never set global identity, require a local identity check before a human-requested baseline commit, and never create a commit without explicit human request. A new repository may remain on `main` until its explicitly requested baseline commit, after which normal feature-branch policy applies.

## Safety note

An AI gateway may retain submitted code or use it for training, depending on its terms and settings. Do not submit sensitive, proprietary, regulated, or credential-bearing code unless the selected service and your organization explicitly permit it.

## License

This project is licensed under the [MIT License](LICENSE).
