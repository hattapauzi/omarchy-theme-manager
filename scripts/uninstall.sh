#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
EXPECTED_TARGET="${REPO_ROOT}/bin/otm"
TARGET_BIN="${HOME}/.local/bin/otm"
REGISTRY_DIR="${HOME}/.config/omarchy-theme-manager"
REMOVE_REGISTRY=0

if [ "${1:-}" = "--remove-registry" ]; then
  REMOVE_REGISTRY=1
fi

if [ -L "$TARGET_BIN" ]; then
  LINK_TARGET="$(readlink -f "$TARGET_BIN" || true)"
  if [ "$LINK_TARGET" = "$EXPECTED_TARGET" ]; then
    rm -f "$TARGET_BIN"
    printf "Removed symlink: %s\n" "$TARGET_BIN"
  else
    printf "Skipped: %s points to a different target (%s)\n" "$TARGET_BIN" "$LINK_TARGET"
  fi
elif [ -e "$TARGET_BIN" ]; then
  printf "Skipped: %s exists but is not a symlink\n" "$TARGET_BIN"
else
  printf "No otm symlink found at: %s\n" "$TARGET_BIN"
fi

if [ "$REMOVE_REGISTRY" -eq 1 ]; then
  rm -rf "$REGISTRY_DIR"
  printf "Removed registry data: %s\n" "$REGISTRY_DIR"
else
  printf "Kept registry data: %s\n" "$REGISTRY_DIR"
  printf "Use --remove-registry to delete it.\n"
fi
