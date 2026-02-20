# Fish Function Testing Framework

This directory contains tests for Fish shell functions using the **fishtape** testing framework.

## Installation

### 1. Install Fishtape

```bash
fisher install jorgebucaran/fishtape
```

### 2. Verify Installation

```bash
fishtape --version
```

## Writing Tests

### Test File Structure

Create test files in the `tests/` directory with the `.test.fish` extension:

```fish
#!/usr/bin/env fish

# Test suite for your_function
# Run with: fishtape tests/your_function.test.fish

@test "description of what you're testing" (
    # Your test code here
    # Use standard fish commands and conditionals
    test $status -eq 0
) $status -eq 0
```

### Test Syntax

Fishtape uses the `@test` directive:

```fish
@test "test description" (
    # Test body
    command_to_test
) $expected_status
```

### Common Test Patterns

**1. Test function output:**
```fish
@test "function returns expected output" (
    set -l output (your_function arg1 arg2)
    string match -q "*expected*" -- $output
) $status -eq 0
```

**2. Test function exit status:**
```fish
@test "function returns error on invalid input" (
    your_function invalid_input 2>&1 >/dev/null
) $status -eq 1
```

**3. Test argument validation:**
```fish
@test "function requires arguments" (
    set -l output (your_function 2>&1)
    string match -q "*Usage:*" -- $output
) $status -eq 1
```

**4. Test string matching:**
```fish
@test "regex pattern works correctly" (
    string match -qr '^[0-9]+$' -- "12345"
) $status -eq 0
```

**5. Test file operations:**
```fish
@test "function creates expected file" (
    your_function
    test -f /path/to/expected/file
) $status -eq 0
```

## Running Tests

### Run All Tests

```bash
run_tests
```

This will execute all `*.test.fish` files in the tests directory.

### Run Specific Test File

```bash
fishtape tests/killport.test.fish
```

### Run Tests with Verbose Output

```bash
fishtape -v tests/killport.test.fish
```

## Test Examples

### Example 1: Testing Input Validation

```fish
@test "rejects non-numeric input" (
    set -l output (killport abc 2>&1)
    string match -q "*Invalid port number*" -- $output
) $status -eq 1
```

### Example 2: Testing Regex Patterns

```fish
@test "port validation regex works" (
    string match -qr '^[0-9]+$' -- "8080"
) $status -eq 0
```

### Example 3: Testing Argument Count

```fish
@test "requires minimum arguments" (
    set -l output (nxg 2>&1)
    string match -q "*Usage:*" -- $output
) $status -eq 1
```

## Best Practices

1. **One test file per function**: Name tests `function_name.test.fish`
2. **Descriptive test names**: Use clear descriptions in @test directives
3. **Fast tests**: Keep tests under 1 second total execution time
4. **Isolate tests**: Each test should be independent
5. **Test edge cases**: Invalid input, empty arguments, boundary conditions
6. **Mock external dependencies**: Avoid relying on external services or commands
7. **Clean up**: Remove temporary files/directories created during tests

## Limitations

- **Interactive functions**: Hard to test functions with `read` prompts
- **System commands**: Tests involving `kill`, `lsof`, etc. need mocking
- **Side effects**: Be careful testing functions that modify system state

## Mocking Strategies

For functions with external dependencies, create mock versions:

```fish
@test "function handles missing dependency" (
    # Create temporary function that overrides real command
    function lsof
        echo ""  # Return empty (no processes found)
    end

    set -l output (killport 8080 2>&1)
    string match -q "*No active processes*" -- $output

    # Clean up mock
    functions -e lsof
) $status -eq 0
```

## Continuous Integration

Tests can be integrated into CI/CD pipelines. See `.github/workflows/fish-tests.yml` for example.

## Troubleshooting

### Fishtape not found
```bash
fisher install jorgebucaran/fishtape
```

### Tests not running
- Ensure test files are executable: `chmod +x tests/*.test.fish`
- Check file naming: Must end with `.test.fish`
- Verify fishtape installation: `type -q fishtape`

### Tests failing unexpectedly
- Run with verbose flag: `fishtape -v tests/your_test.test.fish`
- Check for syntax errors in test file
- Verify function is loaded: `type -q your_function`

## Resources

- [Fishtape GitHub](https://github.com/jorgebucaran/fishtape)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Fish Shell Testing Best Practices](https://fishshell.com/docs/current/cmds/test.html)
