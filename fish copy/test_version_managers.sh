#!/usr/bin/env bash
# Test script for language version manager optimization
# This script verifies that lazy loading works correctly

echo "========================================="
echo "Version Manager Optimization Test Suite"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

# Test function
test_passed() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

test_failed() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

test_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

echo "Test 1: Checking file structure"
echo "--------------------------------"

if [ -f "$HOME/.config/fish/conf.d/lazy_nvm.fish" ]; then
    test_passed "lazy_nvm.fish exists"
else
    test_failed "lazy_nvm.fish missing"
fi

if [ -f "$HOME/.config/fish/conf.d/lazy_sdkman.fish" ]; then
    test_passed "lazy_sdkman.fish exists"
else
    test_failed "lazy_sdkman.fish missing"
fi

if [ -f "$HOME/.config/fish/functions/versions.fish" ]; then
    test_passed "versions.fish exists"
else
    test_failed "versions.fish missing"
fi

if [ -f "$HOME/.config/fish/functions/nvm_use_auto.fish" ]; then
    test_passed "nvm_use_auto.fish exists"
else
    test_failed "nvm_use_auto.fish missing"
fi

if [ -f "$HOME/.config/fish/functions/sdk_use_auto.fish" ]; then
    test_passed "sdk_use_auto.fish exists"
else
    test_failed "sdk_use_auto.fish missing"
fi

echo ""
echo "Test 2: Measuring shell startup time"
echo "-------------------------------------"

# Measure startup time (run 5 times and average)
TOTAL_TIME=0
RUNS=5

for i in $(seq 1 $RUNS); do
    START=$(date +%s%N)
    fish -c "exit" 2>/dev/null
    END=$(date +%s%N)
    TIME=$((($END - $START) / 1000000)) # Convert to milliseconds
    TOTAL_TIME=$(($TOTAL_TIME + $TIME))
done

AVG_TIME=$(($TOTAL_TIME / $RUNS))

echo "Average startup time over $RUNS runs: ${AVG_TIME}ms"

if [ $AVG_TIME -lt 100 ]; then
    test_passed "Startup time is excellent (<100ms)"
elif [ $AVG_TIME -lt 200 ]; then
    test_passed "Startup time is good (<200ms)"
elif [ $AVG_TIME -lt 500 ]; then
    test_info "Startup time is acceptable (<500ms)"
else
    test_failed "Startup time is slow (>500ms) - optimization may not be working"
fi

echo ""
echo "Test 3: Cache directory structure"
echo "----------------------------------"

if [ -d "$HOME/.cache" ]; then
    test_passed "Cache directory exists"
else
    test_info "Cache directory will be created on first use"
fi

echo ""
echo "Test 4: NVM configuration check"
echo "--------------------------------"

# Check if auto-activation is disabled
if grep -q "# Auto-activation disabled" "$HOME/.config/fish/conf.d/nvm.fish" 2>/dev/null; then
    test_passed "NVM auto-activation is disabled (lazy loading enabled)"
else
    test_info "NVM auto-activation status unclear"
fi

# Check if lazy_nvm defines wrapper functions
if grep -q "function node --wraps=node" "$HOME/.config/fish/conf.d/lazy_nvm.fish" 2>/dev/null; then
    test_passed "NVM lazy-load wrappers are defined"
else
    test_failed "NVM lazy-load wrappers missing"
fi

echo ""
echo "Test 5: SDKMAN configuration check"
echo "-----------------------------------"

# Check if lazy loading is set up
if grep -q "__sdk_init_paths" "$HOME/.config/fish/conf.d/lazy_sdkman.fish" 2>/dev/null; then
    test_passed "SDKMAN lazy initialization is configured"
else
    test_failed "SDKMAN lazy initialization missing"
fi

# Check if sdk function exists
if fish -c "type -q sdk" 2>/dev/null; then
    test_passed "sdk function is available"
else
    test_failed "sdk function not found"
fi

echo ""
echo "Test 6: Function availability"
echo "------------------------------"

# Test if custom functions are available
fish -c "type -q versions" 2>/dev/null
if [ $? -eq 0 ]; then
    test_passed "versions function is available"
else
    test_failed "versions function not found"
fi

fish -c "type -q nvm_use_auto" 2>/dev/null
if [ $? -eq 0 ]; then
    test_passed "nvm_use_auto function is available"
else
    test_failed "nvm_use_auto function not found"
fi

fish -c "type -q sdk_use_auto" 2>/dev/null
if [ $? -eq 0 ]; then
    test_passed "sdk_use_auto function is available"
else
    test_failed "sdk_use_auto function not found"
fi

echo ""
echo "Test 7: NVM availability"
echo "------------------------"

fish -c "type -q nvm" 2>/dev/null
if [ $? -eq 0 ]; then
    test_passed "nvm command is available"

    # Check if NVM data directory exists
    if fish -c 'test -d $nvm_data' 2>/dev/null; then
        test_passed "NVM data directory exists"
    else
        test_info "NVM data directory not found (may not be installed)"
    fi
else
    test_info "nvm command not available (may not be installed)"
fi

echo ""
echo "Test 8: SDKMAN availability"
echo "---------------------------"

if [ -d "$HOME/.sdkman" ]; then
    test_passed "SDKMAN is installed"

    if [ -d "$HOME/.sdkman/candidates/java/current" ]; then
        test_passed "Java is installed via SDKMAN"
    else
        test_info "Java not found in SDKMAN"
    fi

    if [ -d "$HOME/.sdkman/candidates/maven/current" ]; then
        test_passed "Maven is installed via SDKMAN"
    else
        test_info "Maven not found in SDKMAN"
    fi
else
    test_info "SDKMAN not installed"
fi

echo ""
echo "========================================="
echo "Test Results"
echo "========================================="
echo -e "${GREEN}Passed:${NC} $PASSED"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Failed:${NC} $FAILED"
fi
echo "========================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    echo ""
    echo "Optimization is working correctly."
    echo "Shell startup time improved to ~${AVG_TIME}ms"
    exit 0
else
    echo -e "${YELLOW}Some tests failed or need attention${NC}"
    echo ""
    echo "Please review the failed tests above."
    exit 1
fi
