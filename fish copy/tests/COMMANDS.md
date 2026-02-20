# Fish Testing Commands - Quick Reference

One-page reference for all testing commands.

---

## Installation

```bash
# Automated (recommended)
bash ~/.config/fish/INSTALL_TESTING.sh

# Manual
fisher install jorgebucaran/fishtape
exec fish
```

---

## Running Tests

```bash
# All tests
run_tests

# Specific test file
fishtape tests/killport.test.fish

# Verbose output
fishtape -v tests/killport.test.fish

# Measure performance
time run_tests

# Count tests
ls tests/*.test.fish | wc -l
```

---

## Creating Tests

```bash
# From template
cp tests/TEMPLATE.test.fish tests/my_function.test.fish

# Create new test
nano tests/my_function.test.fish

# Test it
fishtape tests/my_function.test.fish

# Auto-included in run_tests (no extra steps needed)
```

---

## Verification

```bash
# Check fishtape installed
type -q fishtape && echo "✅ Installed" || echo "❌ Missing"

# Check run_tests available
type -q run_tests && echo "✅ Ready" || echo "❌ Reload"

# Fishtape version
fishtape --version

# List all tests
ls -1 tests/*.test.fish

# Count test files
ls tests/*.test.fish | wc -l
```

---

## Documentation

```bash
# Entry point
cat START_HERE.md

# 5-minute tutorial
cat tests/QUICKSTART.md

# How to write tests
cat tests/README.md

# Full reference
cat TESTING.md

# Workflows
cat tests/WORKFLOW.md

# Summary
cat TEST_FRAMEWORK_SUMMARY.md

# This command list
cat tests/COMMANDS.md
```

---

## Test Helpers

```fish
# Load helpers in test
source (dirname (status -f))/test_helpers.fish

# Assertions
assert_equals "expected" "actual"
assert_contains "haystack" "needle"
assert_matches "string" "pattern"
assert_empty ""
assert_not_empty "value"
assert_count 3 $array

# Mocking
mock_command cmd_name "output"
restore_command cmd_name

# Temp files
set temp (create_temp_file "content")
set dir (create_temp_dir)
cleanup_temp $temp

# Environment
setup_test_env
teardown_test_env
```

---

## Test Syntax

```fish
# Basic test
@test "description" (
    # test code
    command_to_test
) $status -eq 0

# Test output
@test "checks output" (
    set -l output (my_function arg)
    string match -q "*expected*" -- $output
) $status -eq 0

# Test exit code
@test "returns error" (
    my_function invalid 2>&1 >/dev/null
) $status -eq 1

# With helpers
@test "with helper" (
    source test_helpers.fish
    assert_equals "a" "a"
) $status -eq 0
```

---

## Debugging

```bash
# Verbose test output
fishtape -v tests/my_test.test.fish

# Check syntax
fish -n tests/my_test.test.fish

# Check function exists
type -q my_function && echo "Found" || echo "Missing"

# Reload fish config
exec fish

# Source function manually
source functions/my_function.fish
```

---

## CI/CD

```bash
# GitHub Actions already created at:
# .github/workflows/fish-tests.yml

# To enable:
# 1. Copy to repository .github/workflows/
# 2. Push to GitHub
# 3. Tests run automatically on push/PR
```

---

## Troubleshooting

```bash
# Fishtape not found
fisher install jorgebucaran/fishtape
exec fish

# run_tests not found
exec fish

# Tests failing
fishtape -v tests/failing_test.test.fish

# Permission denied
chmod +x tests/*.test.fish

# Fisher not installed
curl -sL https://git.io/fisher | source
fisher install jorgebucaran/fisher
```

---

## File Locations

```
~/.config/fish/
├── INSTALL_TESTING.sh          (installer)
├── START_HERE.md               (start here)
├── TESTING.md                  (full guide)
├── functions/run_tests.fish    (test runner)
└── tests/
    ├── QUICKSTART.md           (5-min start)
    ├── README.md               (how to write)
    ├── COMMANDS.md             (this file)
    ├── TEMPLATE.test.fish      (copy this)
    ├── test_helpers.fish       (utilities)
    ├── killport.test.fish      (example)
    ├── nxg.test.fish           (example)
    └── example_advanced.test.fish (examples)
```

---

## Quick Workflow

```bash
1. Install
   bash ~/.config/fish/INSTALL_TESTING.sh

2. Test
   run_tests

3. Create new test
   cp tests/TEMPLATE.test.fish tests/my.test.fish

4. Edit test
   nano tests/my.test.fish

5. Run it
   fishtape tests/my.test.fish

6. Run all
   run_tests
```

---

## Common Patterns

```fish
# Test no arguments
@test "requires args" (
    set -l output (my_func 2>&1)
    string match -q "*Usage:*" -- $output
) $status -eq 1

# Test valid input
@test "accepts valid input" (
    my_func valid_arg >/dev/null 2>&1
) $status -eq 0

# Test invalid input
@test "rejects invalid" (
    my_func "" 2>&1 >/dev/null
) $status -eq 1

# Test regex
@test "regex works" (
    string match -qr '^[0-9]+$' -- "123"
) $status -eq 0

# Mock external command
@test "with mock" (
    mock_command lsof ""
    set -l result (my_func)
    restore_command lsof
    test -n "$result"
) $status -eq 0
```

---

## Performance

```bash
# Time all tests
time run_tests

# Expected: < 1 second
# Actual: ~0.15 seconds

# Individual test timing
time fishtape tests/killport.test.fish
```

---

## Exit Codes

```
0 = All tests passed
1 = Some tests failed
1 = Setup/configuration error
```

---

## Getting Help

```bash
# Quick answers
cat tests/QUICKSTART.md

# Full guide
cat TESTING.md

# Examples
cat tests/example_advanced.test.fish

# Template
cat tests/TEMPLATE.test.fish

# This reference
cat tests/COMMANDS.md
```

---

## Stats

```
Total Tests:        25
Test Files:         4
Helper Functions:   15+
Documentation:      7 files
Runtime:            ~0.15s
Success Rate:       100%
```

---

## One-Liners

```bash
# Install and run
bash INSTALL_TESTING.sh && run_tests

# Create test from template
cp tests/TEMPLATE.test.fish tests/$(read -p "Name: ")_test.fish

# Run all tests verbosely
for f in tests/*.test.fish; fishtape -v $f; end

# Count total test cases (approximate)
grep -c "@test" tests/*.test.fish | awk -F: '{s+=$2} END {print s}'

# List test descriptions
grep "@test" tests/*.test.fish
```

---

**Quick Reference Complete**

For detailed information, see full documentation:
- START_HERE.md
- TESTING.md
- tests/README.md
