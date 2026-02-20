# Visual Error Handling Examples

This document shows what users actually see when using the improved error handling system.

---

## Terminal Output Examples

### Example 1: Missing Argument

```
$ killport_improved

✗ Missing argument
→ Usage: killport <port>
→ Example: killport 3000
```

---

### Example 2: Invalid Input Type

```
$ killport_improved abc

✗ Invalid argument: 'abc'
→ Expected: numeric port (1-65535)
```

---

### Example 3: Out of Range

```
$ killport_improved 99999

✗ Invalid argument: '99999'
→ Expected: port number between 1 and 65535
```

---

### Example 4: Tool Not Found with Fallback

```
$ smart_view README.md

✗ Error: 'bat' is not installed
→ Using fallback: cat

# README.md
This is the readme content...
```

---

### Example 5: Typo Detection

```
$ gc_improved servise "add new service"

✗ Unknown command: 'servise'
→ Did you mean:
  • service
```

---

### Example 6: Multiple Suggestions

```
$ gc_improved fet "new feature"

✗ Unknown command: 'fet'
→ Did you mean:
  • feat
  • test
```

---

### Example 7: Not in Git Repo

```
$ gc_improved feat "test"

✗ Not a git repository
→ Initialize with: git init
```

---

### Example 8: No Changes to Commit

```
$ gc_improved feat "test"

✗ No changes to commit
→ Working tree is clean
```

---

### Example 9: Successful Commit

```
$ gc_improved feat "add user authentication"

→ Committing changes...
✓ Commit successful!
→ feat: 🎸 add user authentication
```

---

### Example 10: Not in Nx Workspace

```
$ nxg_improved component test

✗ file not found: nx.json
→ This doesn't appear to be an Nx workspace
→ Create one with: npx create-nx-workspace
```

---

### Example 11: Invalid Component Name

```
$ nxg_improved component "my component"

✗ Invalid argument: 'my component'
→ Expected: valid identifier (letters, numbers, hyphens, underscores)
```

---

### Example 12: Component Already Exists

```
$ nxg_improved component auth-form

✗ Directory 'auth-form' already exists
→ Choose a different name or remove the existing directory
```

---

### Example 13: Successful Component Generation

```
$ nxg_improved component auth-form

→ Generating component: auth-form
→ Directory created: auth-form
✓ Component 'auth-form' created successfully
```

---

### Example 14: No Lockfile Found

```
$ ylock_improved

✗ No package lockfile found
→ Create one with: npm install, yarn install, or pnpm install
→ Available package managers:
  • pnpm (not installed)
  • yarn (installed)
  • npm (installed)
```

---

### Example 15: Not a Node.js Project

```
$ ylock_improved

✗ file not found: package.json
→ This doesn't appear to be a Node.js project
```

---

### Example 16: Successful Lock Removal

```
$ ylock_improved

→ Found yarn.lock
→ Removing yarn.lock...
→ Installing with yarn...
✓ Installation complete with yarn
```

---

### Example 17: Manager Not Installed

```
$ ylock_improved

→ Found pnpm-lock.yaml
✗ Error: 'pnpm' is not installed
→ Using fallback: npm
→ Removing pnpm-lock.yaml...
→ Installing with npm...
✓ Installation complete with npm
```

---

### Example 18: Port Kill Success

```
$ killport_improved 3000

→ Processes on port 3000:
1) PID 12345 [node] (user: david)
2) PID 12346 [npm] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): 1 2
→ Terminating PID 12345...
✓ PID 12345 terminated successfully
→ Terminating PID 12346...
✓ PID 12346 terminated successfully
✓ Killed 2 process(es)
```

---

### Example 19: Port Kill with Permission Error

```
$ killport_improved 80

→ Processes on port 80:
1) PID 443 [httpd] (user: root)
→ Enter numbers to kill (space-separated, 0 to abort): 1
→ PID 443 requires elevated privileges
→ Terminating PID 443...
✗ Permission denied: PID 443
→ Try with sudo: sudo fish -c 'killport 80'
```

---

### Example 20: Port Kill Cancelled

```
$ killport_improved 3000

→ Processes on port 3000:
1) PID 12345 [node] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): 0
→ Operation cancelled
```

---

### Example 21: No Processes on Port

```
$ killport_improved 9999

→ Port 9999: No active processes
```

---

### Example 22: Invalid Selection

```
$ killport_improved 3000

→ Processes on port 3000:
1) PID 12345 [node] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): abc
✗ Invalid argument: 'abc'
→ Expected: numeric selection

→ Enter numbers to kill (space-separated, 0 to abort): 5
✗ Invalid argument: '5'
→ Expected: valid selection (1-1)
```

---

### Example 23: Auto-Install Tool

```
$ check_tool fzf "" auto

→ Installing fzf via Homebrew...
✓ fzf installed successfully
```

---

### Example 24: Safe Directory Creation

```
$ safe_mkdir my-project

✓ Directory 'my-project' created
```

---

### Example 25: Directory Exists

```
$ safe_mkdir my-project

✗ Directory 'my-project' already exists
→ Use a different name or remove the existing directory
```

---

### Example 26: Git Safe Command on Main Branch

```
$ git_safe_command

⚠ Warning: Operating on protected branch 'main'
→ Continue? [y/N] n
→ Operation cancelled
```

---

### Example 27: Git Safe Command on Feature Branch

```
$ git_safe_command

✓ Safe to proceed on branch 'feature/auth'
```

---

### Example 28: Detached HEAD State

```
$ git_safe_command

✗ Detached HEAD state
→ Checkout a branch first: git checkout <branch>
```

---

### Example 29: All Error Types Demo

```
$ error_examples

=== Advanced Error Handling Examples ===

1. Tool Check with Fallback (bat → cat)
✗ Error: 'bat' is not installed
→ Using fallback: cat
Using viewer: cat

2. Missing Argument Error
✗ Missing argument
→ Usage: my_function <required_arg> [optional_arg]

3. Invalid Argument Type
✗ Invalid argument: 'abc123'
→ Expected: numeric port number

4. Command Typo Suggestions
✗ Unknown command: 'serv'
→ Did you mean:
  • service
  • server

5. Git Repository Validation
✗ Not a git repository
→ Initialize with: git init

6. Package Lockfile Missing
✗ No package lockfile found
→ Create one with: npm install, yarn install, or pnpm install

7. Permission Denied
✗ Permission denied: /etc/system_file
→ Try with sudo or check file permissions

8. Resource Not Found
✗ configuration file not found: .env

9. Successful Recovery
✓ Tool installed and configured successfully

10. Custom Error
✗ Database connection timeout after 30 seconds

=== Examples Complete ===
```

---

### Example 30: Help Text Improvements

**Before (old gc):**
```
$ gc

❌ Usage: gc <type> <message>
```

**After (gc_improved):**
```
$ gc_improved

✗ Missing argument
→ Usage: gc <type> <message>
→ Valid types: feat, fix, docs, style, test, chore, perf, refactor, revert
→ Shortcuts: f, fi, d, s, t, c, p, r
```

---

## Color Legend

The examples above would display with these colors:

- `✗` - Red (EF4444) - Error symbol
- `✓` - Green (22C55E) - Success symbol
- `→` - Blue (3B82F6) - Info/suggestion arrow
- `⚠` - Pink (F43F5E) - Warning symbol
- Error text - Red
- Success text - Green
- Info text - Blue
- Warning text - Amber (F59E0B)
- Progress text - Teal (14B8A6)

---

## User Experience Comparison

### Before: Confusing Errors
```
$ killport

🚨 Usage: killport <port>
```
*User thinks: "Okay, but what's a valid port?"*

### After: Helpful Errors
```
$ killport_improved

✗ Missing argument
→ Usage: killport <port>
→ Example: killport 3000
```
*User thinks: "Oh, I need to provide a port number like 3000!"*

---

### Before: Generic Failure
```
$ gc xyz "message"

❌ Unknown commit type: xyz
```
*User thinks: "What types are valid?"*

### After: Helpful Suggestions
```
$ gc_improved xyz "message"

✗ Unknown command: 'xyz'
→ Available commands: feat, fix, docs, style, test, chore, perf, refactor, revert
```
*User thinks: "I should use one of these types instead."*

---

### Before: Silent Failure
```
$ ylock

# Uses pnpm even though it's not installed
# Fails with cryptic error
```

### After: Clear Fallback
```
$ ylock_improved

→ Found pnpm-lock.yaml
✗ Error: 'pnpm' is not installed
→ Using fallback: npm
→ Removing pnpm-lock.yaml...
→ Installing with npm...
✓ Installation complete with npm
```
*User knows exactly what happened and why*

---

## Summary

The improved error handling provides:

1. **Clear Status** - ✗ for errors, ✓ for success
2. **Error Context** - What went wrong
3. **Expected Format** - What was expected
4. **Helpful Suggestions** - How to fix it
5. **Examples** - Concrete usage examples
6. **Professional Appearance** - Consistent, color-coded
7. **Actionable Information** - Next steps clear

All while maintaining:
- **Conciseness** - Short, clear messages
- **Consistency** - Same format everywhere
- **Visibility** - No suppressed errors
- **Aesthetics** - Phenomenon theme colors
