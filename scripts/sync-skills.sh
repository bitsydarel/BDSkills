#!/bin/bash
#
# sync-skills.sh - Synchronize skills from canonical source to agent tool locations
#
# Syncs skills from the canonical 'skills/' directory using hard links.
# Two scopes control which targets are synced:
#
#   Project-level (--project): repo-local directories owned by this script
#     .opencode/skill, .cursor/skills, .gemini/skills, .github/skills, plugins/
#     Stale skills are pruned (these dirs are fully managed).
#
#   User-level (default): user-home directories shared with other tools
#     ~/.config/opencode/skills, ~/.gemini/skills, ~/.copilot/skills,
#     ~/.claude/skills, ~/.agents/skills
#     Only managed skills are updated — external skills are never deleted.
#
# Usage:
#   ./scripts/sync-skills.sh                    # Sync user-level only (default)
#   ./scripts/sync-skills.sh --project          # Sync project-level only
#   ./scripts/sync-skills.sh --all              # Sync both project + user
#   ./scripts/sync-skills.sh --status           # Status for user targets (default)
#   ./scripts/sync-skills.sh --status --project # Status for project targets
#   ./scripts/sync-skills.sh --status --all     # Status for all targets
#   ./scripts/sync-skills.sh -v                 # Verbose output (shows every ln)
#   ./scripts/sync-skills.sh --help             # Show help
#

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Project-level targets (relative to REPO_ROOT)
declare -a PROJECT_TARGETS=(
    ".agent/skills"
    ".opencode/skill"
    ".cursor/skills"
    ".gemini/skills"
    ".github/skills"
)

# User-level targets (absolute paths)
# Sources:
#   OpenCode:        https://opencode.ai/docs/skills/
#   Gemini CLI:      https://geminicli.com/docs/cli/skills/
#   GitHub Copilot:  https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
#   Claude Code:     https://code.claude.com/docs/en/skills
#   Cross-platform:  ~/.agents/skills/ (recognized by OpenCode + Gemini CLI)
#   Cursor:          No file-based user-level skills (configured via Settings UI)
declare -a USER_TARGETS=(
    "$HOME/.config/opencode/skills"
    "$HOME/.gemini/skills"
    "$HOME/.copilot/skills"
    "$HOME/.claude/skills"
    "$HOME/.agents/skills"
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

# get_skills — prints skill names from canonical source, one per line
get_skills() {
    local skills=()
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [[ -d "$skill_dir" ]]; then
            skills+=("$(basename "$skill_dir")")
        fi
    done
    if [[ ${#skills[@]} -eq 0 ]]; then
        return 1
    fi
    printf '%s\n' "${skills[@]}"
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

# hardlink_skill source_dir target_dir — hard-links all files from one skill
hardlink_skill() {
    local source_dir="$1" target_dir="$2"

    # Clean target and recreate
    rm -rf "$target_dir"
    mkdir -p "$target_dir"

    local ln_flags="-f"
    if $VERBOSE; then
        ln_flags="-f -v"
    fi

    while IFS= read -r source_path; do
        local relative_path="${source_path#"$source_dir"/}"
        local target_path="$target_dir/$relative_path"

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
}

# prune_stale_skills target_path skills... — removes dirs not in skills list
prune_stale_skills() {
    local target_path="$1"
    shift
    local skills=("$@")

    if [[ ! -d "$target_path" ]]; then
        return 0
    fi

    for existing_dir in "$target_path"/*/; do
        if [[ ! -d "$existing_dir" ]]; then
            continue
        fi
        local name
        name=$(basename "$existing_dir")
        local found=false
        for skill in "${skills[@]}"; do
            if [[ "$skill" == "$name" ]]; then
                found=true
                break
            fi
        done
        if ! $found; then
            print_warning "Removing stale: $name"
            rm -rf "$existing_dir"
        fi
    done
}

# ── Sync functions ────────────────────────────────────────────────────────────

# sync_target target_path label prune skills...
# Generic sync for flat-layout targets.
sync_target() {
    local target_path="$1" label="$2" prune="$3"
    shift 3
    local skills=("$@")

    mkdir -p "$target_path"

    if [[ "$prune" == "true" ]]; then
        prune_stale_skills "$target_path" "${skills[@]}"
    fi

    local count=0
    for skill_name in "${skills[@]}"; do
        hardlink_skill "$SKILLS_DIR/$skill_name" "$target_path/$skill_name"
        ((count++))
    done

    print_success "$label — $count skills synced"
}

# sync_plugins skills... — dedicated sync for nested plugin layout
sync_plugins() {
    local skills=("$@")
    local plugins_dir="$REPO_ROOT/plugins"

    # Prune plugins not in canonical source
    if [[ -d "$plugins_dir" ]]; then
        for plugin_dir in "$plugins_dir"/*/; do
            if [[ ! -d "$plugin_dir" ]]; then
                continue
            fi
            local plugin_name
            plugin_name=$(basename "$plugin_dir")
            local found=false
            for skill in "${skills[@]}"; do
                if [[ "$skill" == "$plugin_name" ]]; then
                    found=true
                    break
                fi
            done
            if ! $found; then
                print_warning "Removing stale plugin: $plugin_name"
                rm -rf "$plugin_dir"
            fi
        done
    fi

    local count=0
    for skill_name in "${skills[@]}"; do
        local target="$plugins_dir/$skill_name/skills/$skill_name"
        mkdir -p "$target"
        hardlink_skill "$SKILLS_DIR/$skill_name" "$target"
        ((count++))
    done

    print_success "plugins/ — $count skills synced"
}

# sync_project — syncs all project-level targets
sync_project() {
    local skills
    local IFS=$'\n'
    skills=($(get_skills))
    unset IFS

    echo ""
    echo "── Project Targets ─────────────────"

    for target in "${PROJECT_TARGETS[@]}"; do
        local target_path="$REPO_ROOT/$target"
        if ! sync_target "$target_path" "$target" "true" "${skills[@]}"; then
            print_warning "Failed to sync $target (continuing)"
        fi
    done

    if ! sync_plugins "${skills[@]}"; then
        print_warning "Failed to sync plugins/ (continuing)"
    fi
}

# sync_user — syncs all user-level targets (no pruning)
sync_user() {
    local skills
    local IFS=$'\n'
    skills=($(get_skills))
    unset IFS

    echo ""
    echo "── User Targets ────────────────────"

    for target_path in "${USER_TARGETS[@]}"; do
        local label="${target_path/#$HOME/~}"

        if [[ ! -d "$target_path" ]]; then
            print_info "Creating $label (first sync)"
        fi

        if ! sync_target "$target_path" "$label" "false" "${skills[@]}"; then
            print_warning "Failed to sync $label (continuing)"
        fi
    done
}

# ── Status functions ──────────────────────────────────────────────────────────

# check_target_status target_path label — checks hard link health for flat target
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

    local skills
    local IFS=$'\n'
    skills=($(get_skills))
    unset IFS

    for skill_name in "${skills[@]}"; do
        local target_file="$target_path/$skill_name/SKILL.md"
        local source_file="$SKILLS_DIR/$skill_name/SKILL.md"

        if [[ -f "$target_file" ]] && are_hardlinked "$source_file" "$target_file"; then
            ((link_count++))
        else
            broken_names+=("$skill_name")
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
        print_warning "No skills found"
        return 2
    fi
}

# check_plugins_status — checks hard link health for plugin layout
# Returns 0 if healthy, 2 if needs sync
check_plugins_status() {
    echo "Target: plugins/*/skills/*/"

    local ok_count=0
    local broken_names=()

    local skills
    local IFS=$'\n'
    skills=($(get_skills))
    unset IFS

    for skill_name in "${skills[@]}"; do
        local target_file="$REPO_ROOT/plugins/$skill_name/skills/$skill_name/SKILL.md"
        local source_file="$SKILLS_DIR/$skill_name/SKILL.md"

        if [[ -f "$target_file" ]] && are_hardlinked "$source_file" "$target_file"; then
            ((ok_count++))
        else
            broken_names+=("$skill_name")
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
        print_warning "No plugins found"
        return 2
    fi
}

# show_source_status — displays canonical source skill list
show_source_status() {
    echo "Canonical Source: $SKILLS_DIR"

    if [[ ! -d "$SKILLS_DIR" ]]; then
        print_error "Skills directory not found!"
        return 1
    fi

    local skills
    local IFS=$'\n'
    skills=($(get_skills))
    unset IFS

    print_success "Found ${#skills[@]} skills:"
    for skill in "${skills[@]}"; do
        echo "        - $skill"
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
BD Skills Sync Script
=====================

Synchronizes skills from the canonical 'skills/' directory to agent tool
locations using hard links.

Usage:
    sync-skills.sh                        Sync user-level targets (default)
    sync-skills.sh --project              Sync project-level targets only
    sync-skills.sh --all                  Sync both project + user targets
    sync-skills.sh --status               Show status for user targets (default)
    sync-skills.sh --status --project     Show status for project targets
    sync-skills.sh --status --all         Show status for all targets
    sync-skills.sh -v, --verbose          Show individual link operations
    sync-skills.sh -h, --help             Show this help message

Scopes:
    Project targets (--project):
        .agent/skills/           Agent
        .opencode/skill/         OpenCode
        .cursor/skills/          Cursor
        .gemini/skills/          Gemini CLI
        .github/skills/          GitHub Copilot
        plugins/*/skills/*/      Plugin Marketplace
        Stale skills are pruned (these dirs are fully managed by this script).

    User targets (default):
        ~/.config/opencode/skills/   OpenCode (user-level)
        ~/.gemini/skills/            Gemini CLI (user-level)
        ~/.copilot/skills/           GitHub Copilot (user-level)
        ~/.claude/skills/            Claude Code (user-level)
        ~/.agents/skills/            Cross-platform (OpenCode + Gemini CLI)
        Only managed skills are updated — external skills are never deleted.

Exit codes:
    0   All targets healthy / sync succeeded
    1   Fatal error (source missing, no skills found)
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
    if [[ ! -d "$SKILLS_DIR" ]]; then
        print_error "Canonical skills directory not found: $SKILLS_DIR"
        return 1
    fi

    if ! get_skills > /dev/null; then
        print_error "No skills found in $SKILLS_DIR"
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
        local skill_count
        skill_count=$(get_skills | wc -l | tr -d ' ')
        print_info "Found $skill_count skills to sync"

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
