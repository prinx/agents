#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TOOLKIT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TARGET_DIR=${1:-"$(pwd)"}

if [ ! -d "$TARGET_DIR" ]; then
  printf 'Target project directory does not exist: %s\n' "$TARGET_DIR" >&2
  exit 1
fi
TARGET_DIR=$(CDPATH= cd -- "$TARGET_DIR" && pwd)

confirm_overwrite() {
  destination=$1
  if [ ! -e "$destination" ]; then
    return 0
  fi
  if [ ! -t 0 ]; then
    printf 'Refusing to overwrite existing %s without an interactive terminal.\n' "$destination" >&2
    return 1
  fi
  printf 'Overwrite %s? [y/N] ' "$destination" >&2
  read -r answer
  [ "$answer" = y ] || [ "$answer" = Y ]
}

copy_file() {
  source_file=$1
  destination=$2
  if ! confirm_overwrite "$destination"; then
    printf 'Skipped %s\n' "$destination" >&2
    return 0
  fi
  mkdir -p "$(dirname -- "$destination")"
  cp "$source_file" "$destination"
}

for agent in orchestrator planner developer quality; do
  copy_file "$TOOLKIT_DIR/agents/$agent.md" "$TARGET_DIR/.opencode/agents/$agent.md"
done

for skill in requirements-gathering solution-design task-breakdown branch-safely unit-testing feature-testing e2e-testing quality-review orchestrate documentation deploy deploy-vercel monitoring; do
  copy_file "$TOOLKIT_DIR/skills/$skill/SKILL.md" "$TARGET_DIR/.opencode/skills/$skill/SKILL.md"
done

for playbook in new-feature bug-fix release; do
  copy_file "$TOOLKIT_DIR/playbooks/$playbook.md" "$TARGET_DIR/.agents/playbooks/$playbook.md"
done

for template in requirements plan backlog qa-report review project-memory state; do
  copy_file "$TOOLKIT_DIR/templates/${template}-template.md" "$TARGET_DIR/.agents/templates/${template}-template.md"
done

mkdir -p "$TARGET_DIR/.agents/artifacts"
if [ ! -e "$TARGET_DIR/.agents/artifacts/.gitkeep" ]; then
  : > "$TARGET_DIR/.agents/artifacts/.gitkeep"
fi

if [ ! -e "$TARGET_DIR/AGENTS.md" ]; then
  cat > "$TARGET_DIR/AGENTS.md" <<'EOF'
# Project Conventions

- Keep durable project conventions here.
- Store mutable workflow artifacts in `.agents/artifacts/`.
- The orchestrator owns `state.md`; planner initializes project memory.
- Deployment requires an explicit human request and passing quality gates.
EOF
else
  printf 'Preserved existing %s\n' "$TARGET_DIR/AGENTS.md"
fi

printf 'Bootstrapped OpenCode workflow assets in %s\n' "$TARGET_DIR"
