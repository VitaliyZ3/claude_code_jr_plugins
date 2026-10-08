#!/usr/bin/env bash
# Runs whichever Python linters/formatters are available against the given paths.
# Usage: run_linters.sh <file-or-dir> [more paths...]
set -uo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <file-or-dir> [more paths...]" >&2
  exit 1
fi

TARGETS=("$@")

run_if_available() {
  local tool="$1"
  shift
  if command -v "$tool" >/dev/null 2>&1; then
    echo "=== $tool ==="
    "$tool" "$@"
    echo
  else
    echo "=== $tool: not installed, skipping ==="
    echo
  fi
}

run_if_available ruff check "${TARGETS[@]}"
run_if_available flake8 "${TARGETS[@]}"
run_if_available pylint "${TARGETS[@]}"
run_if_available isort --check-only --diff "${TARGETS[@]}"
run_if_available black --check --diff "${TARGETS[@]}"
run_if_available mypy "${TARGETS[@]}"
