#!/usr/bin/env fish

# Tests for test helper functions
# Run with: fishtape tests/test_helpers.test.fish

source (dirname (status -f))/test_helpers.fish

@test "helpers: assert_equals with matching strings" (
    assert_equals "hello" "hello"
) $status -eq 0

@test "helpers: assert_equals with different strings" (
    not assert_equals "hello" "world"
) $status -eq 0

@test "helpers: assert_contains finds substring" (
    assert_contains "hello world" "world"
) $status -eq 0

@test "helpers: assert_contains with missing substring" (
    not assert_contains "hello world" "foo"
) $status -eq 0

@test "helpers: assert_matches with valid regex" (
    assert_matches "test123" '^test[0-9]+$'
) $status -eq 0

@test "helpers: assert_matches with invalid regex" (
    not assert_matches "test" '^test[0-9]+$'
) $status -eq 0

@test "helpers: create_temp_file creates file" (
    set -l temp (create_temp_file "test content")
    set -l result (test -f "$temp")
    cleanup_temp $temp
    test $result -eq 0
) $status -eq 0

@test "helpers: create_temp_dir creates directory" (
    set -l temp (create_temp_dir)
    set -l result (test -d "$temp")
    cleanup_temp $temp
    test $result -eq 0
) $status -eq 0

@test "helpers: assert_empty with empty string" (
    assert_empty ""
) $status -eq 0

@test "helpers: assert_not_empty with non-empty string" (
    assert_not_empty "hello"
) $status -eq 0

@test "helpers: assert_count with correct count" (
    set -l arr one two three
    assert_count 3 $arr
) $status -eq 0

@test "helpers: mock_command creates mock" (
    mock_command test_cmd "mocked output"
    set -l output (test_cmd)
    restore_command test_cmd
    test "$output" = "mocked output"
) $status -eq 0
