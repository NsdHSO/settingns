# Fish Function Testing Guide

Complete guide for testing Fish shell functions in this repository.

## Quick Start

### 1. Install Fishtape

```bash
fisher install jorgebucaran/fishtape
```

### 2. Run All Tests

```bash
run_tests
```

### 3. Run Specific Test

```bash
fishtape tests/killport.test.fish
```

## Installation

Fishtape is a TAP-compliant testing framework for Fish. It's lightweight and fast.

```bash
# Install fisher if not already installed
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Install fishtape
fisher install jorgebucaran/fishtape

# Verify installation
fishtape --version
```

## Directory Structure

```
~/.config/fish/
├── functions/              # Your Fish functions
│   ├── killport.fish
│   ├── nxg.fish
│   └── run_tests.fish     # Test runner function
├── tests/                 # Test files
│   ├── killport.test.fish
│   ├── nxg.test.fish
│   ├── example_advanced.test.fish
│   └── README.md          # Detailed testing documentation
├── .github/
│   └── workflows/
│       └── fish-tests.yml # CI/CD configuration
└── TESTING.md             # This file
```

## Writing Tests

### Basic Test Structure

```fish
#!/usr/bin/env fish

@test "description" (
    # Test code
    command_to_test
) $expected_exit_status
```

### Example: Testing killport

```fish
@test "killport: shows usage when no arguments" (
    set -l output (killport 2>&1)
    string match -q "*Usage: killport*" -- $output
) $status -eq 1
```

### Example: Testing nxg

```fish
@test "nxg: requires two arguments" (
    set -l output (nxg component 2>&1)
    string match -q "*Usage: nxg*" -- $output
) $status -eq 1
```

## Test Patterns

### 1. Testing Exit Status

```fish
@test "function exits with error" (
    your_function invalid_input 2>&1 >/dev/null
) $status -eq 1

@test "function exits successfully" (
    your_function valid_input 2>&1 >/dev/null
) $status -eq 0
```

### 2. Testing Output

```fish
@test "function prints expected message" (
    set -l output (your_function)
    string match -q "*expected message*" -- $output
) $status -eq 0
```

### 3. Testing Input Validation

```fish
@test "rejects invalid input" (
    set -l output (your_function "" 2>&1)
    string match -q "*error*" -- $output
) $status -eq 1
```

### 4. Testing Regex Patterns

```fish
@test "regex matches valid input" (
    string match -qr '^[0-9]+$' -- "12345"
) $status -eq 0

@test "regex rejects invalid input" (
    not string match -qr '^[0-9]+$' -- "abc"
) $status -eq 0
```

## Running Tests

### Run All Tests

```bash
# Using the custom run_tests function
run_tests

# Or manually
fishtape tests/*.test.fish
```

### Run Specific Test File

```bash
fishtape tests/killport.test.fish
```

### Run with Verbose Output

```bash
fishtape -v tests/killport.test.fish
```

## Test Performance

All tests should complete in under 1 second total:

```bash
time run_tests
```

Expected output:
```
Running Fish Function Tests...
==============================

Running: killport.test.fish
  PASSED

Running: nxg.test.fish
  PASSED

==============================
Test Summary:
  Total test files: 2
  All tests PASSED!

real    0m0.156s
```

## Mocking External Commands

For functions that rely on external commands (like `lsof`, `kill`), use mocking:

```fish
@test "handles no processes on port" (
    # Mock lsof to return empty
    function lsof
        echo ""
    end

    set -l output (killport 8080 2>&1)
    string match -q "*No active processes*" -- $output

    # Clean up mock
    functions -e lsof
) $status -eq 0
```

## Testing Interactive Functions

Functions with `read` prompts are challenging. Options:

1. **Test components separately**: Test validation logic without interaction
2. **Mock input**: Use `echo "input" | your_function` (limited support)
3. **Skip interactive parts**: Test everything except user interaction

Example:
```fish
# Instead of testing the full interactive flow
@test "validates port input correctly" (
    # Test just the validation regex
    string match -qr '^[0-9]+$' -- "8080"
) $status -eq 0
```

## Continuous Integration

Add tests to your CI/CD pipeline using the included GitHub Actions workflow:

```yaml
# .github/workflows/fish-tests.yml
name: Fish Function Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Fish
        run: sudo apt-get install -y fish
      - name: Install Fishtape
        run: fish -c "fisher install jorgebucaran/fishtape"
      - name: Run tests
        run: fish -c "run_tests"
```

## Best Practices

1. **One test file per function**: `killport.fish` → `killport.test.fish`
2. **Clear test names**: Describe what you're testing
3. **Fast execution**: Keep total test time under 1 second
4. **Independent tests**: Each test should run independently
5. **Test edge cases**: Empty input, invalid input, boundary conditions
6. **Clean up**: Remove any test artifacts (files, variables)
7. **Avoid side effects**: Don't modify system state permanently

## Troubleshooting

### Fishtape not found

```bash
fisher install jorgebucaran/fishtape
```

### Function not found in tests

Ensure functions are loaded:
```bash
source ~/.config/fish/functions/your_function.fish
```

### Tests hanging

- Check for infinite loops
- Verify no interactive prompts are blocking
- Use `timeout` command if needed

### Tests failing unexpectedly

```bash
# Run with verbose output
fishtape -v tests/your_test.test.fish

# Check function syntax
fish -n functions/your_function.fish

# Verify function loads
fish -c "type your_function"
```

## Example Test Files

See these files for examples:
- `tests/killport.test.fish` - Basic validation tests
- `tests/nxg.test.fish` - Argument handling tests
- `tests/example_advanced.test.fish` - Advanced patterns

## Resources

- [Fishtape Documentation](https://github.com/jorgebucaran/fishtape)
- [Fish Testing Guide](https://fishshell.com/docs/current/cmds/test.html)
- [TAP Protocol](https://testanything.org/)

## Quick Reference

```bash
# Install
fisher install jorgebucaran/fishtape

# Run all tests
run_tests

# Run specific test
fishtape tests/name.test.fish

# Verbose output
fishtape -v tests/name.test.fish

# Check if function exists
type -q function_name

# Get test coverage
fishtape tests/*.test.fish | grep -c "ok"
```

## Writing Your First Test

1. Create test file: `tests/your_function.test.fish`
2. Add shebang: `#!/usr/bin/env fish`
3. Write test:
```fish
@test "your_function: does something" (
    set -l output (your_function arg)
    string match -q "*expected*" -- $output
) $status -eq 0
```
4. Run test: `fishtape tests/your_function.test.fish`
5. Fix any failures
6. Add to `run_tests` by placing in tests/ directory

Done! Your function is now tested.
