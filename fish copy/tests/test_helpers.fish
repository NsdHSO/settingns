#!/usr/bin/env fish

# Test Helper Functions
# Source this file in your tests for common utilities
# Usage: source tests/test_helpers.fish

# Mock command - temporarily replace a command with custom output
function mock_command
    set -l cmd_name $argv[1]
    set -l mock_output $argv[2..-1]

    eval "
    function $cmd_name
        echo '$mock_output'
    end
    "
end

# Restore command - remove a mocked command
function restore_command
    set -l cmd_name $argv[1]
    functions -e $cmd_name
end

# Assert equals - check if two values are equal
function assert_equals
    set -l expected $argv[1]
    set -l actual $argv[2]

    test "$expected" = "$actual"
    return $status
end

# Assert contains - check if string contains substring
function assert_contains
    set -l haystack $argv[1]
    set -l needle $argv[2]

    string match -q "*$needle*" -- $haystack
    return $status
end

# Assert matches - check if string matches regex
function assert_matches
    set -l string $argv[1]
    set -l pattern $argv[2]

    string match -qr "$pattern" -- $string
    return $status
end

# Create temp file - creates temporary file and returns path
function create_temp_file
    set -l content $argv[1]
    set -l temp_file (mktemp)

    if test -n "$content"
        echo "$content" > $temp_file
    end

    echo $temp_file
end

# Create temp dir - creates temporary directory and returns path
function create_temp_dir
    mktemp -d
end

# Cleanup temp - remove temporary file or directory
function cleanup_temp
    set -l path $argv[1]

    if test -e "$path"
        rm -rf "$path"
    end
end

# Capture output - capture stdout and stderr
function capture_output
    set -l cmd $argv

    # Execute command and capture output
    eval $cmd 2>&1
end

# Assert exit code - check if last command exited with expected code
function assert_exit_code
    set -l expected $argv[1]
    set -l actual $status

    test $expected -eq $actual
    return $status
end

# Setup test env - create isolated test environment
function setup_test_env
    set -gx TEST_MODE 1
    set -gx TEST_TMPDIR (mktemp -d)
end

# Teardown test env - cleanup test environment
function teardown_test_env
    if test -n "$TEST_TMPDIR" -a -d "$TEST_TMPDIR"
        rm -rf "$TEST_TMPDIR"
    end
    set -e TEST_MODE
    set -e TEST_TMPDIR
end

# Skip test - mark test as skipped
function skip_test
    set -l reason $argv[1]
    echo "# SKIP: $reason"
    return 0
end

# Assert file exists
function assert_file_exists
    set -l file_path $argv[1]
    test -f "$file_path"
    return $status
end

# Assert dir exists
function assert_dir_exists
    set -l dir_path $argv[1]
    test -d "$dir_path"
    return $status
end

# Assert empty - check if string is empty
function assert_empty
    set -l value $argv[1]
    test -z "$value"
    return $status
end

# Assert not empty - check if string is not empty
function assert_not_empty
    set -l value $argv[1]
    test -n "$value"
    return $status
end

# Mock interactive input - simulate user input for read commands
function mock_input
    set -l input $argv

    # This is a placeholder - interactive mocking is complex in Fish
    # Consider restructuring code to separate input from logic
    echo $input
end

# Debug test - print debug information
function debug_test
    set -l message $argv
    echo "# DEBUG: $message" >&2
end

# Assert count - check array count
function assert_count
    set -l expected $argv[1]
    set -l actual_count (count $argv[2..-1])

    test $expected -eq $actual_count
    return $status
end
