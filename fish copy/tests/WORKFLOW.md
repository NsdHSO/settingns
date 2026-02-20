# Testing Workflow

Visual guide to the Fish function testing workflow.

## Installation Flow

```
START
  │
  ├─→ Install Fish Shell
  │     │
  │     ✓
  │
  ├─→ Run INSTALL_TESTING.sh
  │     │
  │     ├─→ Check Fish exists ✓
  │     ├─→ Install Fisher
  │     ├─→ Install Fishtape
  │     └─→ Verify installation ✓
  │
  ├─→ Reload Fish config
  │     exec fish
  │
  └─→ READY TO TEST
```

## Test Execution Flow

```
run_tests
  │
  ├─→ Check fishtape installed ✓
  ├─→ Check tests/ directory exists ✓
  ├─→ Find all *.test.fish files
  │
  ├─→ For each test file:
  │     │
  │     ├─→ Run fishtape <file>
  │     ├─→ Capture output
  │     ├─→ Check exit code
  │     │     ├─→ 0 = PASS ✓
  │     │     └─→ ≠ 0 = FAIL ✗
  │     │
  │     └─→ Update counters
  │
  └─→ Show summary
        │
        ├─→ All passed? → Exit 0 ✓
        └─→ Any failed? → Exit 1 ✗
```

## Writing a Test Flow

```
1. Create test file
   tests/my_function.test.fish
   │
   ├─→ Copy TEMPLATE.test.fish
   │   or start from scratch
   │
   └─→ Add shebang
       #!/usr/bin/env fish

2. Write tests
   │
   ├─→ @test "description" (
   │     # Test code
   │   ) $expected_status
   │
   ├─→ Use helpers (optional)
   │     source test_helpers.fish
   │     assert_equals, mock_command, etc.
   │
   └─→ Add multiple test cases

3. Run test
   │
   ├─→ fishtape tests/my_function.test.fish
   │
   └─→ Check results
       │
       ├─→ All pass? ✓ Done
       │
       └─→ Failures? ✗ Fix and re-run
```

## Test Anatomy

```
@test "function_name: what it tests" (
  │
  ├─→ ARRANGE
  │     Set up test data
  │     set -l input "test"
  │
  ├─→ ACT
  │     Execute function
  │     set -l output (my_function $input)
  │
  ├─→ ASSERT
  │     Check results
  │     string match -q "*expected*" -- $output
  │
  └─→ Return status
) $status -eq 0
```

## Mocking Flow

```
Test needs external command
  │
  ├─→ Create mock
  │     function lsof
  │       echo "mocked output"
  │     end
  │
  ├─→ Run test
  │     set -l result (my_function)
  │
  ├─→ Verify results
  │     test "$result" = "expected"
  │
  └─→ Clean up mock
        functions -e lsof
```

## CI/CD Flow

```
Git Push/Pull Request
  │
  ├─→ GitHub Actions triggered
  │
  ├─→ Setup environment
  │     ├─→ Install Fish
  │     ├─→ Install Fisher
  │     └─→ Install Fishtape
  │
  ├─→ Copy test files
  │     ├─→ functions/
  │     └─→ tests/
  │
  ├─→ Run tests
  │     fish -c "run_tests"
  │
  └─→ Report results
        │
        ├─→ All pass? ✓ Merge allowed
        └─→ Any fail? ✗ Block merge
```

## Test Helper Usage

```
Need to test complex scenario
  │
  ├─→ Load helpers
  │     source test_helpers.fish
  │
  ├─→ Choose helper
  │     │
  │     ├─→ mock_command        (mock external)
  │     ├─→ assert_equals       (check equality)
  │     ├─→ assert_contains     (substring)
  │     ├─→ create_temp_file    (temp file)
  │     ├─→ setup_test_env      (isolated env)
  │     └─→ etc.
  │
  ├─→ Use in test
  │     @test "..." (
  │       setup_test_env
  │       # test code
  │       teardown_test_env
  │     ) $status -eq 0
  │
  └─→ Cleanup automatically
```

## Debugging Failed Tests

```
Test fails ✗
  │
  ├─→ Run with verbose
  │     fishtape -v tests/my_test.test.fish
  │
  ├─→ Check output
  │     │
  │     ├─→ Syntax error?
  │     │     Fix and re-run
  │     │
  │     ├─→ Wrong assertion?
  │     │     Update test
  │     │
  │     ├─→ Function issue?
  │     │     Fix function
  │     │
  │     └─→ Missing dependency?
  │           Install or mock
  │
  └─→ Re-run until pass ✓
```

## Directory Organization

```
~/.config/fish/
  │
  ├── functions/              (Actual functions)
  │   ├── killport.fish
  │   ├── nxg.fish
  │   └── run_tests.fish     (Test runner)
  │
  ├── tests/                 (Test files)
  │   ├── test_helpers.fish  (Utilities)
  │   ├── killport.test.fish (Tests)
  │   ├── nxg.test.fish
  │   └── TEMPLATE.test.fish
  │
  └── Documentation
      ├── TESTING.md
      ├── QUICKSTART.md
      └── README.md
```

## Complete Workflow Example

```
1. Create new function
   └─→ functions/my_func.fish

2. Create test file
   └─→ tests/my_func.test.fish

3. Write tests
   @test "my_func: basic test" (...)

4. Run test
   fishtape tests/my_func.test.fish

5. Fix issues if needed
   │
   ├─→ Update function
   ├─→ Update test
   └─→ Re-run

6. Add to suite
   └─→ Automatically included in run_tests

7. Run all tests
   run_tests

8. Commit changes
   git add functions/my_func.fish tests/my_func.test.fish
   git commit -m "Add my_func with tests"

9. Push (CI runs tests)
   git push
   └─→ GitHub Actions
       └─→ Tests run automatically ✓
```

## Quick Command Reference

```
┌─────────────────────────────────────────────────┐
│ COMMAND                 │ PURPOSE               │
├─────────────────────────────────────────────────┤
│ run_tests               │ Run all tests         │
│ fishtape FILE           │ Run specific test     │
│ fishtape -v FILE        │ Verbose output        │
│ time run_tests          │ Measure performance   │
│ fish setup_tests.fish   │ Setup & verify        │
│ bash INSTALL_TESTING.sh │ Full installation     │
└─────────────────────────────────────────────────┘
```

## Status Codes

```
Exit Code │ Meaning
──────────┼─────────────────────────
    0     │ All tests passed ✓
    1     │ Some tests failed ✗
    1     │ Setup/config error ✗
```

## Test Lifecycle

```
Test Start
    │
    ├─→ Source function
    ├─→ Setup (if needed)
    ├─→ Execute test
    ├─→ Check assertion
    ├─→ Teardown (if needed)
    │
    └─→ Report result
          ├─→ ok N - Test passed ✓
          └─→ not ok N - Test failed ✗
```
