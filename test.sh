#!/bin/bash

# PInstall Test Suite
# This script tests various installation scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PINSTALL_SCRIPT="$SCRIPT_DIR/pinstall"
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASS_COUNT++))
}

print_failure() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAIL_COUNT++))
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit_code="${3:-0}"
    
    ((TEST_COUNT++))
    echo ""
    print_info "Running test: $test_name"
    echo "Command: $command"
    
    if eval "$command" >/dev/null 2>&1; then
        local exit_code=$?
        if [[ $exit_code -eq $expected_exit_code ]]; then
            print_success "$test_name"
        else
            print_failure "$test_name (exit code: $exit_code, expected: $expected_exit_code)"
        fi
    else
        local exit_code=$?
        if [[ $exit_code -eq $expected_exit_code ]]; then
            print_success "$test_name"
        else
            print_failure "$test_name (exit code: $exit_code, expected: $expected_exit_code)"
        fi
    fi
}

echo -e "${GREEN}PInstall Test Suite${NC}"
echo "==================="
echo ""

# Test help functionality
run_test "Help message display" "$PINSTALL_SCRIPT --help"

# Test argument validation (these should fail)
run_test "Missing OS argument" "$PINSTALL_SCRIPT --app=go --ver=1.24.4" 1
run_test "Missing arch argument" "$PINSTALL_SCRIPT --linux --ubuntu --app=go --ver=1.24.4" 1
run_test "Missing app argument" "$PINSTALL_SCRIPT --linux --ubuntu --x64 --ver=1.24.4" 1
run_test "Missing version argument" "$PINSTALL_SCRIPT --linux --ubuntu --x64 --app=go" 1

# Test unsupported combinations
run_test "Unsupported app" "$PINSTALL_SCRIPT --linux --ubuntu --x64 --app=unsupported --ver=1.0.0" 1
run_test "Invalid OS" "$PINSTALL_SCRIPT --invalid --ubuntu --x64 --app=go --ver=1.24.4" 1

# Test system detection
run_test "System auto-detection" "$PINSTALL_SCRIPT --app=go --ver=1.24.4 --help"

# Test dry-run functionality (if implemented)
if $PINSTALL_SCRIPT --help | grep -q "dry-run"; then
    run_test "Dry run Go installation" "$PINSTALL_SCRIPT --linux --ubuntu --x64 --app=go --ver=1.24.4 --dry-run"
    run_test "Dry run Node installation" "$PINSTALL_SCRIPT --linux --ubuntu --x64 --app=node --ver=20.10.0 --dry-run"
fi

echo ""
echo "=================="
echo -e "${GREEN}Test Summary${NC}"
echo "=================="
echo "Total tests: $TEST_COUNT"
echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
echo -e "Failed: ${RED}$FAIL_COUNT${NC}"

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
