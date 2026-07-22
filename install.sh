#!/bin/sh
set -eu

REPOSITORY=prinx/agents
REPOSITORY_URL=https://github.com/prinx/agents
REF=main
SCOPE=
TARGET=

usage() {
  printf '%s\n' "Usage: $0 [--ref <tag-or-commit>] (--global | --project [target])" >&2
}

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --ref)
      [ "$#" -ge 2 ] || fail 'Missing value for --ref.'
      REF=$2
      shift 2
      ;;
    --global)
      [ -z "$SCOPE" ] || fail 'Choose only one install scope.'
      SCOPE=global
      shift
      ;;
    --project)
      [ -z "$SCOPE" ] || fail 'Choose only one install scope.'
      SCOPE=project
      shift
      if [ "$#" -gt 0 ] && [ "${1#--}" = "$1" ]; then
        TARGET=$1
        shift
      fi
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "Unsupported argument: $1"
      ;;
  esac
done

[ -n "$SCOPE" ] || {
  usage
  exit 1
}

case "$REF" in
  ''|-*|*[!A-Za-z0-9._/-]*) fail 'The ref must be a tag or commit containing only letters, numbers, ., _, /, or -.' ;;
esac

command -v curl >/dev/null 2>&1 || fail 'curl is required to download the toolkit.'
command -v tar >/dev/null 2>&1 || fail 'tar is required to extract the toolkit.'

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/opencode-workflow.XXXXXX") || fail 'Could not create a temporary directory.'
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup 0 1 2 15

ARCHIVE_PATH=$TEMP_DIR/toolkit.tar.gz
ARCHIVE_URL=$REPOSITORY_URL/archive/$REF.tar.gz

printf 'Downloading %s at ref %s...\n' "$REPOSITORY" "$REF"
curl -fsSL -o "$ARCHIVE_PATH" "$ARCHIVE_URL" || fail 'Could not download the toolkit archive.'
tar -xzf "$ARCHIVE_PATH" -C "$TEMP_DIR" || fail 'Could not extract the toolkit archive.'

TOOLKIT_DIR=
for candidate in "$TEMP_DIR"/*; do
  if [ -f "$candidate/scripts/install-global.sh" ] && [ -f "$candidate/scripts/bootstrap-project.sh" ]; then
    TOOLKIT_DIR=$candidate
    break
  fi
done
[ -n "$TOOLKIT_DIR" ] || fail 'The downloaded archive does not contain the expected toolkit scripts.'

if [ "$SCOPE" = global ]; then
  "$TOOLKIT_DIR/scripts/install-global.sh"
else
  if [ -n "$TARGET" ]; then
    "$TOOLKIT_DIR/scripts/bootstrap-project.sh" "$TARGET"
  else
    "$TOOLKIT_DIR/scripts/bootstrap-project.sh"
  fi
fi
