#!/bin/bash
#
# sync-skills.sh - Synchronize skills from canonical source to all agent tool locations
#
# This script ensures all agent tools (OpenCode, Cursor, Gemini CLI, Plugin Marketplace)
# have access to the same skills by creating hard links from a single source of truth.
#
# Usage:
#   ./scripts/sync-skills.sh          # Run from repo root
#   ./scripts/sync-skills.sh --status # Show current status without making changes
#   ./scripts/sync-skills.sh --help   # Show help
#
# The canonical source is the 'skills/' directory at the repo root.
# All other locations use hard links to the SKILL.md files.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Canonical source directory
SKILLS_DIR="$REPO_ROOT/skills"

# Target directories for hard links
declare -a TARGETS=(
    ".opencode/skill"
    ".cursor/skills"
    ".gemini/skills"
)

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to show help
show_help() {
    cat << EOF
BD Skills Sync Script
=====================

Synchronizes skills from the canonical 'skills/' directory to all agent tool locations.

Usage:
    $0              Sync all skills (clean and recreate hard links)
    $0 --status     Show current status without making changes
    $0 --help       Show this help message

Supported Agent Tools:
    - OpenCode      (.opencode/skill/)
    - Cursor        (.cursor/skills/)
    - Gemini CLI    (.gemini/skills/)
    - Plugin Marketplace (plugins/*/skills/*/)

The canonical source is: skills/
All other locations use hard links to the SKILL.md files in the canonical source.

Note: Hard links ensure all tools can read the files directly (unlike symlinks which
some tools may not follow).

EOF
}

# Function to check if two files are hard-linked (same inode)
are_hardlinked() {
    local file1="$1"
    local file2="$2"
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        return 1
    fi
    
    local inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
    local inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
    
    [[ "$inode1" == "$inode2" ]]
}

# Function to show current status
show_status() {
    print_info "Checking skills synchronization status..."
    echo ""
    
    # Check canonical source
    echo "Canonical Source: $SKILLS_DIR"
    if [[ -d "$SKILLS_DIR" ]]; then
        local skill_count=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
        print_success "Found $skill_count skills:"
        for skill_dir in "$SKILLS_DIR"/*/; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name=$(basename "$skill_dir")
                echo "        - $skill_name"
            fi
        done
    else
        print_error "Skills directory not found!"
        return 1
    fi
    echo ""
    
    # Check each target
    for target in "${TARGETS[@]}"; do
        local target_path="$REPO_ROOT/$target"
        echo "Target: $target"
        if [[ -d "$target_path" ]]; then
            local link_count=0
            local broken_count=0
            for skill_dir in "$target_path"/*/; do
                if [[ -d "$skill_dir" ]]; then
                    local skill_name=$(basename "$skill_dir")
                    local target_file="$skill_dir/SKILL.md"
                    local source_file="$SKILLS_DIR/$skill_name/SKILL.md"
                    
                    if [[ -f "$target_file" ]]; then
                        if are_hardlinked "$source_file" "$target_file"; then
                            ((link_count++))
                        else
                            ((broken_count++))
                        fi
                    else
                        ((broken_count++))
                    fi
                fi
            done
            if [[ $broken_count -gt 0 ]]; then
                print_warning "$link_count valid hard links, $broken_count need sync"
            elif [[ $link_count -gt 0 ]]; then
                print_success "$link_count hard links OK"
            else
                print_warning "No skills found"
            fi
        else
            print_warning "Directory does not exist"
        fi
    done
    echo ""
    
    # Check plugins
    echo "Target: plugins/*/skills/*/"
    local plugin_ok=0
    local plugin_broken=0
    for plugin_dir in "$REPO_ROOT"/plugins/*/; do
        if [[ -d "$plugin_dir" ]]; then
            local plugin_name=$(basename "$plugin_dir")
            local target_file="$plugin_dir/skills/$plugin_name/SKILL.md"
            local source_file="$SKILLS_DIR/$plugin_name/SKILL.md"
            
            if [[ -f "$target_file" ]]; then
                if are_hardlinked "$source_file" "$target_file"; then
                    ((plugin_ok++))
                else
                    ((plugin_broken++))
                fi
            else
                ((plugin_broken++))
            fi
        fi
    done
    if [[ $plugin_broken -gt 0 ]]; then
        print_warning "$plugin_ok valid hard links, $plugin_broken need sync"
    elif [[ $plugin_ok -gt 0 ]]; then
        print_success "$plugin_ok hard links OK"
    else
        print_warning "No plugins found"
    fi
}

# Function to clean a target directory (remove contents, keep directory)
clean_target() {
    local target="$1"
    if [[ -d "$target" ]]; then
        # Remove all contents (files, directories, and symlinks)
        rm -rf "$target"/*
    fi
}

# Function to sync skills using hard links
sync_skills() {
    print_info "Starting skills synchronization (using hard links)..."
    echo ""
    
    # Verify canonical source exists
    if [[ ! -d "$SKILLS_DIR" ]]; then
        print_error "Canonical skills directory not found: $SKILLS_DIR"
        exit 1
    fi
    
    # Get list of skills
    local skills=()
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [[ -d "$skill_dir" ]]; then
            skills+=("$(basename "$skill_dir")")
        fi
    done
    
    if [[ ${#skills[@]} -eq 0 ]]; then
        print_error "No skills found in $SKILLS_DIR"
        exit 1
    fi
    
    print_info "Found ${#skills[@]} skills to sync: ${skills[*]}"
    echo ""
    
    # Sync to each target directory
    for target in "${TARGETS[@]}"; do
        local target_path="$REPO_ROOT/$target"
        print_info "Syncing to $target..."
        
        # Clean existing content
        clean_target "$target_path"
        
        # Create hard links for each skill
        for skill_name in "${skills[@]}"; do
            local source_skill_dir="$SKILLS_DIR/$skill_name"
            local target_skill_dir="$target_path/$skill_name"
            
            # Create skill directory
            mkdir -p "$target_skill_dir"
            
            # Hard link SKILL.md
            if [[ -f "$source_skill_dir/SKILL.md" ]]; then
                ln -f -F -v "$source_skill_dir/SKILL.md" "$target_skill_dir/SKILL.md"
            fi
            
            # Hard link any other files in the skill directory
            for file in "$source_skill_dir"/*; do
                if [[ -f "$file" ]]; then
                    local filename=$(basename "$file")
                    if [[ ! -f "$target_skill_dir/$filename" ]]; then
                        ln -f -F -v "$file" "$target_skill_dir/$filename"
                    fi
                fi
            done
        done
        
        print_success "Created ${#skills[@]} skill directories with hard links in $target"
    done
    echo ""
    
    # Sync to plugins directory
    print_info "Syncing to plugins/*/skills/*/..."
    
    for skill_name in "${skills[@]}"; do
        local plugin_dir="$REPO_ROOT/plugins/$skill_name"
        local skills_subdir="$plugin_dir/skills/$skill_name"
        local source_skill_dir="$SKILLS_DIR/$skill_name"
        
        # Create plugin directory structure
        mkdir -p "$skills_subdir"
        
        # Remove existing files
        rm -rf "$skills_subdir"/*
        
        # Hard link SKILL.md and any other files
        for file in "$source_skill_dir"/*; do
            if [[ -f "$file" ]]; then
                local filename=$(basename "$file")
                ln -f -F -v "$file" "$skills_subdir/$filename"
            fi
        done
    done
    
    print_success "Created ${#skills[@]} skill directories with hard links in plugins/"
    echo ""
    
    print_success "Skills synchronization complete!"
}

# Main entry point
main() {
    cd "$REPO_ROOT"
    
    case "${1:-}" in
        --help|-h)
            show_help
            ;;
        --status|-s)
            show_status
            ;;
        *)
            sync_skills
            echo ""
            show_status
            ;;
    esac
}

main "$@"
