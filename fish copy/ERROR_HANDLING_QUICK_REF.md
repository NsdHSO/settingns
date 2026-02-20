# Error Handling Quick Reference

## Quick Start

```fish
# Source in your function
source ~/.config/fish/functions/error_handler.fish

# Use error handler
error_handler missing_arg my_func "<required_arg>"

# Check tools with fallback
set viewer (check_tool bat cat)

# Suggest correct commands
suggest_command "typo" valid1 valid2 valid3
```

---

## Error Handler Cheat Sheet

### Syntax
```fish
error_handler <type> [details...]
```

### Error Types

| Type | Usage | Example |
|------|-------|---------|
| `missing_tool` | Tool not found | `error_handler missing_tool bat cat` |
| `missing_arg` | Missing argument | `error_handler missing_arg func "<arg>"` |
| `invalid_arg` | Invalid argument | `error_handler invalid_arg "x" "number"` |
| `typo_suggestion` | Show suggestions | `error_handler typo_suggestion "typ" cmd1 cmd2` |
| `git_not_repo` | Not git repo | `error_handler git_not_repo` |
| `no_lockfile` | No lockfile | `error_handler no_lockfile` |
| `permission_denied` | Permission error | `error_handler permission_denied "/file"` |
| `not_found` | Resource missing | `error_handler not_found "file" "x.txt"` |
| `success_recovery` | Success message | `error_handler success_recovery "Done!"` |
| `custom` | Custom error | `error_handler custom "Error message"` |

---

## Common Patterns

### Pattern 1: Validate Arguments
```fish
if test (count $argv) -eq 0
    error_handler missing_arg my_func "<arg>"
    return 1
end
```

### Pattern 2: Check Tool
```fish
if not command -q git
    error_handler missing_tool git
    return 1
end
```

### Pattern 3: Tool with Fallback
```fish
set viewer (check_tool bat cat)
if test $status -ne 0
    return 1
end
command $viewer $file
```

### Pattern 4: Validate Input
```fish
if not string match -qr '^[0-9]+$' -- $port
    error_handler invalid_arg $port "numeric port"
    return 1
end
```

### Pattern 5: Check File
```fish
if not test -f "$file"
    error_handler not_found "file" "$file"
    return 1
end
```

### Pattern 6: Git Check
```fish
if not git rev-parse --git-dir &>/dev/null
    error_handler git_not_repo
    return 1
end
```

### Pattern 7: Typo Detection
```fish
set valid_types feat fix docs chore
if not contains $type $valid_types
    suggest_command $type $valid_types
    return 1
end
```

### Pattern 8: Permission Check
```fish
if not mkdir -p $dir
    error_handler permission_denied $dir
    return 1
end
```

---

## Color Variables

```fish
$phenomenon_error      # EF4444 - Red
$phenomenon_success    # 22C55E - Green
$phenomenon_git_info   # 3B82F6 - Blue
$phenomenon_symbols    # F43F5E - Pink
$phenomenon_time       # 14B8A6 - Teal
$phenomenon_directory  # BF409D - Magenta
```

---

## Function Templates

### Basic Function
```fish
function my_func
    # Check arguments
    if test (count $argv) -eq 0
        error_handler missing_arg my_func "<arg>"
        return 1
    end

    # Validate input
    if not string match -qr '^pattern$' -- $argv[1]
        error_handler invalid_arg $argv[1] "description"
        return 1
    end

    # Your logic here

    return 0
end
```

### Tool-Dependent Function
```fish
function my_func
    # Check tool
    if not command -q tool
        error_handler missing_tool tool
        return 1
    end

    # Your logic here

    return 0
end
```

### Tool with Fallback
```fish
function my_func
    set viewer (check_tool preferred fallback)
    if test $status -ne 0
        return 1
    end

    command $viewer $argv
    return $status
end
```

### Git-Aware Function
```fish
function my_func
    # Check git repo
    if not git rev-parse --git-dir &>/dev/null
        error_handler git_not_repo
        return 1
    end

    # Your git logic here

    return 0
end
```

---

## Testing Commands

```fish
# Run all examples
error_examples

# Test improved functions
ylock_improved
gc_improved feat "test"
nxg_improved component test
killport_improved 3000

# Test helper functions
smart_view file.txt
safe_mkdir my-dir
git_safe_command
```

---

## Dos and Don'ts

### Do
- ✓ Use error_handler for all errors
- ✓ Validate inputs early
- ✓ Check tools before using
- ✓ Provide helpful suggestions
- ✓ Use Phenomenon colors
- ✓ Return proper exit codes

### Don't
- ✗ Suppress real errors
- ✗ Use echo for errors
- ✗ Skip validation
- ✗ Assume tools exist
- ✗ Mix color schemes
- ✗ Make verbose messages

---

## Exit Codes

```fish
return 0  # Success
return 1  # Error/Failure
```

Always return appropriate codes for error handling.

---

## Integration Steps

1. Source error handlers first in `all_functions.fish`
2. Replace `echo` errors with `error_handler`
3. Add tool checks with `check_tool`
4. Add input validation
5. Use Phenomenon colors
6. Test with invalid inputs

---

## Auto-Install

```fish
# Enable auto-install
check_tool fzf "" auto

# Manual install suggestion (default)
check_tool fzf
```

---

## Quick Diagnostic

```fish
# Test error handler loaded
type error_handler

# Test colors set
echo $phenomenon_error

# Test tool checker
check_tool nonexistent_tool

# List all error functions
ls ~/.config/fish/functions/error*.fish
ls ~/.config/fish/functions/*improved.fish
```
