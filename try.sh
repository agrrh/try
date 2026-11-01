#!/bin/sh

#
# HELP
#

show_help() {
  cat >&2 <<'EOF'
Usage: try [name]

Create (if needed) and print the path of a "try" working directory for quick
experiments.

Arguments:
  -h, --help    Show this message and exit
  <name>        Select the directory YYYY-MM-<name> (create if missing)

If no argument is given, you are prompted to select an existing directory.

Environment:
  TRY_DIR       Root directory for experiments (default: ~/try)
EOF
}

#
# ARGUMENTS
#

if [ "$#" -ge 1 ]; then
  case "$1" in
    --help | -h)
      show_help
      exit 0
      ;;
  esac
fi

#
# SETUP
#

TRY_DIR="${TRY_DIR:-${HOME}/try}"

if ! mkdir -p "${TRY_DIR}"; then
  echo "ERROR: could not create TRY_DIR \"${TRY_DIR}\"." >&2
  exit 1
fi

#
# RUN
#

if [ "$#" -eq 0 ]; then
  if ! command -v fzf >/dev/null 2>&1; then
    echo "ERROR: required utility \"fzf\" is not installed." >&2
    exit 1
  fi

  DIRS=$(find "${TRY_DIR}" -mindepth 1 -maxdepth 1 -type d | sed 's|.*/||' | sort)
  if [ -z "${DIRS}" ]; then
    echo "No experiment directories in \"${TRY_DIR}\" yet." >&2
    exit 0
  fi

  SELECTED=$(printf '%s\n' "${DIRS}" | fzf \
    --layout reverse \
    --header "Existing directories:" \
    --ghost "Start typing to search" \
    --footer "Exit: Ctrl + C / Esc")
  if [ -z "${SELECTED}" ]; then
    exit 0
  fi

  TARGET="${TRY_DIR}/${SELECTED}"
  if [ ! -d "${TARGET}" ]; then
    echo "ERROR: selected directory \"${TARGET}\" does not exist." >&2
    exit 1
  fi

  printf '%s\n' "${TARGET}"
elif [ "$#" -eq 1 ]; then
  TARGET="${TRY_DIR}/$(date '+%Y-%m')-${1}"
  if [ -d "${TARGET}" ]; then
    echo "WARNING: target directory \"${TARGET}\" already exists." >&2
  elif ! mkdir -p "${TARGET}"; then
    echo "ERROR: could not create target directory \"${TARGET}\"." >&2
    exit 1
  fi

  printf '%s\n' "${TARGET}"
else
  echo "ERROR: expected 0 or 1 arguments, got $#." >&2
  exit 1
fi
