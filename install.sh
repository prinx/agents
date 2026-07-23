#!/bin/sh
set -eu

REPOSITORY=prinx/agents
REPOSITORY_URL=https://github.com/prinx/agents
REF=main
TOOL=
SCOPE=
TARGET=
YES=false
DETECTED_TOOLS=

usage() {
  printf '%s\n' "Usage: $0 [--ref <tag-or-commit>] [--tool opencode|claude-code|codex|grok|antigravity|all|detect] (--global | --project [target]) [--yes]" >&2
}
fail() { printf '%s\n' "$1" >&2; exit 1; }

choose_tool() {
  printf '%s\n' 'Select coding assistant:' >&2
  printf '%s\n' '1 OpenCode' '2 Claude Code' '3 Codex' '4 Grok Build' '5 Antigravity' '6 All supported assistants' '7 Detect installed assistants automatically.' >&2
  printf '%s' 'Choice [1-7]: ' >&2
  read -r choice
  case "$choice" in
    1) TOOL=opencode ;; 2) TOOL=claude-code ;; 3) TOOL=codex ;; 4) TOOL=grok ;;
    5) TOOL=antigravity ;; 6) TOOL=all ;; 7) TOOL=detect ;;
    *) fail 'Choose a number from 1 through 7.' ;;
  esac
}
choose_scope() {
  printf '%s' 'Install globally or into the current project? [g/p] ' >&2
  read -r choice
  case "$choice" in
    g|G|global) SCOPE=global ;;
    p|P|project) SCOPE=project; TARGET=$(pwd) ;;
    *) fail 'Choose global (g) or project (p).' ;;
  esac
}
detect_tools() {
  detected=
  command -v opencode >/dev/null 2>&1 && detected="$detected opencode"
  command -v claude >/dev/null 2>&1 && detected="$detected claude-code"
  command -v codex >/dev/null 2>&1 && detected="$detected codex"
  command -v grok >/dev/null 2>&1 && detected="$detected grok"
  command -v agy >/dev/null 2>&1 && detected="$detected antigravity"
  DETECTED_TOOLS=${detected# }
  [ -n "$DETECTED_TOOLS" ] || fail 'No supported assistants were detected. Select one explicitly with --tool.'
  printf 'Detected assistants: %s\n' "$DETECTED_TOOLS" >&2
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --ref) [ "$#" -ge 2 ] || fail 'Missing value for --ref.'; REF=$2; shift 2 ;;
    --tool) [ "$#" -ge 2 ] || fail 'Missing value for --tool.'; TOOL=$2; shift 2 ;;
    --global) [ -z "$SCOPE" ] || fail 'Choose only one install scope.'; SCOPE=global; shift ;;
    --project)
      [ -z "$SCOPE" ] || fail 'Choose only one install scope.'; SCOPE=project; shift
      if [ "$#" -gt 0 ] && [ "${1#--}" = "$1" ]; then TARGET=$1; shift; fi ;;
    --yes) YES=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) fail "Unsupported argument: $1" ;;
  esac
done

case "$REF" in ''|-*|*[!A-Za-z0-9._/-]*) fail 'The ref must contain only letters, numbers, ., _, /, or -.' ;; esac

if [ -z "$TOOL" ] && [ -z "$SCOPE" ] && [ -t 0 ]; then
  choose_tool
  choose_scope
  printf '%s\n' "Installing GitHub branch main of $REPOSITORY. To install a tag or commit, rerun with --ref <tag-or-commit>." >&2
fi
[ -n "$TOOL" ] || { usage; exit 1; }
[ -n "$SCOPE" ] || { usage; exit 1; }
case "$TOOL" in opencode|claude-code|codex|grok|antigravity|all|detect) ;; *) fail 'Invalid --tool value.' ;; esac

if [ "$TOOL" = detect ]; then
  detect_tools
  if [ "$YES" = false ] && [ -t 0 ]; then
    printf 'Install for detected assistants? [y/N] ' >&2
    read -r answer
    [ "$answer" = y ] || [ "$answer" = Y ] || exit 0
  fi
fi
if [ "$TOOL" = all ] && [ "$SCOPE" = global ] && [ "$YES" = false ]; then
  if [ ! -t 0 ]; then fail 'Global installation for all assistants requires --yes outside a terminal.'; fi
  printf '%s' 'Install global configuration for all supported assistants? [y/N] ' >&2
  read -r answer
  [ "$answer" = y ] || [ "$answer" = Y ] || exit 0
fi

command -v curl >/dev/null 2>&1 || fail 'curl is required to download the toolkit.'
command -v tar >/dev/null 2>&1 || fail 'tar is required to extract the toolkit.'
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/workflow-toolkit.XXXXXX") || fail 'Could not create a temporary directory.'
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup 0 1 2 15
ARCHIVE_PATH=$TEMP_DIR/toolkit.tar.gz
printf 'Downloading %s at ref %s...\n' "$REPOSITORY" "$REF"
curl -fsSL -o "$ARCHIVE_PATH" "$REPOSITORY_URL/archive/$REF.tar.gz" || fail 'Could not download the toolkit archive.'
tar -xzf "$ARCHIVE_PATH" -C "$TEMP_DIR" || fail 'Could not extract the toolkit archive.'
TOOLKIT_DIR=
for candidate in "$TEMP_DIR"/*; do
  if [ -f "$candidate/scripts/install-local.sh" ]; then TOOLKIT_DIR=$candidate; break; fi
done
[ -n "$TOOLKIT_DIR" ] || fail 'The downloaded archive does not contain the bundled installer.'

run_local_installer() {
  selected_tool=$1
  if [ -n "$TARGET" ] && [ "$YES" = true ]; then
    "$TOOLKIT_DIR/scripts/install-local.sh" --tool "$selected_tool" --scope "$SCOPE" --target "$TARGET" --yes
  elif [ -n "$TARGET" ]; then
    "$TOOLKIT_DIR/scripts/install-local.sh" --tool "$selected_tool" --scope "$SCOPE" --target "$TARGET"
  elif [ "$YES" = true ]; then
    "$TOOLKIT_DIR/scripts/install-local.sh" --tool "$selected_tool" --scope "$SCOPE" --yes
  else
    "$TOOLKIT_DIR/scripts/install-local.sh" --tool "$selected_tool" --scope "$SCOPE"
  fi
}

if [ "$TOOL" = detect ]; then
  for detected_tool in $DETECTED_TOOLS; do
    run_local_installer "$detected_tool"
  done
else
  run_local_installer "$TOOL"
fi
