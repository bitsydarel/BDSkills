#!/bin/bash
#
# test_sync_skills.sh - Tests for the sync-skills.sh script
#
# Usage:
#   ./tests/test_sync_skills.sh          # Run all tests
#   ./tests/test_sync_skills.sh -v       # Run with verbose output
#
# These tests create a temporary directory structure, run the sync script,
# and verify the expected behavior.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SYNC_SCRIPT="$REPO_ROOT/scripts/sync-skills.sh"

# Temporary test directory
TEST_DIR=""

# ============================================================================
# Test Framework Functions
# ============================================================================

setup_test_env() {
    # Create a temporary directory that mimics the repo structure
    TEST_DIR=$(mktemp -d)
    
    # Create the scripts directory and copy the sync script
    mkdir -p "$TEST_DIR/scripts"
    cp "$SYNC_SCRIPT" "$TEST_DIR/scripts/sync-skills.sh"
    chmod +x "$TEST_DIR/scripts/sync-skills.sh"
    
    # Create canonical skills directory with test skills
    mkdir -p "$TEST_DIR/skills/test-skill-1"
    mkdir -p "$TEST_DIR/skills/test-skill-2"
    mkdir -p "$TEST_DIR/skills/test-skill-3"
    
    echo "# Test Skill 1" > "$TEST_DIR/skills/test-skill-1/SKILL.md"
    echo "This is test skill 1 content." >> "$TEST_DIR/skills/test-skill-1/SKILL.md"
    
    echo "# Test Skill 2" > "$TEST_DIR/skills/test-skill-2/SKILL.md"
    echo "This is test skill 2 content." >> "$TEST_DIR/skills/test-skill-2/SKILL.md"
    
    echo "# Test Skill 3" > "$TEST_DIR/skills/test-skill-3/SKILL.md"
    echo "This is test skill 3 content." >> "$TEST_DIR/skills/test-skill-3/SKILL.md"
    
    # Create target directories
    mkdir -p "$TEST_DIR/.opencode/skill"
    mkdir -p "$TEST_DIR/.cursor/skills"
    mkdir -p "$TEST_DIR/.gemini/skills"
    mkdir -p "$TEST_DIR/plugins"
    
    if $VERBOSE; then
        echo "Test environment created at: $TEST_DIR"
    fi
}

teardown_test_env() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
        if $VERBOSE; then
            echo "Test environment cleaned up"
        fi
    fi
}

# Run a test function
run_test() {
    local test_name="$1"
    local test_func="$2"
    
    ((TESTS_RUN++))
    
    # Setup fresh environment for each test
    setup_test_env
    
    if $VERBOSE; then
        echo ""
        echo -e "${BLUE}Running: $test_name${NC}"
    fi
    
    # Run the test
    local result=0
    if $test_func; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $test_name"
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $test_name"
        result=1
    fi
    
    # Cleanup
    teardown_test_env
    
    return $result
}

# Assert functions
assert_file_exists() {
    local file="$1"
    local msg="${2:-File should exist: $file}"
    if [[ -f "$file" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg"
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local msg="${2:-Directory should exist: $dir}"
    if [[ -d "$dir" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg"
        return 1
    fi
}

assert_files_hardlinked() {
    local file1="$1"
    local file2="$2"
    local msg="${3:-Files should be hard-linked}"
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        $VERBOSE && echo "  FAIL: $msg (one or both files don't exist)"
        return 1
    fi
    
    local inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
    local inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
    
    if [[ "$inode1" == "$inode2" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg (inodes differ: $inode1 vs $inode2)"
        return 1
    fi
}

assert_files_not_hardlinked() {
    local file1="$1"
    local file2="$2"
    local msg="${3:-Files should NOT be hard-linked}"
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        return 0  # If files don't exist, they're not linked
    fi
    
    local inode1=$(stat -f "%i" "$file1" 2>/dev/null || stat -c "%i" "$file1" 2>/dev/null)
    local inode2=$(stat -f "%i" "$file2" 2>/dev/null || stat -c "%i" "$file2" 2>/dev/null)
    
    if [[ "$inode1" != "$inode2" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg (inodes are same: $inode1)"
        return 1
    fi
}

assert_file_content() {
    local file="$1"
    local expected="$2"
    local msg="${3:-File content should match}"
    
    if [[ ! -f "$file" ]]; then
        $VERBOSE && echo "  FAIL: $msg (file doesn't exist)"
        return 1
    fi
    
    local actual=$(cat "$file")
    if [[ "$actual" == "$expected" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg"
        $VERBOSE && echo "    Expected: $expected"
        $VERBOSE && echo "    Actual: $actual"
        return 1
    fi
}

assert_output_contains() {
    local output="$1"
    local expected="$2"
    local msg="${3:-Output should contain: $expected}"
    
    if [[ "$output" == *"$expected"* ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg"
        return 1
    fi
}

assert_exit_code() {
    local actual="$1"
    local expected="$2"
    local msg="${3:-Exit code should be $expected}"
    
    if [[ "$actual" -eq "$expected" ]]; then
        return 0
    else
        $VERBOSE && echo "  FAIL: $msg (got $actual)"
        return 1
    fi
}

# ============================================================================
# Test Cases
# ============================================================================

# --- Basic Sync Tests ---

test_sync_creates_hardlinks_in_opencode() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_file_exists ".opencode/skill/test-skill-1/SKILL.md" && \
    assert_file_exists ".opencode/skill/test-skill-2/SKILL.md" && \
    assert_file_exists ".opencode/skill/test-skill-3/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".opencode/skill/test-skill-1/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-2/SKILL.md" ".opencode/skill/test-skill-2/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-3/SKILL.md" ".opencode/skill/test-skill-3/SKILL.md"
}

test_sync_creates_hardlinks_in_cursor() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_file_exists ".cursor/skills/test-skill-1/SKILL.md" && \
    assert_file_exists ".cursor/skills/test-skill-2/SKILL.md" && \
    assert_file_exists ".cursor/skills/test-skill-3/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".cursor/skills/test-skill-1/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-2/SKILL.md" ".cursor/skills/test-skill-2/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-3/SKILL.md" ".cursor/skills/test-skill-3/SKILL.md"
}

test_sync_creates_hardlinks_in_gemini() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_file_exists ".gemini/skills/test-skill-1/SKILL.md" && \
    assert_file_exists ".gemini/skills/test-skill-2/SKILL.md" && \
    assert_file_exists ".gemini/skills/test-skill-3/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".gemini/skills/test-skill-1/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-2/SKILL.md" ".gemini/skills/test-skill-2/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-3/SKILL.md" ".gemini/skills/test-skill-3/SKILL.md"
}

test_sync_creates_hardlinks_in_plugins() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_file_exists "plugins/test-skill-1/skills/test-skill-1/SKILL.md" && \
    assert_file_exists "plugins/test-skill-2/skills/test-skill-2/SKILL.md" && \
    assert_file_exists "plugins/test-skill-3/skills/test-skill-3/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" "plugins/test-skill-1/skills/test-skill-1/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-2/SKILL.md" "plugins/test-skill-2/skills/test-skill-2/SKILL.md" && \
    assert_files_hardlinked "skills/test-skill-3/SKILL.md" "plugins/test-skill-3/skills/test-skill-3/SKILL.md"
}

test_sync_creates_skill_directories() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_dir_exists ".opencode/skill/test-skill-1" && \
    assert_dir_exists ".opencode/skill/test-skill-2" && \
    assert_dir_exists ".opencode/skill/test-skill-3" && \
    assert_dir_exists ".cursor/skills/test-skill-1" && \
    assert_dir_exists ".gemini/skills/test-skill-1" && \
    assert_dir_exists "plugins/test-skill-1/skills/test-skill-1"
}

# --- Hard Link Behavior Tests ---

test_hardlinks_share_content_changes() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    # Modify the canonical file
    echo "MODIFIED CONTENT" > "skills/test-skill-1/SKILL.md"
    
    # All linked files should have the same content
    local content1=$(cat ".opencode/skill/test-skill-1/SKILL.md")
    local content2=$(cat ".cursor/skills/test-skill-1/SKILL.md")
    local content3=$(cat ".gemini/skills/test-skill-1/SKILL.md")
    local content4=$(cat "plugins/test-skill-1/skills/test-skill-1/SKILL.md")
    
    [[ "$content1" == "MODIFIED CONTENT" ]] && \
    [[ "$content2" == "MODIFIED CONTENT" ]] && \
    [[ "$content3" == "MODIFIED CONTENT" ]] && \
    [[ "$content4" == "MODIFIED CONTENT" ]]
}

test_sync_cleans_old_content() {
    cd "$TEST_DIR"
    
    # Create some old content that should be cleaned
    mkdir -p ".opencode/skill/old-skill"
    echo "old content" > ".opencode/skill/old-skill/SKILL.md"
    echo "stale file" > ".opencode/skill/stale.txt"
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    # Old content should be gone
    [[ ! -d ".opencode/skill/old-skill" ]] && \
    [[ ! -f ".opencode/skill/stale.txt" ]]
}

test_sync_handles_additional_files() {
    cd "$TEST_DIR"
    
    # Add additional files to a skill
    echo "Extra content" > "skills/test-skill-1/extra.md"
    echo "README" > "skills/test-skill-1/README.md"
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    # Additional files should also be hard-linked
    assert_file_exists ".opencode/skill/test-skill-1/extra.md" && \
    assert_file_exists ".opencode/skill/test-skill-1/README.md" && \
    assert_files_hardlinked "skills/test-skill-1/extra.md" ".opencode/skill/test-skill-1/extra.md" && \
    assert_files_hardlinked "skills/test-skill-1/README.md" ".opencode/skill/test-skill-1/README.md"
}

test_sync_is_idempotent() {
    cd "$TEST_DIR"
    
    # Run sync twice
    ./scripts/sync-skills.sh > /dev/null 2>&1
    local inode1=$(stat -f "%i" ".opencode/skill/test-skill-1/SKILL.md" 2>/dev/null || stat -c "%i" ".opencode/skill/test-skill-1/SKILL.md" 2>/dev/null)
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    local inode2=$(stat -f "%i" ".opencode/skill/test-skill-1/SKILL.md" 2>/dev/null || stat -c "%i" ".opencode/skill/test-skill-1/SKILL.md" 2>/dev/null)
    
    # After re-sync, files should still be hard-linked to canonical source
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".opencode/skill/test-skill-1/SKILL.md"
}

# --- Status Command Tests ---

test_status_shows_ok_when_synced() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    local output=$(./scripts/sync-skills.sh --status 2>&1)
    
    assert_output_contains "$output" "hard links OK" && \
    assert_output_contains "$output" "3 skills"
}

test_status_shows_warning_when_not_synced() {
    cd "$TEST_DIR"
    
    # Don't sync, just check status
    local output=$(./scripts/sync-skills.sh --status 2>&1)
    
    # Should show warnings or "No skills found" since nothing is synced
    assert_output_contains "$output" "No skills found" || \
    assert_output_contains "$output" "need sync"
}

test_status_detects_broken_hardlinks() {
    cd "$TEST_DIR"
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    # Break a hard link by replacing with a copy
    rm ".opencode/skill/test-skill-1/SKILL.md"
    cp "skills/test-skill-1/SKILL.md" ".opencode/skill/test-skill-1/SKILL.md"
    
    local output=$(./scripts/sync-skills.sh --status 2>&1)
    
    assert_output_contains "$output" "need sync"
}

# --- Help Command Tests ---

test_help_shows_usage() {
    cd "$TEST_DIR"
    local output=$(./scripts/sync-skills.sh --help 2>&1)
    
    assert_output_contains "$output" "Usage:" && \
    assert_output_contains "$output" "--status" && \
    assert_output_contains "$output" "--help"
}

test_help_shows_supported_tools() {
    cd "$TEST_DIR"
    local output=$(./scripts/sync-skills.sh --help 2>&1)
    
    assert_output_contains "$output" "OpenCode" && \
    assert_output_contains "$output" "Cursor" && \
    assert_output_contains "$output" "Gemini"
}

# --- Error Handling Tests ---

test_fails_when_skills_dir_missing() {
    cd "$TEST_DIR"
    rm -rf skills
    
    local exit_code=0
    ./scripts/sync-skills.sh > /dev/null 2>&1 || exit_code=$?
    
    assert_exit_code "$exit_code" 1
}

test_fails_when_no_skills_found() {
    cd "$TEST_DIR"
    rm -rf skills/*
    
    local exit_code=0
    ./scripts/sync-skills.sh > /dev/null 2>&1 || exit_code=$?
    
    assert_exit_code "$exit_code" 1
}

test_creates_target_dirs_if_missing() {
    cd "$TEST_DIR"
    rm -rf .opencode .cursor .gemini
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_dir_exists ".opencode/skill" && \
    assert_dir_exists ".cursor/skills" && \
    assert_dir_exists ".gemini/skills"
}

# --- Verbose Output Tests ---

test_verbose_output_shows_link_creation() {
    cd "$TEST_DIR"
    local output=$(./scripts/sync-skills.sh 2>&1)
    
    # With -v flag on ln, should show link creation
    assert_output_contains "$output" "=>" && \
    assert_output_contains "$output" "SKILL.md"
}

test_output_shows_success_message() {
    cd "$TEST_DIR"
    local output=$(./scripts/sync-skills.sh 2>&1)
    
    assert_output_contains "$output" "Skills synchronization complete"
}

test_output_shows_skill_count() {
    cd "$TEST_DIR"
    local output=$(./scripts/sync-skills.sh 2>&1)
    
    assert_output_contains "$output" "3 skills to sync"
}

# --- Edge Cases ---

test_handles_skill_with_spaces_in_content() {
    cd "$TEST_DIR"
    echo "This content has    multiple   spaces" > "skills/test-skill-1/SKILL.md"
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    local content=$(cat ".opencode/skill/test-skill-1/SKILL.md")
    [[ "$content" == "This content has    multiple   spaces" ]]
}

test_handles_skill_with_special_characters() {
    cd "$TEST_DIR"
    echo '# Special chars: $VAR `cmd` "quotes" '\''single'\'' & | > <' > "skills/test-skill-1/SKILL.md"
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".opencode/skill/test-skill-1/SKILL.md"
}

test_handles_empty_skill_file() {
    cd "$TEST_DIR"
    > "skills/test-skill-1/SKILL.md"  # Create empty file
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_file_exists ".opencode/skill/test-skill-1/SKILL.md" && \
    [[ ! -s ".opencode/skill/test-skill-1/SKILL.md" ]]  # File exists but is empty
}

test_handles_large_skill_file() {
    cd "$TEST_DIR"
    # Create a large file (100KB)
    dd if=/dev/zero bs=1024 count=100 2>/dev/null | tr '\0' 'x' > "skills/test-skill-1/SKILL.md"
    
    ./scripts/sync-skills.sh > /dev/null 2>&1
    
    assert_files_hardlinked "skills/test-skill-1/SKILL.md" ".opencode/skill/test-skill-1/SKILL.md"
}

# ============================================================================
# Test Runner
# ============================================================================

echo ""
echo "========================================"
echo "  sync-skills.sh Test Suite"
echo "========================================"
echo ""

# Run all tests
run_test "sync creates hard links in .opencode/skill" test_sync_creates_hardlinks_in_opencode
run_test "sync creates hard links in .cursor/skills" test_sync_creates_hardlinks_in_cursor
run_test "sync creates hard links in .gemini/skills" test_sync_creates_hardlinks_in_gemini
run_test "sync creates hard links in plugins/" test_sync_creates_hardlinks_in_plugins
run_test "sync creates skill directories" test_sync_creates_skill_directories

run_test "hard links share content changes" test_hardlinks_share_content_changes
run_test "sync cleans old content" test_sync_cleans_old_content
run_test "sync handles additional files in skill dir" test_sync_handles_additional_files
run_test "sync is idempotent" test_sync_is_idempotent

run_test "status shows OK when synced" test_status_shows_ok_when_synced
run_test "status shows warning when not synced" test_status_shows_warning_when_not_synced
run_test "status detects broken hard links" test_status_detects_broken_hardlinks

run_test "help shows usage" test_help_shows_usage
run_test "help shows supported tools" test_help_shows_supported_tools

run_test "fails when skills directory is missing" test_fails_when_skills_dir_missing
run_test "fails when no skills found" test_fails_when_no_skills_found
run_test "creates target directories if missing" test_creates_target_dirs_if_missing

run_test "verbose output shows link creation" test_verbose_output_shows_link_creation
run_test "output shows success message" test_output_shows_success_message
run_test "output shows skill count" test_output_shows_skill_count

run_test "handles skill with spaces in content" test_handles_skill_with_spaces_in_content
run_test "handles skill with special characters" test_handles_skill_with_special_characters
run_test "handles empty skill file" test_handles_empty_skill_file
run_test "handles large skill file" test_handles_large_skill_file

# Summary
echo ""
echo "========================================"
echo "  Results: $TESTS_PASSED/$TESTS_RUN passed"
if [[ $TESTS_FAILED -gt 0 ]]; then
    echo -e "  ${RED}$TESTS_FAILED tests failed${NC}"
    echo "========================================"
    exit 1
else
    echo -e "  ${GREEN}All tests passed!${NC}"
    echo "========================================"
    exit 0
fi
