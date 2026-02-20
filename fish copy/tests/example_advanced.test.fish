#!/usr/bin/env fish

# Advanced testing examples for Fish functions
# Demonstrates various testing patterns and techniques

# Example 1: Testing with setup and teardown
set -l temp_dir ""

function setup
    set temp_dir (mktemp -d)
end

function teardown
    if test -n "$temp_dir" -a -d "$temp_dir"
        rm -rf $temp_dir
    end
end

@test "advanced: test with file creation" (
    setup
    echo "test content" > $temp_dir/test.txt
    test -f $temp_dir/test.txt
    set -l result $status
    teardown
    test $result -eq 0
) $status -eq 0

# Example 2: Testing with mocked commands
@test "advanced: mock external command" (
    # Save original function if it exists
    if type -q original_command
        functions -c original_command original_command_backup
    end

    # Create mock
    function lsof
        echo "12345"  # Mock PID
    end

    # Test with mock
    set -l output (lsof -ti :8080)
    set -l result (test "$output" = "12345")

    # Restore original or remove mock
    functions -e lsof
    if type -q original_command_backup
        functions -c original_command_backup original_command
        functions -e original_command_backup
    end

    test $result -eq 0
) $status -eq 0

# Example 3: Testing environment variables
@test "advanced: environment variable handling" (
    set -l original_value $MY_VAR

    set -gx MY_VAR "test_value"
    set -l result (test "$MY_VAR" = "test_value")

    # Restore original value
    if test -n "$original_value"
        set -gx MY_VAR $original_value
    else
        set -e MY_VAR
    end

    test $result -eq 0
) $status -eq 0

# Example 4: Testing multiple conditions
@test "advanced: multiple assertions" (
    set -l test1 (string match -q "hello" -- "hello world")
    set -l status1 $status

    set -l test2 (math "2 + 2")
    set -l result (test "$test2" -eq 4)
    set -l status2 $status

    test $status1 -eq 0 -a $status2 -eq 0
) $status -eq 0

# Example 5: Testing error handling
@test "advanced: captures stderr" (
    function test_error_function
        echo "Error message" >&2
        return 1
    end

    set -l output (test_error_function 2>&1)
    set -l exit_status $status

    functions -e test_error_function

    test $exit_status -eq 1 -a (string match -q "*Error message*" -- "$output")
) $status -eq 0

# Example 6: Testing string operations
@test "advanced: complex string matching" (
    set -l test_string "Component MyComponent created successfully"

    string match -qr 'Component .+ created' -- $test_string
) $status -eq 0

# Example 7: Testing array operations
@test "advanced: array manipulation" (
    set -l arr one two three
    set -l count (count $arr)

    test $count -eq 3
) $status -eq 0

# Example 8: Testing conditional logic
@test "advanced: switch statement behavior" (
    set -l input "component"
    set -l result ""

    switch $input
        case component c
            set result "matched"
        case '*'
            set result "not matched"
    end

    test "$result" = "matched"
) $status -eq 0

# Example 9: Testing math operations
@test "advanced: mathematical calculations" (
    set -l result (math "10 * 2 + 5")
    test $result -eq 25
) $status -eq 0

# Example 10: Testing path operations
@test "advanced: path manipulation" (
    set -l test_path "/home/user/project/file.txt"
    set -l dirname (dirname $test_path)
    set -l basename (basename $test_path)

    test "$dirname" = "/home/user/project" -a "$basename" = "file.txt"
) $status -eq 0
