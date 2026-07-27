# Workflow Toolkit Reference

This is the practical reference for installing and using the Engineering Workflow Toolkit. The toolkit is model-neutral: it works with the model and provider you select in your coding assistant.

## Quick start

Run this from a terminal for the interactive installer. It does not leave an installer file in the current directory.

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s --
```

Choose an assistant and choose global or project installation. Then restart an already-open assistant, or open the assistant from the installed project.

## Interactive defaults

With no flags, the installer shows a numbered assistant menu.

- Press Enter at the assistant menu to choose `detect`, which finds installed supported assistants.
- `detect` checks for `opencode`, `claude`, `codex`, `grok`, and `agy` executables. It shows what it found and asks before installing.
- Press Enter at the scope prompt to choose global installation.
- Choose project installation to use the current directory. The installer shows that target directory.
- The default source is the `main` branch. Use `--ref` to select a tag or commit.
- Existing toolkit files are skipped by default. Use `--force` to replace them.
- After assistant and scope selection, the installer asks `Install the optional frontend-design skill for UI work? [y/N]`. Enter selects No. It briefly identifies this as an external Anthropic skill installed through skills.sh.

If detection finds nothing, the interactive installer asks you to select an assistant explicitly.

## Installer command form

All non-interactive examples use this form:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- <options>
```

Use one scope: `--global` or `--project [path]`.

## Assistant choice: `--tool`

Use `--tool` to select one supported assistant.

```sh
# OpenCode
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global

# Claude Code
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool claude-code --global

# Codex
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool codex --global

# Grok Build
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool grok --global

# Google Antigravity
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool antigravity --global

# All supported assistants
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool all --project .

# Detect supported assistants installed on this machine
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool detect --global
```

`--tool all --global` requires an interactive confirmation because it writes configuration for every assistant. `--tool detect` reports detected assistants and asks for confirmation when a terminal is available.

## Optional UI skill: `--with-frontend-design`

The toolkit includes `ui-ux` as its built-in fallback. For user-facing work, agents prefer Anthropic's external [`frontend-design`](https://github.com/anthropics/skills/tree/main/skills/frontend-design) skill when available, and otherwise use `ui-ux`.

The optional skill is never installed by default. In the fully interactive flow, answer `y` to `Install the optional frontend-design skill for UI work? [y/N]`; any other answer, including Enter, declines it. For scripts or CI, pass `--with-frontend-design`:

```sh
# Install the toolkit and the optional skill in this project for OpenCode.
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --with-frontend-design

# Install it globally for Claude Code.
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool claude-code --global --with-frontend-design

# Install it for every supported assistant in a project.
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool all --project . --with-frontend-design
```

The installer invokes the documented skills.sh command `npx skills add anthropics/skills` with `--skill frontend-design`, `--agent` for the selected assistant targets, `--global` for global installs, and `--yes` to avoid a second prompt. skills.sh supports the toolkit targets `opencode`, `claude-code`, `codex`, `grok`, and `antigravity`; `all` passes all five names, while `detect` installs only to the assistants detected by this installer. It reports explicit optional-skill success only after skills.sh succeeds. If skills.sh rejects a target or source, the installer reports that the external skill was not installed and does not report overall success.

The source is external, is not vendored into this repository, and follows Anthropic's current default branch. It is intentionally **not pinned**: current skills.sh cannot install a commit SHA as a remote ref because it clones remote refs with `git clone --branch`, which only accepts an advertised branch or tag. A temporary downloaded archive would instead leave skills.sh with a transient local-path lock entry, so the toolkit does not use that approach. Anthropic licenses the skill under Apache-2.0; its files and notices remain with the external installation. Review the upstream source and skills.sh's security posture before opting in. For project installs, skills.sh records the source, skill path, and a content hash in the project `skills-lock.json`; global installs use its `.skill-lock.json` at `$XDG_STATE_HOME/skills/.skill-lock.json` or `~/.agents/.skill-lock.json`. This toolkit does not create or modify either lockfile itself.

This optional step needs Node.js and `npx`. If either is unavailable, or the external command fails, the toolkit files may already be installed but the command exits with a clear optional-skill failure and no `Installation successful` message. Install Node.js or resolve the skills.sh error, then rerun with `--with-frontend-design`; until then, the built-in `ui-ux` fallback remains available.

## Scope: `--global` and `--project`

Use `--global` for a personal default that applies across projects. Use `--project` when the workflow should live in one repository and be shareable with its team.

```sh
# Install globally
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global

# Install in the current directory
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project .

# Install in a named existing project directory
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool codex --project /path/to/project
```

`--project` without a path uses the current directory. The target directory must already exist.

### Installed paths

`~` means your home directory. `XDG_CONFIG_HOME` is used for OpenCode when it is set; otherwise its global path starts at `~/.config`.

| Tool | Global installation | Project installation |
| --- | --- | --- |
| OpenCode | `${XDG_CONFIG_HOME:-~/.config}/opencode/{opencode.json,agents,skills}`, `~/.agents/{skills,playbooks,templates}` | `.opencode/{opencode.json,agents,skills}`, `.agents/{skills,playbooks,templates,artifacts}`, `AGENTS.md` |
| Claude Code | `~/.claude/{settings.json,agents,skills}`, `~/.agents/{skills,playbooks,templates}` | `.claude/{settings.json,agents,skills}`, `.agents/{skills,playbooks,templates,artifacts}`, `AGENTS.md`, `CLAUDE.md` |
| Codex | `~/.codex/agents`, `~/.agents/{skills,playbooks,templates}` | `.codex/agents`, `.agents/{skills,playbooks,templates,artifacts}`, `AGENTS.md` |
| Grok Build | `~/.grok/{agents,skills}`, `~/.agents/{skills,playbooks,templates}` | `.grok/{agents,skills}`, `.agents/{skills,playbooks,templates,artifacts}`, `AGENTS.md` |
| Antigravity | `~/.gemini/config/skills`, `~/.agents/{skills,playbooks,templates}` | `.agents/{skills,playbooks,templates,artifacts,rules,workflows}`, `AGENTS.md` |

The installer supplies an `opencode.json` policy file and a Claude Code `settings.json` policy file. Existing configuration files are skipped unless you use `--force`.

## Replace existing files: `--force`

By default, a file the toolkit would install is left unchanged. The final report lists installed, skipped, and overwritten files.

Use `--force` only when you want to replace every selected toolkit file in that installation.

```sh
# Overwrite an existing global OpenCode toolkit installation
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global --force

# Overwrite an existing OpenCode installation in the current project
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --force

# Overwrite an existing Codex installation in a specific project
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool codex --project /path/to/project --force
```

`--yes` is a compatibility alias for `--force`.

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --yes
```

`--force` changes files only. It does not bypass the separate confirmation for global installation of `--tool all`.

## Version, output, and help options

Use `--ref` to install a reviewed tag or commit instead of the default `main` branch.

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --ref <tag-or-commit> --tool codex --project .
```

Use `--no-color` for plain terminal output. Colors are already disabled for non-terminal output and when `NO_COLOR` is set.

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global --no-color
```

Use `--help` or `-h` for the command summary.

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --help
```

## Inspect before installing

If you do not want to pipe directly to `sh`, download the bootstrap script to a temporary file, inspect it, then run it.

```sh
tmp=$(mktemp)
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh -o "$tmp"
# Inspect "$tmp" before running it.
sh "$tmp" --tool opencode --project .
rm -f "$tmp"
```

The bootstrap script only downloads and extracts the selected archive. The bundled local installer copies the toolkit files.

## Start the workflow

Open the assistant in the project, then describe the work. If you installed globally, restart an assistant that was already open so it can load the new configuration.

## Delivery modes

`prototype-first` is the default. The planner runs a short interview for the goal, intended users, constraints, smallest useful first result, and success criteria. It proposes a simple stack and lightweight plan for that first feature only. After you explicitly approve that plan, developer and quality work through it without routine confirmations to reach a testable prototype.

The workflow asks for approval only when it cannot safely decide: the first-feature plan, a material scope or goal change, security/cost/privacy/credential decisions, destructive or remote actions, deployment, or a checkpoint you explicitly requested. It does not ask for routine implementation choices. When uncertain, it chooses a simple reversible option and notes it briefly.

Guided/checkpointed delivery is available when you explicitly ask to pause for review at milestones. Autonomous delivery is also opt-in. Neither mode removes first-plan approval or explicit deployment approval.

### Three-tier routing

The orchestrator classifies your request into one of three tiers before routing:

- **Tier 1 — Direct execution**: the request is clearly bounded, the approach is obvious, and if it is a bug the diagnosis confirms it is in the code. Developer handles it directly, quality reviews.
- **Tier 2 — Quick scope**: the request is probably small but the specifics or diagnosis is unclear. The planner asks 1-2 quick questions to bound the work, then routes to developer.
- **Tier 3 — Full planning**: the request is clearly complex or multi-step. Full planner interview, plan, then developer.

When unsure, the orchestrator defaults to tier 2 — it is cheap and prevents wasted work. If the developer starts working and discovers unexpected complexity, it escalates back to the planner.

### Diagnose before fixing

When you report something broken, the workflow first establishes where the problem actually is — code, configuration, environment, infrastructure, or user error — before changing any code. A system that is not broken can be broken by unnecessary fixes. In production especially, changing code without diagnosis can cause real damage. If the diagnosis shows the problem is not in the code, the workflow tells you the actual cause and how to fix it without code changes.

### Hard gates

The workflow has five non-negotiable rules. No exception, no matter how small the task seems:

1. **Developer always hands off to quality.** After the developer finishes, the orchestrator invokes quality before declaring work done. "It was just a typo" is not a reason to skip quality.
2. **Quality must produce artifacts.** Before the orchestrator tells you the work is complete, it confirms `.agents/artifacts/qa-report.md` and `.agents/artifacts/review.md` exist. If they do not exist, quality has not finished.
3. **Never declare work done without quality artifacts.** The orchestrator will not say "done", "complete", "finished", or "ready" unless `qa-report.md` says `PASS` and `review.md` says `APPROVE`.
4. **Never infer quality from the developer's output.** The developer saying "all tests pass" is not a quality review. Quality must run its own verification and write its own artifacts.
5. **Never silently skip a workflow step.** The cost of an unnecessary quality review is 2 minutes. The cost of a missed bug is a broken production app.

### OpenCode

Select or switch to `orchestrator` as the primary agent, then state your goal. OpenCode supports switching primary agents in a session.

```text
Add user accounts to this application. Use the orchestrator to coordinate the work.
```

### Codex

The installed roles are custom subagents, not a primary-agent picker. Ask Codex to use or spawn the `orchestrator` subagent. In the interactive CLI, `/agent` lets you inspect and switch agent threads while they run.

```text
Use the orchestrator subagent to coordinate adding user accounts to this application.
```

### Claude Code

The installed roles are subagents. Delegate to the orchestrator explicitly; Claude Code does not provide the OpenCode primary-agent selection model.

```text
Use the orchestrator agent to coordinate adding user accounts to this application.
```

### Grok Build

Select the installed `orchestrator` with `/agents`, then state your goal. This depends on Grok Build's project agent definitions and agent selection support.

### Google Antigravity

Support is partial. The toolkit installs rules and workflows, not a selectable static orchestrator role. State your goal and ask the agent to follow the installed workflow. Its rule directs the parent agent to define and use planner, developer, and quality subagents when needed.

## Daily workflow

### New project

Start with a plain goal.

```text
I want to build a link shortener web app. Use the orchestrator to coordinate the work.
```

The planner asks only the questions needed for the smallest valuable first feature. Answer those questions, review its simple plan, then approve implementation. Future ideas may be recorded briefly but are not an approved roadmap.

For milestone checkpoints, ask:

```text
Help me build this in small milestones. Ask questions first, show me the plan, and pause for my review before and after each milestone.
```

You can ask for autonomous delivery. The first-feature plan still needs explicit approval before implementation.

### Add a feature

```text
Add custom aliases so users can choose the short code for a link.
```

The orchestrator decides whether planning is needed, then routes the work through developer and quality.

### Fix a bug

```text
Some shortened links send users to a 404 page. Please investigate and fix it.
```

The workflow first diagnoses where the problem is (code, configuration, environment, infrastructure, or user error) before changing any code. Once the diagnosis confirms a code issue, small bugs go directly to developer and quality. Larger or unclear changes go through planning.

### Review checkpoints

Review and approve requirements and plans before implementation. Quality records test evidence and review status. Do not treat silence as approval. A release needs QA `PASS` and review `APPROVE` artifacts before it can be deployed.

### Local testing output

Quality derives safe local test steps from the repository and writes `.agents/artifacts/local-test.md`. It records setup, commands actually run and their results, how to start the app, a known URL or port when available, manual acceptance steps, cleanup, and limitations. For libraries, CLIs, and APIs, it records an appropriate command and verified usage or smoke test.

Quality cannot give final user-facing `PASS` without a usable local test path. It reports `BLOCKED` or `PASS_WITH_NOTES` when something is missing.

After every completed user-facing feature, the orchestrator gives you the simplest actual way to test it: the local URL when quality started and verified a server, otherwise exact commands and short steps. It then asks whether you want to test, fix, adjust, or start the next feature. It does not automatically plan or build the next major feature unless you explicitly selected autonomous delivery.

### UI/UX

For user-facing work, developer first uses [Anthropic's `frontend-design` skill](https://github.com/anthropics/skills/tree/main/skills/frontend-design) when it is installed. Otherwise, developer uses the included `ui-ux` fallback. Both preserve existing app conventions and approved scope, prioritize clear labels and feedback, semantic and keyboard-accessible UI, visible focus, contrast, responsive behavior, and only the states the feature needs. A simple UI can still be polished and intentional; neither path adds decorative complexity or a new design system unless requested. `frontend-design` is externally owned and is not bundled or installed by this toolkit.

### Deploy explicitly

Deployment never starts by itself. Ask for it after the work has passed QA and review.

```text
Deploy the approved link shortener to Vercel.
```

If you already have a deployment process, the agent uses it. If not, the agent guides you through choosing one:

1. **You have a VPS**: the agent sets up GitHub Actions + Docker — push to `main`, it deploys automatically.
2. **You have a service** (Vercel, Netlify, etc.): the agent walks you through connecting your repo.
3. **You don't know**: the agent suggests the simplest free option for your stack and presents alternatives with pros and cons.

The agent never handles your credentials directly. It uses `gh` CLI (already authenticated) or guides you to add secrets in your service dashboard. After setup, the deployment process is saved as `.agents/skills/deploy-project/SKILL.md` so future deploys skip the decision phase.

Available deployment skills:

| Skill | When to use |
|---|---|
| `deploy` | Entry point — checks for existing process, loads the right sub-skill |
| `deploy-vercel` | Deploying to Vercel |
| `deploy-vps` | Deploying to a VPS via GitHub Actions + Docker |
| `deployment-decisions` | No process exists yet — guides the choice |

### Monitor

Ask for production checks when needed.

```text
Check production health for the link shortener.
```

The agent checks your app's URL, reports status and response time, and suggests a simple free monitoring setup if you want one (UptimeRobot for uptime, a cron job for health checks, or Sentry for errors). Never complex stacks unless you ask for them.

## Artifacts and project memory

Project installs create `.agents/artifacts/.gitkeep` and provide templates for workflow artifacts. Keep durable workflow information under version control, including:

- `AGENTS.md`
- `requirements.md`
- `plan.md`
- `backlog.md`
- `project-memory.md`
- `.agents/artifacts/local-test.md`

`project-memory.md` preserves useful project context between tasks. Keep it concise and update it when decisions, constraints, or durable facts change.

Transient workflow state is intentionally ignored: `.agents/artifacts/state.md` and `.agents/artifacts/failure-log.md`.

### `AGENTS.md` and `CLAUDE.md`

Every project install writes `AGENTS.md`, which contains shared project instructions. Claude Code project installs also write `CLAUDE.md`, a shim that imports `@AGENTS.md`. Keep shared instructions in `AGENTS.md` so tool-specific configurations can use the same source of truth. When `AGENTS.md` is absent (for example after a global install or in a new project), the planner initializes it from the `.agents/templates/AGENTS.md` template at the start of the first workflow run.

### Git policy

Before implementation, the workflow checks Git status and branch. It preserves unrelated work and uses a task branch instead of changing an existing repository's `main` or `master` branch. For a non-Git directory, it asks before initialization; if the human is unsure or requests the default, it uses `git init -b main`.

The workflow does not set global Git identity and does not create a commit without an explicit human request. After a human-requested baseline commit in a new repository, normal task-branch policy applies.

### Tool and secret policy

Developer and quality agents can inspect project files, use normal non-force branch commands, stage changes, run known local test/lint/build/dev commands, and list Docker containers or images without repeated approval. They ask before commits, remote Git operations, merges, rebases, resets, restores, cleans, force switches, branch deletions, destructive filesystem work, sensitive Docker operations, external-system actions that were not explicitly requested, and deployment.

Protected paths require approval before reading, searching, or scanning: `.env`, `.env.*`, `.secrets`, `*.secrets`, `*.pem`, `*.key`, credential-named files or folders, `secrets/`, `.ssh/`, `.aws/`, and similar credential locations. Agents never print, copy, log, or include secrets in artifacts or responses. Planner stays read-focused and the orchestrator does not run arbitrary shell commands.

## Troubleshooting

### The report says only skills or agents are missing

This is normal when shared files already exist or when an assistant needs only a subset of toolkit files. Read the installed, skipped, and overwritten sections of the final report. Use `--force` only if you intend to replace existing selected files.

### Existing files were skipped

Skipping is the safe default. To intentionally overwrite a global or project install, use one of these commands:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global --force
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --force
```

### The assistant does not show the new workflow

Restart the assistant if it was open during global installation. For project installation, start or open the assistant from the target project directory.

### Output contains unreadable color codes

Run the installer with `--no-color`, or set `NO_COLOR` in your environment.

### I want to inspect the installer first

Use the temporary-file method in [Inspect before installing](#inspect-before-installing).

### No assistant was detected

Install or expose the assistant executable on your `PATH`, then rerun with `--tool detect`. Or choose the tool directly, for example:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool claude-code --project .
```

## Safety note

An AI gateway may retain submitted code or use it for training depending on its terms and settings. Do not send sensitive, proprietary, regulated, or credential-bearing code unless the service and your organization explicitly allow it.
