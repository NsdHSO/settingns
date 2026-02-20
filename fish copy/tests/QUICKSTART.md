# Testing Quick Start

Get started with Fish function testing in 5 minutes.

## Step 1: Install Fishtape (30 seconds)

```bash
fisher install jorgebucaran/fishtape
```

Or use the setup script:
```bash
fish setup_tests.fish
```

## Step 2: Verify Installation (5 seconds)

```bash
fishtape --version
```

Expected output: `fishtape, version X.X.X`

## Step 3: Run Tests (10 seconds)

```bash
run_tests
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
```

## Step 4: Write Your First Test (2 minutes)

Create `tests/my_function.test.fish`:

```fish
#!/usr/bin/env fish

@test "my_function: does something useful" (
    set -l output (my_function test_arg)
    string match -q "*expected*" -- $output
) $status -eq 0
```

Run it:
```bash
fishtape tests/my_function.test.fish
```

## That's It!

You now have a working test framework. See `TESTING.md` for more details.

## Common Commands

```bash
# Run all tests
run_tests

# Run specific test
fishtape tests/killport.test.fish

# Verbose output
fishtape -v tests/killport.test.fish

# Time tests
time run_tests
```

## Test Template

Copy and customize:

```fish
#!/usr/bin/env fish

# Test suite for FUNCTION_NAME
# Run with: fishtape tests/FUNCTION_NAME.test.fish

@test "FUNCTION_NAME: shows usage without args" (
    set -l output (FUNCTION_NAME 2>&1)
    string match -q "*Usage:*" -- $output
) $status -eq 1

@test "FUNCTION_NAME: accepts valid input" (
    set -l output (FUNCTION_NAME valid_arg)
    test -n "$output"
) $status -eq 0

@test "FUNCTION_NAME: rejects invalid input" (
    set -l output (FUNCTION_NAME "" 2>&1)
    string match -q "*error*" -- $output
) $status -eq 1
```

## Next Steps

1. Read `tests/README.md` for detailed testing guide
2. Check `tests/example_advanced.test.fish` for advanced patterns
3. Read `TESTING.md` for best practices
4. Add tests to CI/CD with `.github/workflows/fish-tests.yml`

## Getting Help

- Test not working? Run with `-v` flag
- Function not found? Check it's in `functions/` directory
- Fishtape missing? Run `fisher install jorgebucaran/fishtape`
