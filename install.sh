#!/bin/sh
set -eu

REPOSITORY=prinx/agents
REPOSITORY_URL=https://github.com/prinx/agents
REF=main
TOOL=
SCOPE=
TARGET=
FORCE=false
NO_COLOR_FLAG=false
DETECTED_TOOLS=
COLOR=false

if [ -t 1 ] && [ -t 2 ] && [ -z "${NO_COLOR+x}" ]; then COLOR=true; fi

usage() {
  printf '%s\n' "Usage: $0 [--ref <tag-or-commit>] [--tool opencode|claude-code|codex|grok|antigravity|all|detect] (--global | --project [target]) [--force] [--no-color]" >&2
  printf '%s\n' 'Existing toolkit files are skipped by default. Use --force to overwrite them; --yes is a backwards-compatible alias for --force.' >&2
}
color() {
  if [ "$COLOR" = true ]; then printf '\033[%sm%s\033[0m' "$1" "$2"; else printf '%s' "$2"; fi
}
heading() { printf '%s\n' "$(color '1;34' "$1")"; }
fail() { printf '%s\n' "$(color 31 "$1")" >&2; exit 1; }
has_tty() { ( : </dev/tty ) 2>/dev/null; }
prompt() { has_tty && printf '%s' "$1" > /dev/tty; }
read_tty() { has_tty && IFS= read -r "$1" < /dev/tty; }

choose_tool() {
  default_choice=$1
  while :; do
    printf '%s\n' "$(color '1;34' 'Select coding assistant:')" > /dev/tty
    printf '%s\n' '1 OpenCode' '2 Claude Code' '3 Codex' '4 Grok Build' '5 Antigravity' '6 All supported assistants' '7 Detect installed assistants automatically.' > /dev/tty
    if [ "$default_choice" = detect ]; then prompt 'Choice [7]: '; else prompt 'Choice [1-6]: '; fi
    read_tty choice || fail 'Could not read the tool choice from the terminal.'
    [ -n "$choice" ] || choice=7
    case "$choice" in
      1) TOOL=opencode ;; 2) TOOL=claude-code ;; 3) TOOL=codex ;; 4) TOOL=grok ;;
      5) TOOL=antigravity ;; 6) TOOL=all ;; 7) TOOL=detect ;;
      *) printf '%s\n' 'Choose a number from 1 through 7.' >&2; continue ;;
    esac
    if [ "$default_choice" != detect ] && [ "$TOOL" = detect ]; then
      printf '%s\n' 'Choose a number from 1 through 6.' >&2
      continue
    fi
    return
  done
}
choose_scope() {
  prompt 'Install globally or into the current project? [G/p] '
  read_tty choice || fail 'Could not read the install scope from the terminal.'
  [ -n "$choice" ] || choice=G
  case "$choice" in
    g|G|global) SCOPE=global ;;
    p|P|project)
      SCOPE=project
      TARGET=$(pwd)
      printf 'Project target: %s\n' "$TARGET" > /dev/tty ;;
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
  [ -n "$DETECTED_TOOLS" ] || return 1
  printf 'Detected assistants: %s\n' "$(color 34 "$DETECTED_TOOLS")" >&2
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --ref) [ "$#" -ge 2 ] || fail 'Missing value for --ref.'; REF=$2; shift 2 ;;
    --tool) [ "$#" -ge 2 ] || fail 'Missing value for --tool.'; TOOL=$2; shift 2 ;;
    --global) [ -z "$SCOPE" ] || fail 'Choose only one install scope.'; SCOPE=global; shift ;;
    --project)
      [ -z "$SCOPE" ] || fail 'Choose only one install scope.'; SCOPE=project; shift
      if [ "$#" -gt 0 ] && [ "${1#--}" = "$1" ]; then TARGET=$1; shift; fi ;;
    --force|--yes) FORCE=true; shift ;;
    --no-color) NO_COLOR_FLAG=true; COLOR=false; shift ;;
    --help|-h) usage; exit 0 ;;
    *) fail "Unsupported argument: $1" ;;
  esac
done

case "$REF" in ''|-*|*[!A-Za-z0-9._/-]*) fail 'The ref must contain only letters, numbers, ., _, /, or -.' ;; esac

if [ -z "$TOOL" ] && [ -z "$SCOPE" ] && has_tty; then
  choose_tool detect
  choose_scope
  printf '%s\n' "Installing GitHub branch main of $REPOSITORY. To install a tag or commit, rerun with --ref <tag-or-commit>." >&2
  printf '%s\n' 'Existing toolkit files will be skipped. Use --force to overwrite them.' >&2
  while [ "$TOOL" = detect ] && ! detect_tools; do
    printf '%s\n' 'No supported assistants were detected. Select an assistant explicitly.' >&2
    choose_tool explicit
  done
fi
[ -n "$TOOL" ] || { usage; exit 1; }
[ -n "$SCOPE" ] || { usage; exit 1; }
case "$TOOL" in opencode|claude-code|codex|grok|antigravity|all|detect) ;; *) fail 'Invalid --tool value.' ;; esac

if [ "$TOOL" = detect ]; then
  [ -n "$DETECTED_TOOLS" ] || detect_tools || fail 'No supported assistants were detected. Select one explicitly with --tool.'
  if has_tty; then
    prompt 'Install for detected assistants? [y/N] '
    read_tty answer || fail 'Could not read the confirmation from the terminal.'
    [ "$answer" = y ] || [ "$answer" = Y ] || exit 0
  fi
fi
if [ "$TOOL" = all ] && [ "$SCOPE" = global ]; then
  if ! has_tty; then fail 'Global installation for all assistants requires an interactive terminal confirmation.'; fi
  prompt 'Install global configuration for all supported assistants? [y/N] '
  read_tty answer || fail 'Could not read the confirmation from the terminal.'
  [ "$answer" = y ] || [ "$answer" = Y ] || exit 0
fi

command -v curl >/dev/null 2>&1 || fail 'curl is required to download the toolkit.'
command -v tar >/dev/null 2>&1 || fail 'tar is required to extract the toolkit.'
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/workflow-toolkit.XXXXXX") || fail 'Could not create a temporary directory.'
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup 0 1 2 15
ARCHIVE_PATH=$TEMP_DIR/toolkit.tar.gz
heading "Downloading $REPOSITORY at ref $REF..."
curl -fsSL -o "$ARCHIVE_PATH" "$REPOSITORY_URL/archive/$REF.tar.gz" || fail 'Could not download the toolkit archive.'
tar -xzf "$ARCHIVE_PATH" -C "$TEMP_DIR" || fail 'Could not extract the toolkit archive.'
TOOLKIT_DIR=
for candidate in "$TEMP_DIR"/*; do
  if [ -f "$candidate/scripts/install-local.sh" ]; then TOOLKIT_DIR=$candidate; break; fi
done
[ -n "$TOOLKIT_DIR" ] || fail 'The downloaded archive does not contain the bundled installer.'

run_local_installer() {
  selected_tool=$1
  set -- --tool "$selected_tool" --scope "$SCOPE"
  [ -n "$TARGET" ] && set -- "$@" --target "$TARGET"
  [ "$FORCE" = true ] && set -- "$@" --force
  [ "$NO_COLOR_FLAG" = true ] && set -- "$@" --no-color
  [ "$TOOL" = detect ] && set -- "$@" --suppress-success
  "$TOOLKIT_DIR/scripts/install-local.sh" "$@"
}

print_success() {
  printf '%s\n' "$(color 32 'Installation successful.')"
  if [ "$SCOPE" = project ]; then
    printf 'Next: start or open your coding assistant from %s.\n' "${TARGET:-"$(pwd)"}"
  else
    printf '%s\n' 'Next: restart your coding assistant if it is already open.'
  fi
}

if [ "$TOOL" = detect ]; then
  for detected_tool in $DETECTED_TOOLS; do
    run_local_installer "$detected_tool"
  done
else
  run_local_installer "$TOOL"
fi

[ "$TOOL" = detect ] && print_success
