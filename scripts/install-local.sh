#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TOOLKIT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TOOL=
SCOPE=
TARGET=
YES=false

fail() { printf '%s\n' "$1" >&2; exit 1; }

while [ "$#" -gt 0 ]; do
  case "$1" in
    --tool) TOOL=${2:?Missing value for --tool.}; shift 2 ;;
    --scope) SCOPE=${2:?Missing value for --scope.}; shift 2 ;;
    --target) TARGET=${2:?Missing value for --target.}; shift 2 ;;
    --yes) YES=true; shift ;;
    *) fail "Unsupported bundled-installer argument: $1" ;;
  esac
done

case "$TOOL" in opencode|claude-code|codex|grok|antigravity|all) ;; *) fail 'Invalid tool.' ;; esac
case "$SCOPE" in global|project) ;; *) fail 'Invalid install scope.' ;; esac

confirm_overwrite() {
  destination=$1
  [ ! -e "$destination" ] && return 0
  [ "$YES" = true ] && return 0
  if [ ! -t 0 ]; then
    printf 'Refusing to overwrite existing %s without --yes.\n' "$destination" >&2
    return 1
  fi
  printf 'Overwrite %s? [y/N] ' "$destination" >&2
  read -r answer
  [ "$answer" = y ] || [ "$answer" = Y ]
}

copy_file() {
  source_file=$1 destination=$2
  if ! confirm_overwrite "$destination"; then
    printf 'Preserved %s\n' "$destination" >&2
    return 0
  fi
  mkdir -p "$(dirname -- "$destination")"
  cp "$source_file" "$destination"
}

copy_tree_files() {
  source_root=$1 destination_root=$2
  (cd "$source_root" && find . -type f -print) | while IFS= read -r relative; do
    copy_file "$source_root/$relative" "$destination_root/$relative"
  done
}

install_shared_project() {
  target_dir=$1
  copy_tree_files "$TOOLKIT_DIR/skills" "$target_dir/.agents/skills"
  copy_tree_files "$TOOLKIT_DIR/playbooks" "$target_dir/.agents/playbooks"
  copy_tree_files "$TOOLKIT_DIR/templates" "$target_dir/.agents/templates"
  mkdir -p "$target_dir/.agents/artifacts"
  [ -e "$target_dir/.agents/artifacts/.gitkeep" ] || : > "$target_dir/.agents/artifacts/.gitkeep"
  copy_file "$TOOLKIT_DIR/templates/AGENTS.md" "$target_dir/AGENTS.md"
}

install_shared_global() {
  copy_tree_files "$TOOLKIT_DIR/skills" "$HOME/.agents/skills"
  copy_tree_files "$TOOLKIT_DIR/playbooks" "$HOME/.agents/playbooks"
  copy_tree_files "$TOOLKIT_DIR/templates" "$HOME/.agents/templates"
}

install_opencode() {
  base=$1
  copy_tree_files "$TOOLKIT_DIR/adapters/opencode/agents" "$base/agents"
  copy_tree_files "$TOOLKIT_DIR/skills" "$base/skills"
}
install_claude() {
  base=$1
  copy_tree_files "$TOOLKIT_DIR/adapters/claude-code/agents" "$base/agents"
  copy_tree_files "$TOOLKIT_DIR/skills" "$base/skills"
}
install_codex() { copy_tree_files "$TOOLKIT_DIR/adapters/codex/agents" "$1/agents"; }
install_grok() {
  base=$1
  copy_tree_files "$TOOLKIT_DIR/adapters/grok/agents" "$base/agents"
  copy_tree_files "$TOOLKIT_DIR/skills" "$base/skills"
}
install_antigravity_project() {
  target_dir=$1
  copy_tree_files "$TOOLKIT_DIR/adapters/antigravity/rules" "$target_dir/.agents/rules"
  copy_tree_files "$TOOLKIT_DIR/adapters/antigravity/workflows" "$target_dir/.agents/workflows"
}

absolute_path() {
  path=$1
  directory=$(dirname -- "$path")
  filename=$(basename -- "$path")
  directory=$(CDPATH= cd -- "$directory" && pwd)
  printf '%s/%s\n' "$directory" "$filename"
}

print_location() {
  printf '  %s: %s\n' "$1" "$(absolute_path "$2")"
}

print_opencode_locations() {
  base=$1
  shared=$2
  instructions=$3
  printf '%s\n' 'Installed OpenCode workflow files:'
  print_location 'Agents' "$base/agents"
  print_location 'Skills' "$base/skills"
  print_location 'Shared workspace' "$shared"
  [ -n "$instructions" ] && print_location 'Instructions' "$instructions"
  return 0
}

print_claude_locations() {
  base=$1
  shared=$2
  instructions=$3
  printf '%s\n' 'Installed Claude Code workflow files:'
  print_location 'Agents' "$base/agents"
  print_location 'Skills' "$base/skills"
  print_location 'Shared workspace' "$shared"
  [ -n "$instructions" ] && print_location 'Instructions' "$instructions"
  return 0
}

print_codex_locations() {
  base=$1
  shared=$2
  instructions=$3
  printf '%s\n' 'Installed Codex workflow files:'
  print_location 'Agents' "$base/agents"
  print_location 'Shared workspace' "$shared"
  [ -n "$instructions" ] && print_location 'Instructions' "$instructions"
  return 0
}

print_grok_locations() {
  base=$1
  shared=$2
  instructions=$3
  printf '%s\n' 'Installed Grok workflow files:'
  print_location 'Agents' "$base/agents"
  print_location 'Skills' "$base/skills"
  print_location 'Shared workspace' "$shared"
  [ -n "$instructions" ] && print_location 'Instructions' "$instructions"
  return 0
}

print_antigravity_locations() {
  shared=$1
  instructions=$2
  rules=$3
  workflows=$4
  skills=$5
  printf '%s\n' 'Installed Antigravity workflow files:'
  [ -n "$skills" ] && print_location 'Skills' "$skills"
  print_location 'Shared workspace' "$shared"
  [ -n "$rules" ] && print_location 'Rules' "$rules"
  [ -n "$workflows" ] && print_location 'Workflows' "$workflows"
  [ -n "$instructions" ] && print_location 'Instructions' "$instructions"
  return 0
}

if [ "$SCOPE" = project ]; then
  TARGET=${TARGET:-"$(pwd)"}
  [ -d "$TARGET" ] || fail "Target project directory does not exist: $TARGET"
  TARGET=$(CDPATH= cd -- "$TARGET" && pwd)
  install_shared_project "$TARGET"
  case "$TOOL" in
    opencode) install_opencode "$TARGET/.opencode" ;;
    claude-code) install_claude "$TARGET/.claude"; copy_file "$TOOLKIT_DIR/adapters/claude-code/CLAUDE.md" "$TARGET/CLAUDE.md" ;;
    codex) install_codex "$TARGET/.codex" ;;
    grok) install_grok "$TARGET/.grok" ;;
    antigravity) install_antigravity_project "$TARGET" ;;
    all)
      install_opencode "$TARGET/.opencode"; install_claude "$TARGET/.claude"; copy_file "$TOOLKIT_DIR/adapters/claude-code/CLAUDE.md" "$TARGET/CLAUDE.md"
      install_codex "$TARGET/.codex"; install_grok "$TARGET/.grok"; install_antigravity_project "$TARGET" ;;
  esac
  case "$TOOL" in
    opencode) print_opencode_locations "$TARGET/.opencode" "$TARGET/.agents" "$TARGET/AGENTS.md" ;;
    claude-code) print_claude_locations "$TARGET/.claude" "$TARGET/.agents" "$TARGET/CLAUDE.md" ;;
    codex) print_codex_locations "$TARGET/.codex" "$TARGET/.agents" "$TARGET/AGENTS.md" ;;
    grok) print_grok_locations "$TARGET/.grok" "$TARGET/.agents" "$TARGET/AGENTS.md" ;;
    antigravity) print_antigravity_locations "$TARGET/.agents" "$TARGET/AGENTS.md" "$TARGET/.agents/rules" "$TARGET/.agents/workflows" "$TARGET/.agents/skills" ;;
    all)
      print_opencode_locations "$TARGET/.opencode" "$TARGET/.agents" "$TARGET/AGENTS.md"
      print_claude_locations "$TARGET/.claude" "$TARGET/.agents" "$TARGET/CLAUDE.md"
      print_codex_locations "$TARGET/.codex" "$TARGET/.agents" "$TARGET/AGENTS.md"
      print_grok_locations "$TARGET/.grok" "$TARGET/.agents" "$TARGET/AGENTS.md"
      print_antigravity_locations "$TARGET/.agents" "$TARGET/AGENTS.md" "$TARGET/.agents/rules" "$TARGET/.agents/workflows" "$TARGET/.agents/skills" ;;
  esac
else
  install_shared_global
  case "$TOOL" in
    opencode) install_opencode "${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode" ;;
    claude-code) install_claude "$HOME/.claude" ;;
    codex) install_codex "$HOME/.codex" ;;
    grok) install_grok "$HOME/.grok" ;;
    antigravity) copy_tree_files "$TOOLKIT_DIR/skills" "$HOME/.gemini/config/skills" ;;
    all)
      install_opencode "${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode"; install_claude "$HOME/.claude"; install_codex "$HOME/.codex"; install_grok "$HOME/.grok"; copy_tree_files "$TOOLKIT_DIR/skills" "$HOME/.gemini/config/skills" ;;
  esac
  opencode_base=${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode
  case "$TOOL" in
    opencode)
      print_opencode_locations "$opencode_base" "$HOME/.agents" ''
      printf '  User preferences: %s (not installed by this toolkit)\n' "$(absolute_path "$opencode_base/opencode.json")" ;;
    claude-code) print_claude_locations "$HOME/.claude" "$HOME/.agents" '' ;;
    codex) print_codex_locations "$HOME/.codex" "$HOME/.agents" '' ;;
    grok) print_grok_locations "$HOME/.grok" "$HOME/.agents" '' ;;
    antigravity) print_antigravity_locations "$HOME/.agents" '' '' '' "$HOME/.gemini/config/skills" ;;
    all)
      print_opencode_locations "$opencode_base" "$HOME/.agents" ''
      printf '  User preferences: %s (not installed by this toolkit)\n' "$(absolute_path "$opencode_base/opencode.json")"
      print_claude_locations "$HOME/.claude" "$HOME/.agents" ''
      print_codex_locations "$HOME/.codex" "$HOME/.agents" ''
      print_grok_locations "$HOME/.grok" "$HOME/.agents" ''
      print_antigravity_locations "$HOME/.agents" '' '' '' "$HOME/.gemini/config/skills" ;;
  esac
fi
