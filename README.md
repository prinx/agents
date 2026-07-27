# Engineering Workflow Toolkit

An AI agent workflow for developers.

## Why this workflow

Building software usually follows the same steps: understand the problem, make a plan, build in small parts, test the work, review it, and release it.

This toolkit uses AI agents to help with those steps. Each agent has a role, like a member of a software team.

- You send requests to the orchestrator.
- The orchestrator guides the work and gives tasks to other agents when needed.
- The planner asks only the questions needed to define the smallest useful first feature, then proposes a simple stack and lightweight plan.
- The developer builds that first feature into a testable prototype without routine approval stops.
- The quality reviewer checks that each feature meets its acceptance criteria and works as expected.
- You approve important decisions, review plans, test locally, and choose when to deploy.
- Agents keep work organized, but you remain in control.

### Interaction style

Human-facing updates use plain language and stay short. The default is **prototype-first**: approve the first-feature plan once, then the agents build and test it without routine confirmations. You still approve material scope/goal changes, security/cost/privacy/credential choices, destructive or remote actions, deployment, and any checkpoint you explicitly request. At completed user-facing work, the orchestrator gives the exact local URL when known, otherwise commands and short steps from the quality-owned local-test artifact, then asks whether you want to test, fix, adjust, or start the next feature.

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
6. Cursor
7. Windsurf
8. Devin
9. All supported assistants
10. Detect installed assistants automatically

It then asks whether to install globally or into the current project; Enter selects global. Choosing project uses the current directory by default and shows the target. Next, it offers Anthropic's external `frontend-design` skill through skills.sh; press Enter for No. `all` with global scope warns before installing multiple tool configurations. `detect` reports available executables (`opencode`, `claude`, `codex`, `grok`, `agy`, `cursor`, `windsurf`, or `devin`) and asks for confirmation. If none are found, the installer asks you to choose an assistant explicitly.

For OpenCode, you can choose the scope directly:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --global

curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project .

# Also install Anthropic's optional external UI skill.
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh | sh -s -- --tool opencode --project . --with-frontend-design
```

`curl | sh` is convenient. Inspect the source first, or use a temporary file if you want to review it before running it:

```sh
tmp=$(mktemp)
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh -o "$tmp"
# Read "$tmp" before running it.
sh "$tmp" --project .
rm -f "$tmp"
```

Interactive installs use `main` and state that `--ref` selects a tag or commit. Existing toolkit files are skipped by default, without per-file prompts. Use `--force` to overwrite all selected toolkit files in one run; `--yes` remains a backwards-compatible alias for `--force`. Use `--with-frontend-design` to opt in non-interactively to Anthropic's external UI skill; it requires Node.js and `npx`. The optional skill uses skills.sh's documented `anthropics/skills` source and follows its default branch; it is not pinned because skills.sh cannot install a commit SHA as a remote ref. Use `--no-color` to disable terminal colors; colors are also disabled for non-terminal output and when `NO_COLOR` is set. The installer ends with a file summary listing installed, skipped, and overwritten paths, followed by a success message and next action. `--force` affects files only: global installation for `all` still requires its high-level confirmation. After installation, the installer prints the absolute locations for each installed tool. Paths are quoted by the scripts. The downloaded bootstrap script performs only archive download/extraction; the archive's local bundled installer performs the actual copy.

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

To learn more about all options and specific actions, read [DOCS.md](DOCS.md).

Start in your bootstrapped project and describe what you want. Each tool handles roles differently; do not expect the OpenCode primary-agent picker everywhere.

### Tool-specific use

- **OpenCode:** Select or switch to the `orchestrator` as your primary agent, then simply state your goal. OpenCode lets you switch primary agents during a session. See the [OpenCode agents documentation](https://opencode.ai/docs/agents/).
- **Codex CLI / ChatGPT Codex app:** Installed roles are named subagents, not a primary-agent picker. Ask Codex to use or spawn `orchestrator` to coordinate the work. In the interactive CLI, `/agent` lets you inspect and switch between agent threads while they run. See the [Codex subagents documentation](https://developers.openai.com/codex/agent-configuration/subagents).
- **Claude Code:** Installed roles are subagents. Ask Claude to delegate explicitly, for example: `Use the orchestrator agent to coordinate this work.` See the [Claude Code subagents documentation](https://code.claude.com/docs/en/sub-agents).
- **Grok Build:** Select the installed `orchestrator` with `/agents`, then state your goal. Grok Build supports project agent definitions and agent selection. See the [Grok Build subagents documentation](https://docs.x.ai/build/features/subagents).
- **Google Antigravity:** Support is partial. This toolkit installs rules and workflows, not a selectable static orchestrator role. State your goal and ask the agent to follow the installed workflow; the rule directs it to define and use planner, developer, and quality subagents when needed. See the [Antigravity rules and workflows documentation](https://antigravity.google/docs/rules-workflows) and [subagents documentation](https://antigravity.google/docs/subagents).
- **Cursor:** The orchestrator workflow is installed as an always-on rule in `.cursor/rules/workflow.mdc`. Start a new chat and describe your goal — Cursor reads the rules automatically and guides the work through planning, implementation, and review. See the [Cursor rules documentation](https://docs.cursor.com/context/rules).
- **Windsurf:** The orchestrator workflow is installed in `.windsurf/rules/workflow.md`. Start a new Cascade session and describe your goal — Windsurf reads the rules automatically and orchestrates the workflow. See the [Windsurf rules documentation](https://docs.windsurf.com/windsurf/memories-and-rules).
- **Devin:** The orchestrator workflow is loaded as Devin's session starter from `AGENTS.md` at the project root. Skills in `.devin/skills/` provide reusable procedures. Start a session and describe your goal — Devin reads the instructions and follows the workflow. See the [Devin skills documentation](https://docs.devin.ai/agent/skills).

### New project

After selecting the orchestrator where your tool supports it, tell your coding assistant:

> I want to build a link shortener web app.

Use this fallback in any tool:

> I want to build a link shortener web app. Use the orchestrator to coordinate the work.

The planner asks only for the goal, users, constraints, and smallest useful first result. Review and approve that first-feature plan. The developer and quality roles then get to a testable prototype quickly. Future ideas stay non-binding until you choose the next feature.

### Ask for a guided project

For more control, ask for guided/checkpointed delivery:

> Help me build this in small milestones. Ask questions first, show me the plan, and pause for my review before and after each milestone.

You can instead explicitly ask for autonomous delivery. It still requires first-plan approval and explicit deployment approval. For user-facing features, the developer first uses [Anthropic's `frontend-design` skill](https://github.com/anthropics/skills/tree/main/skills/frontend-design) when you have it installed; otherwise it uses the included `ui-ux` fallback. Neither path adds decorative complexity or a new design system unless you ask: UI stays within approved scope and existing product conventions while remaining accessible, responsive, simple, polished, and intentional. `frontend-design` is externally owned and is not bundled or installed by this toolkit.

### Add a feature

For example:

> Add custom aliases so users can choose the short code for a link.

The orchestrator decides if this needs a planner. The work then moves through one feature at a time.

### Fix a bug

For example:

> Some shortened links send users to a 404 page. Please investigate and fix it.

The workflow first diagnoses where the problem is (code, config, environment, infrastructure, or user error) before changing any code. Once confirmed as a code issue, small bugs go to the developer then quality. Larger changes go through planning.

### Monitor

Ask for monitoring when you need it, for example:

> Check production health for the link shortener.

### Deploy

Deployment is explicit. For example:

> Deploy the approved link shortener to Vercel.

The toolkit has a guided deployment workflow. If you already have a deployment process, the agent uses it. If not, it walks you through choosing the simplest free option — a VPS with GitHub Actions + Docker, Vercel, Netlify, or another service — and saves the process as a project skill for future use. The agent never handles your credentials directly.

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

The orchestrator routes a small bounded change through developer then quality. A complex feature goes planner, developer, then quality. Planner questions return through the orchestrator. Quality derives local testing from the repository rather than guesses and writes `.agents/artifacts/local-test.md`: applicable safe setup, install and automated commands actually run with results, start command, known URL or port, acceptance-criteria manual steps, cleanup, and limitations. For a library, CLI, or API-only project, it records the relevant test command and a verified usage or smoke test when available. Quality cannot give final user-facing `PASS` without a valid local test path; it reports `BLOCKED` or `PASS_WITH_NOTES` with what is missing instead. Deployment always needs an explicit human request plus `PASS` QA and `APPROVE` review artifacts.

## Artifact and Git policy

Commit adapters and durable workflow artifacts: `AGENTS.md`, `requirements.md`, `plan.md`, `backlog.md`, `project-memory.md`, and quality-owned `local-test.md`. `.gitignore` ignores transient `.agents/artifacts/state.md` and `failure-log.md`.

Before implementation, the developer role and `branch-safely` skill check whether Git exists. In an existing repository they inspect status and branch, preserve unrelated work, and create a task feature branch rather than modifying `main` or `master`. In a non-repository they ask whether to initialize Git and explain rollback/branch value; when the human is unsure or requests the default, they use `git init -b main`. They never set global identity, require a local identity check before a human-requested baseline commit, and never create a commit without explicit human request. A new repository may remain on `main` until its explicitly requested baseline commit, after which normal feature-branch policy applies.

## Safety note

An AI gateway may retain submitted code or use it for training, depending on its terms and settings. Do not submit sensitive, proprietary, regulated, or credential-bearing code unless the selected service and your organization explicitly permit it.

### Tool approvals

The toolkit lets developer and quality agents inspect the project, use normal non-force branch commands, stage changes, run known local checks, and list Docker containers or images without repeated approval. It asks before commits, remote Git work, destructive actions, sensitive Docker commands, external-system actions that were not requested, and all deployments.

Agents must ask before reading, searching, or scanning credential-bearing paths, including `.env`, `.env.*`, `.secrets`, `*.secrets`, `*.pem`, `*.key`, credential-named files or folders, `secrets/`, `.ssh/`, and `.aws/`. Approved access is only for the minimum needed work; agents must never print or include secrets in output, logs, or artifacts.

## License

This project is licensed under the [MIT License](LICENSE).
