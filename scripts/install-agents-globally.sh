#!/bin/bash
#
# install-agents-globally.sh - Install BD Agents into global config for opencode, gemini, claude code, cursor
#
# Usage:
#   ./scripts/install-agents-globally.sh           # Run from repo root
#   ./scripts/install-agents-globally.sh --status  # Show current global install status
#   ./scripts/install-agents-globally.sh --verify  # Deep file-by-file verification
#   ./scripts/install-agents-globally.sh --help    # Show help
#
# Reads from canonical 'agents/' dir in repo root. Installs to these user-global locations:
#   Opencode: ~/.config/opencode/agents/
#   Gemini CLI: ~/.gemini/agents/
#   Claude Code: ~/.claude/agents/
#   Cursor: ~/.cursor/agents/
#
# Key: Agents are flattened from agents/<name>/AGENT.md to <target>/<name>.md
#      since platforms expect flat .md files in their agents/ directories.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
AGENTS_DIR="$REPO_ROOT/agents"

expand_home() {
    echo "$1" | sed "s|^~|$HOME|"
}

GLOBAL_TARGETS=(
    "~/.config/opencode/agents"
    "~/.claude/agents"
    "~/.cursor/agents"
    "~/.gemini/agents"
)

TOOL_NAMES=(
    "Opencode (~/.config/opencode/agents)"
    "Claude Code (~/.claude/agents)"
    "Cursor (~/.cursor/agents)"
    "Gemini CLI (~/.gemini/agents)"
)

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# get_agents — prints agent names from canonical source, one per line
get_agents() {
    local agents=()
    for agent_dir in "$AGENTS_DIR"/*/; do
        if [[ -d "$agent_dir" ]] && [[ -f "$agent_dir/AGENT.md" ]]; then
            agents+=("$(basename "$agent_dir")")
        fi
    done
    if [[ ${#agents[@]} -eq 0 ]]; then
        return 1
    fi
    printf '%s\n' "${agents[@]}"
}

are_hardlinked() {
    local file1="$1" file2="$2"
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then return 1; fi
    local inode1 inode2
    inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
    inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
    [[ "$inode1" == "$inode2" ]]
}

show_help() {
    cat << EOF
Install Agents Globally Script
==============================
Installs BD Agents from canonical 'agents/' dir to global config locations for:
  Opencode (~/.config/opencode/agents/)
  Gemini CLI (~/.gemini/agents/)
  Claude Code (~/.claude/agents/)
  Cursor (~/.cursor/agents/)

Agents are installed as flat <name>.md files (flattened from agents/<name>/AGENT.md).

Usage:
  $0              Install/Sync agents globally (will overwrite)
  $0 --status     Check current global install status
  $0 --verify     Verify all agent files are present and correct
  $0 --help       Show this help message

Compatibility notes:
- Works on Linux/macOS (native Bash).
- If hard links cannot be created, script will automatically fall back to copying.

EOF
}

status_global() {
    print_info "Checking global agents installation status..."
    echo "Canonical Source: $AGENTS_DIR"
    if [[ ! -d "$AGENTS_DIR" ]]; then print_error "Agents directory not found!"; return 1; fi

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    print_success "Found ${#agents[@]} agents:"
    for agent in "${agents[@]}"; do
        echo "      - $agent"
    done
    echo ""

    for idx in "${!GLOBAL_TARGETS[@]}"; do
        local target
        target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
        local tool="${TOOL_NAMES[$idx]}"
        echo "Target: $tool"
        if [[ -d "$target" ]]; then
            local link_count=0 broken_count=0
            for agent_name in "${agents[@]}"; do
                local target_file="$target/${agent_name}.md"
                local source_file="$AGENTS_DIR/$agent_name/AGENT.md"
                if [[ -f "$target_file" ]]; then
                    if are_hardlinked "$source_file" "$target_file"; then
                        ((link_count++))
                    else
                        ((broken_count++))
                    fi
                else
                    ((broken_count++))
                fi
            done
            if [[ $broken_count -gt 0 ]]; then
                print_warning "$link_count valid hard links, $broken_count need sync"
            elif [[ $link_count -gt 0 ]]; then
                print_success "$link_count hard links OK"
            else
                print_warning "No agents found"
            fi
        else
            print_warning "Directory does not exist"
        fi
    done
    echo ""
}

sync_global() {
    print_info "Starting global agents installation (using hard links)..."
    if [[ ! -d "$AGENTS_DIR" ]]; then print_error "Canonical agents directory not found: $AGENTS_DIR"; exit 1; fi

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    if [[ ${#agents[@]} -eq 0 ]]; then print_error "No agents found in $AGENTS_DIR"; exit 1; fi
    print_info "Found ${#agents[@]} agents to install globally: ${agents[*]}"
    echo ""

    for idx in "${!GLOBAL_TARGETS[@]}"; do
        local target
        target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
        local tool="${TOOL_NAMES[$idx]}"
        print_info "Syncing to $tool..."
        mkdir -p "$target"

        for agent_name in "${agents[@]}"; do
            local source_file="$AGENTS_DIR/$agent_name/AGENT.md"
            local target_file="$target/${agent_name}.md"

            if [[ ! -f "$source_file" ]]; then
                print_warning "Missing AGENT.md for $agent_name, skipping"
                continue
            fi

            rm -f "$target_file"

            if ln -f "$source_file" "$target_file" 2>/dev/null; then
                : # Hard link succeeded
            else
                cp -f "$source_file" "$target_file"
                print_warning "Hard link failed for $agent_name, copied instead."
            fi
        done
        print_success "Installed ${#agents[@]} agents in $tool"
    done
    echo ""
    print_success "Global agents installation complete!"
}

verify_global_install() {
    print_info "Verifying global agents installation..."
    local all_ok=1

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    for idx in "${!GLOBAL_TARGETS[@]}"; do
        local target
        target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
        local tool="${TOOL_NAMES[$idx]}"
        local found_missing=0
        echo "Target: $tool"

        if [[ ! -d "$target" ]]; then
            print_error "Directory missing: $target"
            all_ok=0
            continue
        fi

        for agent_name in "${agents[@]}"; do
            local source_file="$AGENTS_DIR/$agent_name/AGENT.md"
            local target_file="$target/${agent_name}.md"

            if [[ ! -f "$target_file" ]]; then
                print_error "Agent missing: ${agent_name}.md in $tool"
                found_missing=1
                all_ok=0
            elif ! cmp -s "$source_file" "$target_file"; then
                print_warning "Content mismatch: ${agent_name}.md in $tool"
                all_ok=0
            elif ! are_hardlinked "$source_file" "$target_file"; then
                print_warning "Not hardlinked (copied): ${agent_name}.md in $tool"
            fi
        done

        if [[ $found_missing -eq 0 ]]; then
            print_success "All agents present for $tool"
        fi
        echo ""
    done

    if [[ $all_ok -eq 1 ]]; then
        print_success "Verification complete: ALL agents present and correct."
    else
        print_error "Verification failed: issues detected above."
    fi
    echo ""
}

main() {
    cd "$REPO_ROOT"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --status|-s)
                status_global
                exit 0
                ;;
            --verify)
                verify_global_install
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Run with --help for usage."
                exit 1
                ;;
        esac
        shift
    done

    if [[ ! -d "$AGENTS_DIR" ]]; then
        echo -e "${RED}[ERROR]${NC} 'agents/' directory not found in repo root ($REPO_ROOT).\nPlease run this script from the repository root where the canonical agents/ directory exists."
        exit 1
    fi

    sync_global
    echo ""
    status_global
    verify_global_install
}

main "$@"
