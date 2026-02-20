#!/usr/bin/env fish

# Test suite for FUNCTION_NAME
# Run with: fishtape tests/FUNCTION_NAME.test.fish
#
# Instructions:
# 1. Replace FUNCTION_NAME with your function name
# 2. Add tests below using @test directive
# 3. Run: fishtape tests/FUNCTION_NAME.test.fish
# 4. Tests automatically included in run_tests

# Optional: Load test helpers
# source (dirname (status -f))/test_helpers.fish

# Test 1: Usage/Help validation
@test "FUNCTION_NAME: shows usage when no arguments provided" (
    set -l output (FUNCTION_NAME 2>&1)
    string match -q "*Usage:*" -- $output
) $status -eq 1

# Test 2: Valid input acceptance
@test "FUNCTION_NAME: accepts valid input" (
    set -l output (FUNCTION_NAME valid_arg)
    test -n "$output"
) $status -eq 0

# Test 3: Invalid input rejection
@test "FUNCTION_NAME: rejects invalid input" (
    set -l output (FUNCTION_NAME "" 2>&1)
    string match -q "*error*" -- $output
) $status -eq 1

# Test 4: Expected output format
@test "FUNCTION_NAME: outputs expected format" (
    set -l output (FUNCTION_NAME test_arg)
    string match -q "*expected_text*" -- $output
) $status -eq 0

# Test 5: Exit code on success
@test "FUNCTION_NAME: exits successfully on valid input" (
    FUNCTION_NAME valid_arg >/dev/null 2>&1
) $status -eq 0

# Test 6: Exit code on failure
@test "FUNCTION_NAME: exits with error on invalid input" (
    FUNCTION_NAME invalid_arg >/dev/null 2>&1
) $status -eq 1

# Add more tests as needed:
# - Edge cases
# - Boundary conditions
# - Special characters
# - Empty strings
# - Large inputs
# - Concurrent operations
# etc.
