#!/usr/bin/env bash
#
# sync-ai-rules.sh - Sync AGENTS.md to tool-specific locations
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

mkdir -p .github
ln -f -F -v AGENTS.md .github/copilot-instructions.md
ln -f -F -v AGENTS.md CLAUDE.md

echo "Synced AGENTS.md to .github/copilot-instructions.md and CLAUDE.md"
