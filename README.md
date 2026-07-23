# Engineering Workflow Toolkit

A reusable, artifact-driven engineering workflow for coding assistants.

The toolkit never configures a model. Each installed assistant uses the model/provider already selected by its user. Big Pickle is an optional workshop gateway example, not a default, requirement, or endorsement.

## Why This Workflow

This workflow is grounded in the software development lifecycle (SDLC), the proven way teams generally develop software. AI changes the tools and team structure, but it does not remove the need for clear goals, planning, incremental implementation, quality validation, human accountability, and safe release. Use AI tools to achieve those SDLC goals, and adapt practices when the work calls for it.

Agents act as specialized team members with defined roles and responsibilities. The orchestrator coordinates their handoffs and moves work through the workflow. For large or complex work, it invokes the planner, which clarifies intended outcomes and breaks the goal into small, ordered tasks. The developer implements one task at a time and collaborates with the quality reviewer for validation and review.

Artifacts carry outcomes and decisions between roles. Humans remain in control: they approve requirements and plans, make required decisions, and approve deployment. Deployment skills run only on explicit human request; monitoring is available on demand. Bug fixes and other small bounded changes take a shorter developer-to-quality fast path.

## Safety Note

An AI gateway may retain submitted code or use it for training, depending on its terms and settings. Do not submit sensitive, proprietary, regulated, or credential-bearing code unless the selected service and your organization explicitly permit it.

## Design

The toolkit is deliberately not a runtime translator. `core/` holds canonical role behavior, portable `SKILL.md` skills, playbooks, templates, and the `AGENTS.md` template. `adapters/` are hand-maintained wrappers that put the relevant role behavior into each tool's actual agent/configuration format and express that tool's permission or tool semantics. When a tool requires self-contained agent files, their concise bodies identify their core source; update both deliberately.

| Assistant | Support | Installed project assets |
| --- | --- | --- |
| OpenCode | Full | `.opencode/agents`, `.opencode/skills`, `AGENTS.md` |
| Claude Code | Full | `.claude/agents`, `.claude/skills`, `CLAUDE.md` shim importing `@AGENTS.md` |
| Codex CLI | Full | `.codex/agents/*.toml`, `.agents/skills`, `AGENTS.md` |
| Grok Build | Full | `.grok/agents`, `.grok/skills`, `AGENTS.md` |
| Antigravity | Partial | `.agents/skills`, `.agents/rules`, `.agents/workflows`, `AGENTS.md` |

Antigravity's documented project customization uses skills, rules, and workflows. Its role subagents are dynamically defined and invoked during a conversation, so this toolkit does not claim static project-local Antigravity role definitions. Its installed rule instructs the parent to dynamically define planner, developer, and quality roles.

All project installs also add `.agents/playbooks`, `.agents/templates`, and `.agents/artifacts/.gitkeep`.

## Install

Download and inspect the script before running it. With no scope or tool flags in a terminal, it presents this numbered menu:

1. OpenCode
2. Claude Code
3. Codex
4. Grok Build
5. Antigravity
6. All supported assistants
7. Detect installed assistants automatically

It then asks whether to install globally or into the current project. `all` with global scope warns before installing multiple tool configurations. `detect` reports available executables (`opencode`, `claude`, `codex`, `grok`, or `agy`) and asks for confirmation; it fails if no supported assistant is found.

```sh
curl -fsSLO https://raw.githubusercontent.com/prinx/agents/main/install.sh
sh install.sh
```

Noninteractive examples:

```sh
# Global OpenCode configuration.
sh install.sh --tool opencode --global

# Install Claude Code assets into a named project.
sh install.sh --tool claude-code --project "/path/to/project"

# Install every adapter into the current project, overwriting existing files.
sh install.sh --tool all --project . --yes

# Install only automatically detected assistant configuration.
sh install.sh --tool detect --project .
```

Existing files are preserved unless you confirm each overwrite or pass `--yes`. Paths are quoted by the scripts. The downloaded bootstrap script performs only archive download/extraction; the archive's local bundled installer performs the actual copy.

### Versions

`main` means the current GitHub branch at `prinx/agents`, not a release. The interactive flow installs that branch and explains that a tag or commit requires `--ref`; it does not pretend it can re-download a different archive after startup. Pin a workshop to a reviewed tag or commit:

```sh
sh install.sh --ref <tag-or-commit> --tool codex --project .
```

## Artifact And Git Policy

Commit adapters and durable workflow artifacts: `AGENTS.md`, `requirements.md`, `plan.md`, `backlog.md`, and `project-memory.md`. `.gitignore` ignores transient `.agents/artifacts/state.md` and `failure-log.md`.

Before implementation, the developer role and `branch-safely` skill check whether Git exists. In an existing repository they inspect status and branch, preserve unrelated work, and create a task feature branch rather than modifying `main` or `master`. In a non-repository they ask whether to initialize Git and explain rollback/branch value; when the human is unsure or requests the default, they use `git init -b main`. They never set global identity, require a local identity check before a human-requested baseline commit, and never create a commit without explicit human request. A new repository may remain on `main` until its explicitly requested baseline commit, after which normal feature-branch policy applies.

## Workflow

The orchestrator routes a small bounded change through developer then quality. A complex feature goes planner, developer, then quality. Planner questions return through the orchestrator. Deployment always needs an explicit human request plus `PASS` QA and `APPROVE` review artifacts.
