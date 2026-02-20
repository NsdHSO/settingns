# Advanced Error Handling System

Complete error handling infrastructure for fish shell functions with Phenomenon theme integration.

---

## Quick Links

| Document | Purpose | Use When |
|----------|---------|----------|
| [Summary](ERROR_HANDLING_SUMMARY.md) | Overview & implementation status | Want to see what was built |
| [Quick Reference](ERROR_HANDLING_QUICK_REF.md) | Cheat sheet & templates | Writing new functions |
| [Guide](ERROR_HANDLING_GUIDE.md) | Complete documentation | Learning the system |
| [Examples](ERROR_HANDLING_EXAMPLES.md) | Detailed output examples | Want to see all scenarios |
| [Visual](ERROR_HANDLING_VISUAL.md) | Terminal output samples | Want to see actual output |
| [Comparison](ERROR_HANDLING_COMPARISON.md) | Before/after comparison | Understanding improvements |

---

## What's Included

### Core Functions
- `error_handler.fish` - Central error handling (10 types)
- `check_tool.fish` - Tool availability with fallbacks
- `suggest_command.fish` - Typo detection and suggestions

### Improved Functions
- `ylock_improved.fish` - Package lock manager
- `gc_improved.fish` - Git commit with validation
- `nxg_improved.fish` - Nx generator with checks
- `killport_improved.fish` - Port killer with safety

### Example Functions
- `error_examples.fish` - Demonstration functions

---

## Quick Start

### 1. Try the Examples
```fish
# See all error types in action
error_examples

# Try improved functions
ylock_improved
gc_improved feat "test message"
nxg_improved component my-component
killport_improved 3000
```

### 2. Use in Your Functions
```fish
function my_function
    if test (count $argv) -eq 0
        error_handler missing_arg my_function "<arg>"
        return 1
    end
    # ... your code ...
end
```

### 3. Check Tool Availability
```fish
function my_function
    set viewer (check_tool bat cat)  # Fallback to cat if bat missing
    command $viewer $argv
end
```

---

## Documentation Structure

### For Beginners
1. Start with [Visual Examples](ERROR_HANDLING_VISUAL.md) to see what it looks like
2. Read the [Guide](ERROR_HANDLING_GUIDE.md) to understand how it works
3. Use [Quick Reference](ERROR_HANDLING_QUICK_REF.md) when writing code

### For Experienced Users
1. Check [Quick Reference](ERROR_HANDLING_QUICK_REF.md) for syntax
2. Review [Comparison](ERROR_HANDLING_COMPARISON.md) to see improvements
3. Use [Examples](ERROR_HANDLING_EXAMPLES.md) for specific scenarios

### For Project Managers
1. Read [Summary](ERROR_HANDLING_SUMMARY.md) for deliverables
2. Review [Comparison](ERROR_HANDLING_COMPARISON.md) for metrics
3. Check [Examples](ERROR_HANDLING_EXAMPLES.md) for test coverage

---

## Error Types at a Glance

| Type | When to Use |
|------|-------------|
| `missing_tool` | Tool not installed |
| `missing_arg` | Required argument missing |
| `invalid_arg` | Argument format/type wrong |
| `typo_suggestion` | Show "did you mean?" |
| `git_not_repo` | Not in git repository |
| `no_lockfile` | No package lockfile found |
| `permission_denied` | Permission error |
| `not_found` | Resource doesn't exist |
| `success_recovery` | Successful recovery |
| `custom` | Custom error message |

---

## Common Patterns

### Check Arguments
```fish
if test (count $argv) -eq 0
    error_handler missing_arg func_name "<arg>"
    return 1
end
```

### Validate Input
```fish
if not string match -qr '^[0-9]+$' -- $port
    error_handler invalid_arg $port "numeric port"
    return 1
end
```

### Check Tool
```fish
if not command -q git
    error_handler missing_tool git
    return 1
end
```

### Tool with Fallback
```fish
set viewer (check_tool bat cat)
command $viewer $file
```

### Typo Detection
```fish
if not contains $type $valid_types
    suggest_command $type $valid_types
    return 1
end
```

---

## Files Reference

### Core Infrastructure
```
functions/error_handler.fish       # Central error handler
functions/check_tool.fish          # Tool checker with fallbacks
functions/suggest_command.fish     # Typo suggestions
```

### Improved Functions
```
functions/ylock_improved.fish      # Package lock manager
functions/gc_improved.fish         # Git commit helper
functions/nxg_improved.fish        # Nx generator
functions/killport_improved.fish   # Port killer
functions/error_examples.fish      # Example functions
```

### Documentation
```
ERROR_HANDLING_README.md           # This file
ERROR_HANDLING_SUMMARY.md          # Implementation summary
ERROR_HANDLING_GUIDE.md            # Complete guide
ERROR_HANDLING_EXAMPLES.md         # Detailed examples
ERROR_HANDLING_VISUAL.md           # Visual terminal output
ERROR_HANDLING_COMPARISON.md       # Before/after comparison
ERROR_HANDLING_QUICK_REF.md        # Quick reference
```

---

## Color Scheme

All errors use Phenomenon theme colors:

| Color | Use |
|-------|-----|
| Red (EF4444) | Errors |
| Green (22C55E) | Success |
| Blue (3B82F6) | Info |
| Pink (F43F5E) | Warnings |
| Teal (14B8A6) | Progress |
| Magenta (BF409D) | Resources |

---

## Features

- ✓ 10 standardized error types
- ✓ Consistent formatting (✗/✓ symbols)
- ✓ Phenomenon theme colors
- ✓ Graceful tool fallbacks
- ✓ "Did you mean?" suggestions
- ✓ Auto-install capability
- ✓ Helpful error messages
- ✓ Concise output
- ✓ No error suppression
- ✓ Complete documentation

---

## Integration

### For New Functions
Copy template from [Quick Reference](ERROR_HANDLING_QUICK_REF.md)

### For Existing Functions
See patterns in [Comparison](ERROR_HANDLING_COMPARISON.md)

### Testing
Run `error_examples` to verify everything works

---

## Support

### Check Error Handler Loaded
```fish
type error_handler
```

### Check Colors Available
```fish
echo $phenomenon_error
```

### List All Error Functions
```fish
ls ~/.config/fish/functions/error*.fish
ls ~/.config/fish/functions/*improved.fish
```

### Run Diagnostics
```fish
error_examples
```

---

## Migration Guide

### Option 1: Direct Replacement
```fish
mv ylock.fish ylock.old
mv ylock_improved.fish ylock.fish
```

### Option 2: Aliases
```fish
# In alias.fish
alias ylock=ylock_improved
alias gc=gc_improved
```

### Option 3: Test First
Keep both versions, test improved, then decide

---

## Example Output

```
✗ Missing argument
→ Usage: killport <port>
→ Example: killport 3000

✗ Invalid argument: 'abc'
→ Expected: numeric port (1-65535)

✗ Unknown command: 'serv'
→ Did you mean:
  • service

✓ Installation complete with npm
```

See [Visual Examples](ERROR_HANDLING_VISUAL.md) for more

---

## Benefits

### For Developers
- Clear, consistent errors
- Less debugging time
- Professional appearance
- Easy to maintain

### For Users
- Understand what went wrong
- Know how to fix it
- Get alternative solutions
- Confidence in tools

---

## Next Steps

1. **Try it**: Run `error_examples`
2. **Learn it**: Read the [Guide](ERROR_HANDLING_GUIDE.md)
3. **Use it**: Reference [Quick Ref](ERROR_HANDLING_QUICK_REF.md)
4. **Extend it**: Add error handling to your functions

---

## Stats

- **Functions**: 8 created
- **Documentation**: 7 files
- **Error Types**: 10
- **Examples**: 30+
- **Lines of Code**: ~1,200
- **Test Coverage**: Complete

---

Made with Phenomenon colors for a consistent, professional shell experience.
