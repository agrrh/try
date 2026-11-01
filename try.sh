#!/bin/sh

#
# HELP
#

show_help() {
  cat <<'EOF'
Usage: try [name]

Manages "try" working directories for quick experiments.

Arguments:
  --help, -h    Show this message and exit
  <name>    Enter the directory (create if it does not exist)

If no argument is given, you are prompted to select an existing directory.
EOF
}

#
# CHECKS
#

TOOLS=(
  git
  ssh
)
for tool in ${TOOLS}; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: required utility \"${TOOL}\" is not installed." >&2
    exit 1
  fi
done

test -n "${TRY_DIR}" || TRY_DIR="${HOME}/try"
export TRY_DIR

test -d "${TRY_DIR}" || mkdir -p "${TRY_DIR}"

#
# RUN
#

if [ "$#" -ge 1 ]; then
  case "$1" in
    --help | -h)
      show_help
      exit 0
      ;;
  esac
fi

if [ "$#" -eq 0 ]; then
  SELECTED=$(find "${TRY_DIR}" -mindepth 1 -maxdepth 1 -type d \
    | xargs -n1 basename \
    | fzf \
      --layout reverse \
      --header "Existing directories:" \
      --ghost "Start typing to search" \
      --footer "Exit: Ctrl + C / Esc"
  )
  if [ -z "${SELECTED}" ]; then
    exit 0
  fi
  
  if [ -d "${TRY_DIR}/${SELECTED}" ]; then
    echo "${TRY_DIR}/${SELECTED}" || {
      echo "ERROR: Could not cd into selected dir" 1>&2
      exit 1
    }
  else
    echo "ERROR: Could not find selected dir" 1>&2
    exit 1
  fi
elif [ "$#" -eq 1 ]; then
  TARGET="${TRY_DIR}/$(date '+%Y-%m')-${1}"
  if [ -d "${TARGET}" ]; then
    echo "WARNING: Target directory already exist" 1>&2
  else
    mkdir -p "${TARGET}" || {
        echo "ERROR: Could not create target dir" 1>&2
        exit 1
    }
  fi
  echo "${TARGET}" || {
    echo "ERROR: Could not cd into target dir" 1>&2
    exit 1
  }
else
  echo "ERROR: Script accepts either 0 or 1 arguments, not more" 1>&2
  exit 1
fi
