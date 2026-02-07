#!/usr/bin/env bash
# Install project Git hooks into the local .git/hooks directory.
# Usage: bash scripts/git/install-hooks.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

# For worktrees, .git may be a file pointing to the real gitdir
if [[ -f "$REPO_ROOT/.git" ]]; then
  HOOKS_DIR="$(git rev-parse --git-dir)/hooks"
fi

mkdir -p "$HOOKS_DIR"

echo "Installing Git hooks..."

for hook in "$SCRIPT_DIR"/pre-commit; do
  hook_name="$(basename "$hook")"
  cp "$hook" "$HOOKS_DIR/$hook_name"
  chmod +x "$HOOKS_DIR/$hook_name"
  echo "  ✓ $hook_name"
done

echo "Done. Hooks installed to $HOOKS_DIR"
