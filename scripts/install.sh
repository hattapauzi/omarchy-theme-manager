#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_BIN="${REPO_ROOT}/bin/otm"
TARGET_DIR="${HOME}/.local/bin"
TARGET_BIN="${TARGET_DIR}/otm"

if [ ! -f "$SOURCE_BIN" ]; then
  printf "Error: source binary not found: %s\n" "$SOURCE_BIN" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
ln -sfn "$SOURCE_BIN" "$TARGET_BIN"

printf "Installed otm symlink:\n"
printf "  %s -> %s\n" "$TARGET_BIN" "$SOURCE_BIN"
printf "\n"
printf "If needed, add this to PATH:\n"
printf "  export PATH=\"$HOME/.local/bin:\$PATH\"\n"
