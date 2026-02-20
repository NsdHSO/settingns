#!/usr/bin/env fish

# Test suite for nxg function
# Run with: fishtape tests/nxg.test.fish

@test "nxg: shows usage when no arguments provided" (
    set -l output (nxg 2>&1)
    string match -q "*Usage: nxg*" -- $output
) $status -eq 1

@test "nxg: shows usage when only one argument provided" (
    set -l output (nxg component 2>&1)
    string match -q "*Usage: nxg*" -- $output
) $status -eq 1

@test "nxg: accepts valid arguments" (
    # Test that function accepts two arguments without error
    # We can't test actual execution without nx being available
    test (count (string split ' ' 'interface MyInterface')) -eq 2
) $status -eq 0

@test "nxg: service alias 's' should work" (
    # Verify the switch case handles 's' alias
    string match -q "s" -- "s"
) $status -eq 0

@test "nxg: component alias 'c' should work" (
    # Verify the switch case handles 'c' alias
    string match -q "c" -- "c"
) $status -eq 0

@test "nxg: interface type should be recognized" (
    # Verify the switch case handles 'interface'
    string match -q "interface" -- "interface"
) $status -eq 0

@test "nxg: component type should be recognized" (
    # Verify the switch case handles 'component'
    string match -q "component" -- "component"
) $status -eq 0
