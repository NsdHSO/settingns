# Advanced Error Handling Guide

## Overview

This error handling system provides consistent, helpful error messages with automatic recovery mechanisms and "did you mean?" suggestions. All errors use Phenomenon theme colors for visual consistency.

## Core Functions

### 1. `error_handler`

Central error handler with consistent formatting.

**Usage:**
```fish
error_handler <error_type> [details...]
```

**Error Types:**

- **missing_tool** - Tool not installed
  ```fish
  error_handler missing_tool bat cat  # Shows fallback
  error_handler missing_tool git      # No fallback
  ```

- **missing_arg** - Missing required argument
  ```fish
  error_handler missing_arg killport "<port>"
  ```

- **invalid_arg** - Invalid argument value
  ```fish
  error_handler invalid_arg "abc" "numeric port"
  ```

- **typo_suggestion** - Show "did you mean?" suggestions
  ```fish
  error_handler typo_suggestion "serv" service server
  ```

- **git_not_repo** - Not in a git repository
  ```fish
  error_handler git_not_repo
  ```

- **no_lockfile** - No package lockfile found
  ```fish
  error_handler no_lockfile
  ```

- **permission_denied** - Permission error
  ```fish
  error_handler permission_denied "/etc/file"
  ```

- **not_found** - Resource not found
  ```fish
  error_handler not_found "file" "config.json"
  ```

- **success_recovery** - Successful recovery
  ```fish
  error_handler success_recovery "Tool installed"
  ```

- **custom** - Custom error message
  ```fish
  error_handler custom "Database timeout"
  ```

### 2. `check_tool`

Verify tool availability with graceful fallbacks.

**Usage:**
```fish
check_tool <tool> [fallback] [auto]
```

**Examples:**
```fish
# Check with fallback
set viewer (check_tool bat cat)
if test $status -eq 0
    command $viewer file.txt
end

# Auto-install if missing
check_tool fzf "" auto
```

### 3. `suggest_command`

Provide "did you mean?" suggestions for typos.

**Usage:**
```fish
suggest_command <typed> <valid_command1> [valid_command2...]
```

**Example:**
```fish
suggest_command "comit" commit component
# Shows: Did you mean: commit
```

## Improved Functions

### Available Improved Versions

All improved functions include:
- Comprehensive error checking
- Helpful error messages
- Graceful fallbacks
- Input validation
- Permission checks
- Phenomenon color coding

**Functions:**
- `ylock_improved` - Enhanced package lock manager
- `gc_improved` - Enhanced git commit with typo detection
- `nxg_improved` - Enhanced Nx generator with validation
- `killport_improved` - Enhanced port killer with safety checks

### Using Improved Functions

**Option 1: Replace originals**
```fish
# Rename originals
mv ~/.config/fish/functions/ylock.fish ~/.config/fish/functions/ylock.old
mv ~/.config/fish/functions/ylock_improved.fish ~/.config/fish/functions/ylock.fish
```

**Option 2: Use aliases**
```fish
# In alias.fish
alias ylock=ylock_improved
alias gc=gc_improved
alias nxg=nxg_improved
alias killport=killport_improved
```

**Option 3: Test first**
```fish
# Try improved version
ylock_improved
# Keep both versions available
```

## Error Handling Patterns

### Pattern 1: Tool Validation
```fish
function my_function
    if not command -q required_tool
        error_handler missing_tool required_tool
        return 1
    end
    # ... rest of function
end
```

### Pattern 2: Argument Validation
```fish
function my_function
    if test (count $argv) -eq 0
        error_handler missing_arg my_function "<arg1> <arg2>"
        return 1
    end

    if not string match -qr '^[0-9]+$' -- $argv[1]
        error_handler invalid_arg $argv[1] "numeric value"
        return 1
    end
    # ... rest of function
end
```

### Pattern 3: File Existence
```fish
function my_function
    set -l file $argv[1]

    if not test -f "$file"
        error_handler not_found "file" "$file"
        return 1
    end
    # ... rest of function
end
```

### Pattern 4: Git Repository Check
```fish
function my_function
    if not git rev-parse --git-dir &>/dev/null
        error_handler git_not_repo
        return 1
    end
    # ... rest of function
end
```

### Pattern 5: Tool with Fallback
```fish
function my_function
    set -l viewer (check_tool bat cat)
    if test $status -ne 0
        return 1
    end

    command $viewer $argv
end
```

### Pattern 6: Permission Handling
```fish
function my_function
    if not mkdir -p $argv[1]
        error_handler permission_denied $argv[1]
        set_color $phenomenon_git_info
        echo "→ Try with elevated privileges"
        set_color normal
        return 1
    end
end
```

### Pattern 7: Typo Detection
```fish
function my_function
    set -l type $argv[1]
    set -l valid_types component service interface

    if not contains $type $valid_types
        suggest_command $type $valid_types
        return 1
    end
    # ... rest of function
end
```

## Color Reference

All error messages use Phenomenon theme colors:

- **Error** - `$phenomenon_error` (EF4444 - Red)
- **Warning** - `F59E0B` (Amber)
- **Info** - `$phenomenon_git_info` (3B82F6 - Blue)
- **Success** - `$phenomenon_success` (22C55E - Green)
- **Symbols** - `$phenomenon_symbols` (F43F5E - Pink/Red)
- **Time/Cyan** - `$phenomenon_time` (14B8A6 - Teal)
- **Directory** - `$phenomenon_directory` (BF409D - Magenta)

## Examples

Run the examples function to see all patterns in action:
```fish
error_examples
```

Or try the demonstration functions:
```fish
# Smart file viewer with fallback
smart_view file.txt

# Safe directory creation
safe_mkdir my-project

# Git-aware command
git_safe_command
```

## Best Practices

### Do:
- ✓ Use `error_handler` for all error messages
- ✓ Provide helpful suggestions after errors
- ✓ Check for required tools before using them
- ✓ Validate user input early
- ✓ Use Phenomenon colors consistently
- ✓ Return appropriate exit codes (0=success, 1=error)

### Don't:
- ✗ Suppress real errors
- ✗ Use generic error messages
- ✗ Assume tools are installed
- ✗ Skip input validation
- ✗ Mix color schemes
- ✗ Create verbose error messages

## Testing

Test error handling with invalid inputs:

```fish
# Missing arguments
gc_improved

# Invalid argument types
killport_improved abc

# Typos
gc_improved servise "message"

# Missing tools
# (temporarily rename a tool to test)

# Permission errors
# (try operations in protected directories)
```

## Integration

To add error handling to existing functions:

1. Source the error handler functions first
2. Replace manual error messages with `error_handler`
3. Add tool checks with `check_tool`
4. Add typo detection with `suggest_command`
5. Use Phenomenon colors for all output

Example transformation:
```fish
# Before
function my_func
    if test (count $argv) -eq 0
        echo "Error: Missing argument"
        return 1
    end
end

# After
function my_func
    if test (count $argv) -eq 0
        error_handler missing_arg my_func "<required_arg>"
        return 1
    end
end
```

## Troubleshooting

**Problem:** Error handler colors not showing
**Solution:** Ensure config.fish sets Phenomenon color variables

**Problem:** check_tool always fails
**Solution:** Verify the tool name matches the command name

**Problem:** Suggestions not appearing
**Solution:** Ensure suggest_command is sourced before use

**Problem:** Auto-install not working
**Solution:** Verify Homebrew is installed: `command -q brew`
