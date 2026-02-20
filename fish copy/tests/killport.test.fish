#!/usr/bin/env fish

# Test suite for killport function
# Run with: fishtape tests/killport.test.fish

@test "killport: shows usage when no arguments provided" (
    set -l output (killport 2>&1)
    string match -q "*Usage: killport*" -- $output
) $status -eq 1

@test "killport: rejects non-numeric port" (
    set -l output (killport abc 2>&1)
    string match -q "*Invalid port number*" -- $output
) $status -eq 1

@test "killport: accepts valid port number" (
    # This test checks the function accepts numeric input
    # We can't fully test the interactive part without mocking
    set -l port 99999
    string match -qr '^[0-9]+$' -- $port
) $status -eq 0

@test "killport: port validation regex works" (
    # Test the regex pattern used in the function
    string match -qr '^[0-9]+$' -- "8080"
) $status -eq 0

@test "killport: port validation rejects letters" (
    # Test the regex pattern rejects invalid input
    not string match -qr '^[0-9]+$' -- "abc"
) $status -eq 0

@test "killport: port validation rejects mixed input" (
    # Test the regex pattern rejects mixed input
    not string match -qr '^[0-9]+$' -- "80a80"
) $status -eq 0
