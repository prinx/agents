# OpenCode Engineering Workflow Toolkit

A reusable, artifact-driven engineering workflow for OpenCode. It provides four cooperating agents, thirteen skills, playbooks, templates, and safe installation scripts. Agents inherit the model selected by the OpenCode user; no provider or model is hard-coded here.

## Safety Note

An AI gateway may retain submitted code or use it for training, depending on its terms and settings. Do not submit sensitive, proprietary, regulated, or credential-bearing code unless the selected service and your organization explicitly permit it. Big Pickle is an optional workshop gateway example, not a requirement or endorsement.

## Contents

- `agents/`: `orchestrator`, `planner`, `developer`, and `quality`.
- `skills/`: OpenCode folder-based skills. Every folder contains its `SKILL.md`.
- `playbooks/`: new feature, bug fix, and release routes.
- `templates/`: artifact starting points.
- `scripts/`: global installation and project bootstrap scripts.

`.opencode/agents` and `.opencode/skills` are the OpenCode runtime discovery paths. `.agents/` is deliberately only the project workspace for playbooks, templates, and mutable artifacts.

## Install from GitHub

Download the installer, inspect it before running it, then install globally:

```sh
curl -fsSLO https://raw.githubusercontent.com/prinx/agents/main/install.sh
sh install.sh --global
```

The installer downloads this repository into a temporary directory, invokes the bundled installer, and removes the temporary files afterward. It copies agents and skills into `~/.config/opencode/` and creates `~/.config/opencode/workflow/user-preferences.md` only when it does not already exist. Existing runtime files prompt before overwrite. Edit that preferences file to describe communication, technology, and delivery preferences the planner should consider.

## Bootstrap a Project

From the target project, download the installer to a temporary location and run:

```sh
curl -fsSL https://raw.githubusercontent.com/prinx/agents/main/install.sh -o /tmp/opencode-workflow-install.sh
sh /tmp/opencode-workflow-install.sh --project .
```

The bootstrap script creates `.opencode/agents`, `.opencode/skills`, `.agents/playbooks`, `.agents/templates`, and `.agents/artifacts/.gitkeep`. It creates a minimal `AGENTS.md` only when one is absent. It refuses to overwrite existing files without an interactive confirmation.

Quit and restart OpenCode after adding or changing agents or skills. OpenCode loads these files at startup and does not hot-reload them.

## Version Pinning

The examples use `main` because no release tag has been made yet. For stable workshop use, inspect and pin a release tag or commit with `--ref <release-tag-or-commit>`:

```sh
sh install.sh --ref <release-tag-or-commit> --global
```

## Typical Gateway Walkthrough

1. Configure and select an OpenCode model through your approved AI gateway.
2. Optionally use Big Pickle for a workshop exercise after reviewing its current data-handling terms.
3. Restart OpenCode, select `orchestrator`, and describe the work.
4. The orchestrator selects fast path for a small bounded bug/change (`developer` then `quality`) or full path for a new/complex feature (`planner`, `developer`, then `quality`).
5. Answer any planner question batch relayed by the orchestrator. Do not assume subagents can run their own human conversation.
6. Review the artifacts and explicitly request deployment only after `.agents/artifacts/qa-report.md` says `PASS` and `.agents/artifacts/review.md` says `APPROVE`.

## Artifact Ownership

- `AGENTS.md`: durable, human-maintained project conventions.
- `project-memory.md`: dynamic project facts and decisions; planner initializes and updates it during planning.
- `state.md`: dynamic handoff state owned by the orchestrator.
- `requirements.md`, `plan.md`, `backlog.md`: planner-owned planning artifacts.
- `qa-report.md`, `review.md`: quality-owned evidence and outcomes.

Documentation is updated at meaningful milestones. Monitoring is standalone and on demand. Deployment always requires an explicit human request.
