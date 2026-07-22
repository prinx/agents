#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TOOLKIT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode

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
  copy_file "$TOOLKIT_DIR/agents/$agent.md" "$CONFIG_DIR/agents/$agent.md"
done

for skill in requirements-gathering solution-design task-breakdown branch-safely unit-testing feature-testing e2e-testing quality-review orchestrate documentation deploy deploy-vercel monitoring; do
  copy_file "$TOOLKIT_DIR/skills/$skill/SKILL.md" "$CONFIG_DIR/skills/$skill/SKILL.md"
done

PREFERENCES="$CONFIG_DIR/workflow/user-preferences.md"
if [ ! -e "$PREFERENCES" ]; then
  mkdir -p "$(dirname -- "$PREFERENCES")"
  cat > "$PREFERENCES" <<'EOF'
# OpenCode Workflow User Preferences

## Experience and communication

## Technology preferences

## Delivery and review preferences

## Constraints
EOF
  printf 'Initialized %s\n' "$PREFERENCES"
else
  printf 'Preserved existing %s\n' "$PREFERENCES"
fi

printf 'Installed global OpenCode workflow agents and skills in %s\n' "$CONFIG_DIR"
