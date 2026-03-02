#!/bin/bash
#
# setup.sh - Initialize the BD Skills repository for development
#
# This script:
# 1. Installs git hooks for automatic skill and agent syncing
# 2. Runs the initial skill sync
# 3. Runs the initial agent sync
#
# Usage:
#   ./scripts/setup.sh

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "=================================="
echo "  BD Skills Repository Setup"
echo "=================================="
echo ""

# Install git hooks
print_info "Installing git hooks..."

HOOKS_SOURCE="$REPO_ROOT/hooks"
HOOKS_TARGET="$REPO_ROOT/.git/hooks"

if [ -d "$HOOKS_SOURCE" ]; then
    for hook in "$HOOKS_SOURCE"/*; do
        if [ -f "$hook" ]; then
            hook_name=$(basename "$hook")
            cp "$hook" "$HOOKS_TARGET/$hook_name"
            chmod +x "$HOOKS_TARGET/$hook_name"
            print_success "Installed $hook_name hook"
        fi
    done
else
    print_info "No hooks directory found, skipping hook installation"
fi

echo ""

# Run initial skill sync
print_info "Running initial skill sync..."
"$REPO_ROOT/scripts/sync-skills.sh"

echo ""

# Run initial agent sync
print_info "Running initial agent sync..."
"$REPO_ROOT/scripts/sync-agents.sh"

echo ""
echo "=================================="
echo "  Setup Complete!"
echo "=================================="
echo ""
echo "Git hooks installed. Skills and agents will auto-sync after:"
echo "  - git checkout / git switch"
echo "  - git pull / git merge"
echo ""
echo "To manually sync, run:"
echo "  ./scripts/sync-skills.sh"
echo "  ./scripts/sync-agents.sh"
echo ""
