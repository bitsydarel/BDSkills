#!/bin/bash
#
# sync-agents.sh - Synchronize agents from canonical source to agent tool locations
#
# Syncs agents from the canonical 'agents/' directory using hard links.
# Two scopes control which targets are synced:
#
#   Project-level (--project): repo-local directories owned by this script
#     .agent/agents, .opencode/agents, .cursor/agents, .gemini/agents,
#     .github/agents, .claude/agents, plugins/
#     Stale agents are pruned (these dirs are fully managed).
#
#   User-level (default): user-home directories shared with other tools
#     ~/.config/opencode/agents, ~/.gemini/agents, ~/.copilot/agents,
#     ~/.claude/agents, ~/.agents/agents
#     Only managed agents are updated — external agents are never deleted.
#
# Key difference from sync-skills.sh:
#   Platforms expect agents as flat <name>.md files, not <name>/AGENT.md dirs.
#   So the sync FLATTENS: agents/<name>/AGENT.md -> <target>/<name>.md
#   The plugins/ target is the exception — it preserves the full directory layout.
#
# Usage:
#   ./scripts/sync-agents.sh                    # Sync user-level only (default)
#   ./scripts/sync-agents.sh --project          # Sync project-level only
#   ./scripts/sync-agents.sh --all              # Sync both project + user
#   ./scripts/sync-agents.sh --status           # Status for user targets (default)
#   ./scripts/sync-agents.sh --status --project # Status for project targets
#   ./scripts/sync-agents.sh --status --all     # Status for all targets
#   ./scripts/sync-agents.sh -v                 # Verbose output (shows every ln)
#   ./scripts/sync-agents.sh --help             # Show help
#

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
AGENTS_DIR="$REPO_ROOT/agents"

# Project-level targets (relative to REPO_ROOT)
declare -a PROJECT_TARGETS=(
    ".agent/agents"
    ".opencode/agents"
    ".cursor/agents"
    ".gemini/agents"
    ".github/agents"
    ".claude/agents"
)

# User-level targets (absolute paths)
# Sources:
#   OpenCode:       https://opencode.ai/docs/agents/
#   Gemini CLI:     https://geminicli.com/docs/core/subagents/
#   GitHub Copilot: https://docs.github.com/en/copilot/reference/custom-agents-configuration
#   Claude Code:    https://code.claude.com/docs/en/sub-agents
#   Cross-platform: ~/.agents/agents/ (recognized by OpenCode + Gemini CLI)
declare -a USER_TARGETS=(
    "$HOME/.config/opencode/agents"
    "$HOME/.gemini/agents"
    "$HOME/.copilot/agents"
    "$HOME/.claude/agents"
    "$HOME/.agents/agents"
)

# ── Colors ────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ -n "${NO_COLOR:-}" ]] || [[ ! -t 1 ]]; then
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# ── Globals ───────────────────────────────────────────────────────────────────

VERBOSE=false

# ── Output helpers ────────────────────────────────────────────────────────────

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Core helpers ──────────────────────────────────────────────────────────────

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

# are_hardlinked file1 file2 — returns 0 if same inode
are_hardlinked() {
    local file1="$1" file2="$2"
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        return 1
    fi
    local inode1 inode2
    inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
    inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
    [[ "$inode1" == "$inode2" ]]
}

# hardlink_agent agent_name source_dir target_dir
# Flattens: agents/<name>/AGENT.md -> target/<name>.md
hardlink_agent() {
    local agent_name="$1" source_dir="$2" target_dir="$3"
    local source_file="$source_dir/AGENT.md"
    local target_file="$target_dir/${agent_name}.md"

    if [[ ! -f "$source_file" ]]; then
        print_warning "Missing AGENT.md for $agent_name"
        return 1
    fi

    mkdir -p "$target_dir"

    # Remove existing target to ensure clean hard link
    rm -f "$target_file"

    local ln_flags="-f"
    if $VERBOSE; then
        ln_flags="-f -v"
    fi

    ln $ln_flags "$source_file" "$target_file"
}

# prune_stale_agents target_path agents...
# Removes .md files in target not matching any known agent name
prune_stale_agents() {
    local target_path="$1"
    shift
    local agents=("$@")

    if [[ ! -d "$target_path" ]]; then
        return 0
    fi

    for existing_file in "$target_path"/*.md; do
        if [[ ! -f "$existing_file" ]]; then
            continue
        fi
        local name
        name=$(basename "$existing_file" .md)
        local found=false
        for agent in "${agents[@]}"; do
            if [[ "$agent" == "$name" ]]; then
                found=true
                break
            fi
        done
        if ! $found; then
            print_warning "Removing stale agent: $name.md"
            rm -f "$existing_file"
        fi
    done
}

# ── Sync functions ────────────────────────────────────────────────────────────

# sync_target target_path label prune agents...
# Syncs agents as flat <name>.md files into target directory.
sync_target() {
    local target_path="$1" label="$2" prune="$3"
    shift 3
    local agents=("$@")

    mkdir -p "$target_path"

    if [[ "$prune" == "true" ]]; then
        prune_stale_agents "$target_path" "${agents[@]}"
    fi

    local count=0
    for agent_name in "${agents[@]}"; do
        if hardlink_agent "$agent_name" "$AGENTS_DIR/$agent_name" "$target_path"; then
            ((count++))
        fi
    done

    print_success "$label — $count agents synced"
}

# sync_plugins agents...
# Uses full directory layout: plugins/<name>/agents/<name>/AGENT.md + references/
sync_plugins() {
    local agents=("$@")
    local plugins_dir="$REPO_ROOT/plugins"

    # Prune plugin agent dirs not in canonical source
    if [[ -d "$plugins_dir" ]]; then
        for plugin_dir in "$plugins_dir"/*/; do
            if [[ ! -d "$plugin_dir" ]]; then
                continue
            fi
            local plugin_name
            plugin_name=$(basename "$plugin_dir")

            # Only prune agent dirs inside plugins that match agent names
            local agents_subdir="$plugin_dir/agents"
            if [[ -d "$agents_subdir" ]]; then
                for agent_subdir in "$agents_subdir"/*/; do
                    if [[ ! -d "$agent_subdir" ]]; then
                        continue
                    fi
                    local agent_name
                    agent_name=$(basename "$agent_subdir")
                    local found=false
                    for agent in "${agents[@]}"; do
                        if [[ "$agent" == "$agent_name" ]]; then
                            found=true
                            break
                        fi
                    done
                    if ! $found; then
                        print_warning "Removing stale plugin agent: $plugin_name/agents/$agent_name"
                        rm -rf "$agent_subdir"
                    fi
                done

                # Clean up empty agents/ dir after pruning
                if [ -d "$agents_subdir" ] && [ -z "$(ls -A "$agents_subdir")" ]; then
                    rmdir "$agents_subdir"
                fi
            fi

            # Remove top-level plugin dir only if no skills remain and it's empty
            if [ ! -d "$plugin_dir/skills" ] && [ -z "$(ls -A "$plugin_dir" 2>/dev/null)" ]; then
                print_warning "Removing empty plugin dir: $plugin_name"
                rmdir "$plugin_dir"
            fi
        done
    fi

    local count=0
    for agent_name in "${agents[@]}"; do
        local source_dir="$AGENTS_DIR/$agent_name"
        local target="$plugins_dir/$agent_name/agents/$agent_name"

        # Clean target and recreate
        rm -rf "$target"
        mkdir -p "$target"

        local ln_flags="-f"
        if $VERBOSE; then
            ln_flags="-f -v"
        fi

        # Hard-link all files from source agent dir (AGENT.md + references/)
        while IFS= read -r source_path; do
            local relative_path="${source_path#"$source_dir"/}"
            local target_path="$target/$relative_path"

            if [[ -d "$source_path" ]]; then
                mkdir -p "$target_path"
            elif [[ -f "$source_path" ]]; then
                mkdir -p "$(dirname "$target_path")"
                ln $ln_flags "$source_path" "$target_path"
            fi
        done < <(find "$source_dir" -mindepth 1 \
            \( -path '*/.*' -o -name '.*' \) -prune \
            -o -type l -prune \
            -o -type d -print \
            -o -type f -print)

        ((count++))
    done

    print_success "plugins/*/agents/ — $count agents synced"
}

# sync_project — syncs all project-level targets
sync_project() {
    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    echo ""
    echo "── Project Targets ─────────────────"

    for target in "${PROJECT_TARGETS[@]}"; do
        local target_path="$REPO_ROOT/$target"
        if ! sync_target "$target_path" "$target" "true" "${agents[@]}"; then
            print_warning "Failed to sync $target (continuing)"
        fi
    done

    if ! sync_plugins "${agents[@]}"; then
        print_warning "Failed to sync plugins/ agents (continuing)"
    fi
}

# sync_user — syncs all user-level targets (no pruning)
sync_user() {
    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    echo ""
    echo "── User Targets ────────────────────"

    for target_path in "${USER_TARGETS[@]}"; do
        local label="${target_path/#$HOME/~}"

        if [[ ! -d "$target_path" ]]; then
            print_info "Creating $label (first sync)"
        fi

        if ! sync_target "$target_path" "$label" "false" "${agents[@]}"; then
            print_warning "Failed to sync $label (continuing)"
        fi
    done
}

# ── Status functions ──────────────────────────────────────────────────────────

# check_target_status target_path label
# Checks hard link health for flat agent target (name.md files)
# Returns 0 if healthy, 2 if needs sync
check_target_status() {
    local target_path="$1" label="$2"

    echo "Target: $label"

    if [[ ! -d "$target_path" ]]; then
        print_warning "Directory does not exist"
        return 2
    fi

    local link_count=0
    local broken_names=()

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    for agent_name in "${agents[@]}"; do
        local target_file="$target_path/${agent_name}.md"
        local source_file="$AGENTS_DIR/$agent_name/AGENT.md"

        if [[ -f "$target_file" ]] && are_hardlinked "$source_file" "$target_file"; then
            ((link_count++))
        else
            broken_names+=("$agent_name")
        fi
    done

    if [[ ${#broken_names[@]} -gt 0 ]]; then
        local broken_list
        broken_list=$(printf '%s, ' "${broken_names[@]}")
        broken_list="${broken_list%, }"
        print_warning "$link_count valid, ${#broken_names[@]} need sync: $broken_list"
        return 2
    elif [[ $link_count -gt 0 ]]; then
        print_success "$link_count hard links OK"
        return 0
    else
        print_warning "No agents found"
        return 2
    fi
}

# check_plugins_status — checks hard link health for plugin agent layout
# Returns 0 if healthy, 2 if needs sync
check_plugins_status() {
    echo "Target: plugins/*/agents/*/"

    local ok_count=0
    local broken_names=()

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    for agent_name in "${agents[@]}"; do
        local target_file="$REPO_ROOT/plugins/$agent_name/agents/$agent_name/AGENT.md"
        local source_file="$AGENTS_DIR/$agent_name/AGENT.md"

        if [[ -f "$target_file" ]] && are_hardlinked "$source_file" "$target_file"; then
            ((ok_count++))
        else
            broken_names+=("$agent_name")
        fi
    done

    if [[ ${#broken_names[@]} -gt 0 ]]; then
        local broken_list
        broken_list=$(printf '%s, ' "${broken_names[@]}")
        broken_list="${broken_list%, }"
        print_warning "$ok_count valid, ${#broken_names[@]} need sync: $broken_list"
        return 2
    elif [[ $ok_count -gt 0 ]]; then
        print_success "$ok_count hard links OK"
        return 0
    else
        print_warning "No plugin agents found"
        return 2
    fi
}

# show_source_status — displays canonical source agent list
show_source_status() {
    echo "Canonical Source: $AGENTS_DIR"

    if [[ ! -d "$AGENTS_DIR" ]]; then
        print_error "Agents directory not found!"
        return 1
    fi

    local agents
    local IFS=$'\n'
    agents=($(get_agents))
    unset IFS

    print_success "Found ${#agents[@]} agents:"
    for agent in "${agents[@]}"; do
        echo "        - $agent"
    done
    echo ""
}

# show_project_status — status for project-level targets
# Returns 0 if all healthy, 2 if any need sync
show_project_status() {
    echo "── Project Targets ─────────────────"

    local needs_sync=false

    for target in "${PROJECT_TARGETS[@]}"; do
        if ! check_target_status "$REPO_ROOT/$target" "$target"; then
            needs_sync=true
        fi
    done

    if ! check_plugins_status; then
        needs_sync=true
    fi

    if $needs_sync; then
        return 2
    fi
    return 0
}

# show_user_status — status for user-level targets
# Returns 0 if all healthy, 2 if any need sync
show_user_status() {
    echo "── User Targets ────────────────────"

    local needs_sync=false

    for target_path in "${USER_TARGETS[@]}"; do
        local label="${target_path/#$HOME/~}"
        if ! check_target_status "$target_path" "$label"; then
            needs_sync=true
        fi
    done

    if $needs_sync; then
        return 2
    fi
    return 0
}

# ── Help ──────────────────────────────────────────────────────────────────────

show_help() {
    cat << 'EOF'
BD Agents Sync Script
=====================

Synchronizes agents from the canonical 'agents/' directory to agent tool
locations using hard links.

Key: Agents are flattened from agents/<name>/AGENT.md to <target>/<name>.md
     since platforms expect flat .md files in their agents/ directories.

Usage:
    sync-agents.sh                        Sync user-level targets (default)
    sync-agents.sh --project              Sync project-level targets only
    sync-agents.sh --all                  Sync both project + user targets
    sync-agents.sh --status               Show status for user targets (default)
    sync-agents.sh --status --project     Show status for project targets
    sync-agents.sh --status --all         Show status for all targets
    sync-agents.sh -v, --verbose          Show individual link operations
    sync-agents.sh -h, --help             Show this help message

Scopes:
    Project targets (--project):
        .agent/agents/           Agent
        .opencode/agents/        OpenCode
        .cursor/agents/          Cursor
        .gemini/agents/          Gemini CLI
        .github/agents/          GitHub Copilot
        .claude/agents/          Claude Code
        plugins/*/agents/*/      Plugin Marketplace (full dir layout)
        Stale agents are pruned (these dirs are fully managed by this script).

    User targets (default):
        ~/.config/opencode/agents/   OpenCode (user-level)
        ~/.gemini/agents/            Gemini CLI (user-level)
        ~/.copilot/agents/           GitHub Copilot (user-level)
        ~/.claude/agents/            Claude Code (user-level)
        ~/.agents/agents/            Cross-platform (OpenCode + Gemini CLI)
        Only managed agents are updated — external agents are never deleted.

Exit codes:
    0   All targets healthy / sync succeeded
    1   Fatal error (source missing, no agents found)
    2   Partial failure or targets need sync

Environment:
    NO_COLOR    Disable colored output
    VERBOSE     Show individual link operations (same as -v)

EOF
}

# ── Main ──────────────────────────────────────────────────────────────────────

main() {
    cd "$REPO_ROOT"

    # Argument parsing
    local do_status=false
    local scope="user"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                return 0
                ;;
            --status|-s)
                do_status=true
                ;;
            --project)
                if [[ "$scope" == "user" ]]; then
                    scope="project"
                else
                    scope="all"
                fi
                ;;
            --all)
                scope="all"
                ;;
            --verbose|-v)
                VERBOSE=true
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Run with --help for usage."
                return 1
                ;;
        esac
        shift
    done

    # Validate source
    if [[ ! -d "$AGENTS_DIR" ]]; then
        print_error "Canonical agents directory not found: $AGENTS_DIR"
        return 1
    fi

    if ! get_agents > /dev/null; then
        print_error "No agents found in $AGENTS_DIR"
        return 1
    fi

    if $do_status; then
        # ── Status mode ──
        show_source_status || return 1

        local exit_code=0

        case "$scope" in
            project)
                print_info "Scope: project"
                echo ""
                show_project_status || exit_code=2
                ;;
            user)
                show_user_status || exit_code=2
                ;;
            all)
                print_info "Scope: all"
                echo ""
                show_project_status || exit_code=2
                echo ""
                show_user_status || exit_code=2
                ;;
        esac

        return $exit_code
    else
        # ── Sync mode ──
        local agent_count
        agent_count=$(get_agents | wc -l | tr -d ' ')
        print_info "Found $agent_count agents to sync"

        case "$scope" in
            project)
                print_info "Scope: project (use default for user-level targets)"
                sync_project
                ;;
            user)
                sync_user
                ;;
            all)
                print_info "Scope: all (project + user)"
                sync_project
                sync_user
                ;;
        esac

        echo ""
        print_success "Sync complete!"
    fi
}

main "$@"
