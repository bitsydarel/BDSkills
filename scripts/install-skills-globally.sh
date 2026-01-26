#!/bin/bash
#
# install-skills-globally.sh - Install BD Skills into global config for opencode, gemini, claude code, cursor
#
# Usage:
#   ./scripts/install-skills-globally.sh           # Run from repo root
#   ./scripts/install-skills-globally.sh --status  # Show current global install status
#   ./scripts/install-skills-globally.sh --help    # Show help
#
# Reads from canonical 'skills/' dir in repo root. Installs to these user-global locations:
#   Opencode: ~/.config/opencode/skills/
#   Gemini CLI: ~/.gemini/skills/
#   Claude Code: ~/.claude/skills/
#   Cursor: ~/.cursor/skills/
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Expand ~ for home directory
expand_home() {
  echo "$1" | sed "s|^~|$HOME|"
}

GLOBAL_TARGETS=(
  "~/.config/opencode/skills"
  "~/.claude/skills"
  "~/.cursor/skills"
  "~/.gemini/skills"
)

TOOL_NAMES=(
  "Opencode (~/.config/opencode/skills)"
  "Claude Code (~/.claude/skills)"
  "Cursor (~/.cursor/skills)"
  "Gemini CLI (~/.gemini/skills)"
)

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_help() {
  cat << EOF
Install Skills Globally Script
=====================
Installs BD Skills from canonical 'skills/' dir to global config locations for:
  Opencode (~/.config/opencode/skills/)
  Gemini CLI (~/.gemini/skills/)
  Claude Code (~/.claude/skills/)
  Cursor (~/.cursor/skills/)

Usage:
  $0              Install/Sync skills globally (will overwrite)
  $0 --status     Check current global install status
  $0 --verify     Verify all skill files are present and correct
  $0 --help       Show this help message

Compatibility notes:
- Works on Linux/macOS (native Bash).
- For Windows: Use via WSL or Git Bash for full functionality (hard links/copies).
- If hard links cannot be created (common on network drives or cloud mounts), script will automatically fall back to copying files and warn you.
- Native PowerShell support not included (planned for future). For native Windows, manually copy skills/ contents to:
    %USERPROFILE%\.config\opencode\skills\ etc. as appropriate.
- Always re-run after major changes to skills or tool configs for clean sync.

EOF
}

are_hardlinked() {
  local file1="$1"
  local file2="$2"
  if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then return 1; fi
  local inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
  local inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
  [[ "$inode1" == "$inode2" ]]
}

status_global() {
  print_info "Checking global skills installation status..."
  echo "Canonical Source: $SKILLS_DIR"
  if [[ ! -d "$SKILLS_DIR" ]]; then print_error "Skills directory not found!"; return 1; fi
  local skill_count=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
  print_success "Found $skill_count skills:"
  for skill_dir in "$SKILLS_DIR"/*/; do
    if [[ -d "$skill_dir" ]]; then echo "      - $(basename "$skill_dir")"; fi
  done
  echo ""
  for idx in ${!GLOBAL_TARGETS[@]}; do
    target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
    tool="${TOOL_NAMES[$idx]}"
    echo "Target: $tool"
    if [[ -d "$target" ]]; then
      local link_count=0; local broken_count=0
      for skill_dir in "$target"/*/; do
        if [[ -d "$skill_dir" ]]; then
          local skill_name=$(basename "$skill_dir")
          local target_file="$skill_dir/SKILL.md"
          local source_file="$SKILLS_DIR/$skill_name/SKILL.md"
          if [[ -f "$target_file" ]]; then
            if are_hardlinked "$source_file" "$target_file"; then ((link_count++)); else ((broken_count++)); fi
          else ((broken_count++)); fi
        fi
      done
      if [[ $broken_count -gt 0 ]]; then print_warning "$link_count valid hard links, $broken_count need sync";
      elif [[ $link_count -gt 0 ]]; then print_success "$link_count hard links OK";
      else print_warning "No skills found"; fi
    else print_warning "Directory does not exist"; fi
  done
  echo ""
}

clean_global_target() {
  local target="$1"
  if [[ -d "$target" ]]; then rm -rf "$target"/*; fi
  mkdir -p "$target"
}

sync_global() {
  print_info "Starting global skills installation (using hard links)..."
  if [[ ! -d "$SKILLS_DIR" ]]; then print_error "Canonical skills directory not found: $SKILLS_DIR"; exit 1; fi
  local skills=()
  for skill_dir in "$SKILLS_DIR"/*/; do
    if [[ -d "$skill_dir" ]]; then skills+=("$(basename "$skill_dir")"); fi
  done
  if [[ ${#skills[@]} -eq 0 ]]; then print_error "No skills found in $SKILLS_DIR"; exit 1; fi
  print_info "Found ${#skills[@]} skills to install globally: ${skills[*]}"
  echo ""
  for idx in ${!GLOBAL_TARGETS[@]}; do
    target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
    tool="${TOOL_NAMES[$idx]}"
    print_info "Syncing to $tool..."
    clean_global_target "$target"
    for skill_name in "${skills[@]}"; do
      local source_skill_dir="$SKILLS_DIR/$skill_name"
      local target_skill_dir="$target/$skill_name"
      mkdir -p "$target_skill_dir"
      while IFS= read -r source_path; do
        local source_prefix="$source_skill_dir/"
        local relative_path="${source_path#$source_prefix}"
        local target_item_path="$target_skill_dir/$relative_path"
        if [[ -d "$source_path" ]]; then
          mkdir -p "$target_item_path"
        elif [[ -f "$source_path" ]]; then
          mkdir -p "$(dirname "$target_item_path")"
           if ln -f -v "$source_path" "$target_item_path" 2>/dev/null; then
             : # Hard link succeeded
           else
             cp -f "$source_path" "$target_item_path"
             print_warning "Hard link failed for $source_path, copied instead."
           fi
         fi
      done < <(find "$source_skill_dir" -mindepth 1 \( -path '*/.*' -o -name '.*' \) -prune -o -type l -prune -o -type d -print -o -type f -print)
    done
    print_success "Installed ${#skills[@]} skills in $tool"
  done
  echo ""
  print_success "Global skills installation complete!"
}

verify_global_install() {
  print_info "Verifying global skills installation... (deep file-by-file check)"
  local all_ok=1
  for idx in ${!GLOBAL_TARGETS[@]}; do
    local target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
    local tool="${TOOL_NAMES[$idx]}"
    local found_missing=0
    echo "Target: $tool"
    if [[ ! -d "$target" ]]; then print_error "Directory missing: $target"; all_ok=0; continue; fi
    for skill_dir in "$SKILLS_DIR"/*/; do
      [[ -d "$skill_dir" ]] || continue
      local skill_name=$(basename "$skill_dir")
      local src_dir="$skill_dir"
      local tgt_dir="$target/$skill_name"
      if [[ ! -d "$tgt_dir" ]]; then print_error "Skill missing: $skill_name in $tool"; found_missing=1; all_ok=0; continue; fi
      while IFS= read -r source_path; do
        local source_prefix="$src_dir/"
        local rel_path="${source_path#$source_prefix}"
        local target_path="$tgt_dir/$rel_path"
        if [[ -f "$source_path" ]]; then
          if [[ ! -f "$target_path" ]]; then
            print_error "File missing: $target_path for skill $skill_name in $tool"
            found_missing=1; all_ok=0
          else
            # Compare contents quickly
            if ! cmp -s "$source_path" "$target_path"; then
              print_warning "Content mismatch: $rel_path for $skill_name in $tool"
              all_ok=0
            fi
            # Check hard link/copy
            if are_hardlinked "$source_path" "$target_path"; then
              : # Ok
            else
              print_warning "Not hardlinked (copied): $rel_path for $skill_name in $tool"
            fi
          fi
        fi
      done < <(find "$src_dir" -mindepth 1 \( -path '*/.*' -o -name '.*' \) -prune -o -type f -print)
    done
    if [[ $found_missing -eq 0 ]]; then print_success "All files present for $tool"; fi
    echo ""
  done
  if [[ $all_ok -eq 1 ]]; then
    print_success "Verification complete: ALL skills/files present and correct."
  else
    print_error "Verification failed: issues detected above."
  fi
  echo ""
}

main() {
  cd "$REPO_ROOT"

  DRY_RUN=0
  VERBOSE=0
  POSITIONAL=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --verbose|-v)
        VERBOSE=1
        shift
        ;;
      --help|-h)
        show_help; exit 0;
        ;;
      --status|-s)
        status_global; exit 0;
        ;;
      --verify)
        verify_global_install; exit 0;
        ;;
      *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
  done
  set -- "${POSITIONAL[@]}"

  # Directory check: ensure script is run from repo root and skills/ exists
  if [[ ! -d "$SKILLS_DIR" ]]; then
    echo -e "${RED}[ERROR]${NC} 'skills/' directory not found in repo root ($REPO_ROOT).\nPlease run this script from the repository root where the canonical skills/ directory exists."
    exit 1
  fi
  sync_global
  echo ""
  status_global
  verify_global_install
}

# Enhanced sync_global to honor DRY_RUN/VERBOSE
sync_global() {
  print_info "Starting global skills installation (using hard links)..."
  if [[ ! -d "$SKILLS_DIR" ]]; then print_error "Canonical skills directory not found: $SKILLS_DIR"; exit 1; fi
  local skills=()
  for skill_dir in "$SKILLS_DIR"/*/; do
    if [[ -d "$skill_dir" ]]; then skills+=("$(basename "$skill_dir")"); fi
  done
  if [[ ${#skills[@]} -eq 0 ]]; then print_error "No skills found in $SKILLS_DIR"; exit 1; fi
  print_info "Found ${#skills[@]} skills to install globally: ${skills[*]}"
  echo ""
  for idx in ${!GLOBAL_TARGETS[@]}; do
    target=$(expand_home "${GLOBAL_TARGETS[$idx]}")
    tool="${TOOL_NAMES[$idx]}"
    print_info "Syncing to $tool..."
    if [[ "$DRY_RUN" -eq 1 ]]; then
      print_info "[DRY RUN] Would clean and init $target"
    else
      clean_global_target "$target"
    fi
    for skill_name in "${skills[@]}"; do
      local source_skill_dir="$SKILLS_DIR/$skill_name"
      local target_skill_dir="$target/$skill_name"
      if [[ "$DRY_RUN" -eq 1 ]]; then
        print_info "[DRY RUN] Would mkdir -p $target_skill_dir"
      else
        mkdir -p "$target_skill_dir"
      fi
      while IFS= read -r source_path; do
        local source_prefix="$source_skill_dir/"
        local relative_path="${source_path#$source_prefix}"
        local target_item_path="$target_skill_dir/$relative_path"
        if [[ -d "$source_path" ]]; then
          if [[ "$DRY_RUN" -eq 1 ]]; then
            [[ "$VERBOSE" -eq 1 ]] && print_info "[DRY RUN] Would mkdir -p $target_item_path"
          else
            mkdir -p "$target_item_path"
            [[ "$VERBOSE" -eq 1 ]] && print_info "Created directory $target_item_path"
          fi
        elif [[ -f "$source_path" ]]; then
          if [[ "$DRY_RUN" -eq 1 ]]; then
            [[ "$VERBOSE" -eq 1 ]] && print_info "[DRY RUN] Would link or copy $source_path -> $target_item_path"
          else
            mkdir -p "$(dirname "$target_item_path")"
            if ln -f -v "$source_path" "$target_item_path" 2>/dev/null; then
              [[ "$VERBOSE" -eq 1 ]] && print_success "Hard linked $source_path -> $target_item_path"
            else
              cp -f "$source_path" "$target_item_path"
              print_warning "Hard link failed for $source_path, copied instead."
              [[ "$VERBOSE" -eq 1 ]] && print_info "Copied $source_path -> $target_item_path"
            fi
          fi
        fi
      done < <(find "$source_skill_dir" -mindepth 1 \( -path '*/.*' -o -name '.*' \) -prune -o -type l -prune -o -type d -print -o -type f -print)
    done
    print_success "Installed ${#skills[@]} skills in $tool"
  done
  echo ""
  print_success "Global skills installation complete!"
}

main "$@"

