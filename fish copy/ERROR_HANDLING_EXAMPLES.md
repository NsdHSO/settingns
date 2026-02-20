# Advanced Error Handling Examples

## Component 18: Advanced Error Handling Implementation

This document demonstrates the improved error handling system for fish functions with consistent formatting, graceful fallbacks, helpful error messages, "did you mean?" suggestions, and recovery mechanisms using Phenomenon colors.

---

## Core Infrastructure

### 1. Error Handler (`error_handler.fish`)

Central error handling function with 10 error types and Phenomenon color coding.

**Example Output:**

```
✗ Error: 'bat' is not installed
→ Using fallback: cat

✗ Missing argument
→ Usage: killport <port>

✗ Invalid argument: 'abc'
→ Expected: numeric port (1-65535)

✗ Unknown command: 'serv'
→ Did you mean:
  • service
  • server

✗ Not a git repository
→ Initialize with: git init

✗ No package lockfile found
→ Create one with: npm install, yarn install, or pnpm install

✗ Permission denied: /etc/system_file
→ Try with sudo or check file permissions

✗ file not found: config.json

✓ Tool installed successfully

✗ Database connection timeout after 30 seconds
```

### 2. Tool Checker (`check_tool.fish`)

Verifies tool availability with graceful fallbacks and optional auto-install.

**Example Usage:**

```fish
# Example 1: Fallback to cat if bat not found
set viewer (check_tool bat cat)
command $viewer myfile.txt

# Output:
✗ Error: 'bat' is not installed
→ Using fallback: cat
```

```fish
# Example 2: Auto-install missing tool
check_tool fzf "" auto

# Output:
→ Installing fzf via Homebrew...
✓ fzf installed successfully
```

### 3. Command Suggester (`suggest_command.fish`)

Provides "did you mean?" suggestions using string distance algorithm.

**Example Usage:**

```fish
suggest_command "comit" commit component complete

# Output:
✗ Unknown command: 'comit'
→ Did you mean:
  • commit
```

```fish
suggest_command "xyz" commit push pull

# Output:
✗ Unknown command: 'xyz'
→ Available commands: commit, push, pull
```

---

## Improved Functions

### 1. `ylock_improved.fish`

Enhanced package lock manager with comprehensive error checking.

**Example 1: Success Case**
```fish
ylock_improved

# Output:
→ Found yarn.lock
→ Removing yarn.lock...
→ Installing with yarn...
✓ Installation complete with yarn
```

**Example 2: Not in Node.js Project**
```fish
ylock_improved

# Output:
✗ file not found: package.json
→ This doesn't appear to be a Node.js project
```

**Example 3: No Lockfile**
```fish
ylock_improved

# Output:
✗ No package lockfile found
→ Create one with: npm install, yarn install, or pnpm install
→ Available package managers:
  • pnpm (not installed)
  • yarn (installed)
  • npm (installed)
```

**Example 4: Manager Not Installed**
```fish
ylock_improved

# Output:
→ Found pnpm-lock.yaml
✗ Error: 'pnpm' is not installed
→ Using fallback: npm
→ Removing pnpm-lock.yaml...
→ Installing with npm...
✓ Installation complete with npm
```

### 2. `gc_improved.fish`

Enhanced git commit with typo detection and validation.

**Example 1: Success Case**
```fish
gc_improved feat "add user authentication"

# Output:
→ Committing changes...
✓ Commit successful!
→ feat: 🎸 add user authentication
```

**Example 2: Not in Git Repo**
```fish
gc_improved feat "some message"

# Output:
✗ Not a git repository
→ Initialize with: git init
```

**Example 3: Missing Arguments**
```fish
gc_improved

# Output:
✗ Missing argument
→ Usage: gc <type> <message>
→ Valid types: feat, fix, docs, style, test, chore, perf, refactor, revert
→ Shortcuts: f, fi, d, s, t, c, p, r
```

**Example 4: Typo Detection**
```fish
gc_improved servise "add api service"

# Output:
✗ Unknown command: 'servise'
→ Did you mean:
  • service
```

**Example 5: No Changes**
```fish
gc_improved feat "new feature"

# Output:
✗ No changes to commit
→ Working tree is clean
```

**Example 6: Empty Message**
```fish
gc_improved feat ""

# Output:
✗ Invalid argument: ''
→ Expected: non-empty commit message
```

### 3. `nxg_improved.fish`

Enhanced Nx generator with validation and helpful errors.

**Example 1: Success Case**
```fish
nxg_improved component auth-form

# Output:
→ Generating component: auth-form
→ Directory created: auth-form
✓ Component 'auth-form' created successfully
```

**Example 2: Nx Not Installed**
```fish
nxg_improved component test

# Output:
✗ Error: 'nx' is not installed
→ Install with: npm install -g nx
→ Or locally: npm install --save-dev nx
```

**Example 3: Not in Nx Workspace**
```fish
nxg_improved component test

# Output:
✗ file not found: nx.json
→ This doesn't appear to be an Nx workspace
→ Create one with: npx create-nx-workspace
```

**Example 4: Missing Arguments**
```fish
nxg_improved component

# Output:
✗ Missing argument
→ Usage: nxg <type> <name>
→ Valid types:
  • component (or c) - Generate Angular component
  • service (or s) - Generate Angular service
  • interface - Generate TypeScript interface
→ Example: nxg component my-feature
```

**Example 5: Invalid Name**
```fish
nxg_improved component "my component"

# Output:
✗ Invalid argument: 'my component'
→ Expected: valid identifier (letters, numbers, hyphens, underscores)
```

**Example 6: Directory Exists**
```fish
nxg_improved component auth-form

# Output:
✗ Directory 'auth-form' already exists
→ Choose a different name or remove the existing directory
```

**Example 7: Typo Detection**
```fish
nxg_improved servce auth-service

# Output:
✗ Unknown command: 'servce'
→ Did you mean:
  • service
```

### 4. `killport_improved.fish`

Enhanced port killer with safety checks and validation.

**Example 1: Success Case**
```fish
killport_improved 3000

# Output:
→ Processes on port 3000:
1) PID 12345 [node] (user: david)
2) PID 12346 [nginx] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): 1
→ Terminating PID 12345...
✓ PID 12345 terminated successfully
✓ Killed 1 process(es)
```

**Example 2: No Processes**
```fish
killport_improved 9999

# Output:
→ Port 9999: No active processes
```

**Example 3: Missing Argument**
```fish
killport_improved

# Output:
✗ Missing argument
→ Usage: killport <port>
→ Example: killport 3000
```

**Example 4: Invalid Port**
```fish
killport_improved abc

# Output:
✗ Invalid argument: 'abc'
→ Expected: numeric port (1-65535)
```

**Example 5: Out of Range**
```fish
killport_improved 99999

# Output:
✗ Invalid argument: '99999'
→ Expected: port number between 1 and 65535
```

**Example 6: Permission Denied**
```fish
killport_improved 80

# Output:
→ Processes on port 80:
1) PID 443 [httpd] (user: root)
→ Enter numbers to kill (space-separated, 0 to abort): 1
→ PID 443 requires elevated privileges
→ Terminating PID 443...
✗ Permission denied: PID 443
→ Try with sudo: sudo fish -c 'killport 80'
```

**Example 7: Invalid Selection**
```fish
killport_improved 3000

# Output:
→ Processes on port 3000:
1) PID 12345 [node] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): 5
✗ Invalid argument: '5'
→ Expected: valid selection (1-1)
```

**Example 8: Abort Operation**
```fish
killport_improved 3000

# Output:
→ Processes on port 3000:
1) PID 12345 [node] (user: david)
→ Enter numbers to kill (space-separated, 0 to abort): 0
→ Operation cancelled
```

---

## Demonstration Functions

### 1. `error_examples`

Demonstrates all 10 error types with visual examples.

**Usage:**
```fish
error_examples
```

**Output:**
```
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

### 2. `smart_view`

Smart file viewer with automatic fallback.

**Example 1: With bat**
```fish
smart_view README.md

# Uses bat with syntax highlighting
```

**Example 2: Without bat**
```fish
smart_view README.md

# Output:
✗ Error: 'bat' is not installed
→ Using fallback: cat
# Uses cat as fallback
```

**Example 3: Missing File**
```fish
smart_view nonexistent.txt

# Output:
✗ file not found: nonexistent.txt
```

### 3. `safe_mkdir`

Safe directory creation with validation.

**Example 1: Success**
```fish
safe_mkdir my-project

# Output:
✓ Directory 'my-project' created
```

**Example 2: Invalid Name**
```fish
safe_mkdir "my project"

# Output:
✗ Invalid argument: 'my project'
→ Expected: valid directory name (letters, numbers, hyphens, underscores)
```

**Example 3: Already Exists**
```fish
safe_mkdir existing-dir

# Output:
✗ Directory 'existing-dir' already exists
→ Use a different name or remove the existing directory
```

### 4. `git_safe_command`

Git-aware command with branch protection.

**Example 1: Safe Branch**
```fish
git_safe_command

# Output:
✓ Safe to proceed on branch 'feature/auth'
```

**Example 2: Not a Git Repo**
```fish
git_safe_command

# Output:
✗ Not a git repository
→ Initialize with: git init
```

**Example 3: Protected Branch**
```fish
git_safe_command

# Output:
⚠ Warning: Operating on protected branch 'main'
→ Continue? [y/N] n
→ Operation cancelled
```

**Example 4: Detached HEAD**
```fish
git_safe_command

# Output:
✗ Detached HEAD state
→ Checkout a branch first: git checkout <branch>
```

---

## Color Coding Reference

All error messages use Phenomenon theme colors for consistency:

| Element | Color | Hex | Usage |
|---------|-------|-----|-------|
| Error | Red | EF4444 | Error messages, failures |
| Warning | Amber | F59E0B | Warnings, cautions |
| Info | Blue | 3B82F6 | Instructions, suggestions |
| Success | Green | 22C55E | Success messages, confirmations |
| Symbols | Pink | F43F5E | Prompts, important markers |
| Time/Cyan | Teal | 14B8A6 | Secondary info, progress |
| Directory | Magenta | BF409D | Paths, resources |

---

## Key Features Summary

### 1. Consistent Error Formatting
- ✓ All errors use the same visual style
- ✓ Clear error symbol (✗) vs success (✓)
- ✓ Color-coded by severity

### 2. Graceful Fallbacks
- ✓ Automatic fallback to alternative tools (bat → cat)
- ✓ Transparent fallback messages
- ✓ No functionality loss

### 3. Helpful Error Messages
- ✓ Explains what went wrong
- ✓ Shows expected format
- ✓ Provides concrete examples

### 4. "Did You Mean?" Suggestions
- ✓ Detects typos using string distance
- ✓ Suggests similar commands
- ✓ Lists all valid options

### 5. Recovery Mechanisms
- ✓ Auto-install missing tools (optional)
- ✓ Suggests manual installation commands
- ✓ Provides alternative solutions

### 6. Phenomenon Colors
- ✓ Consistent with shell theme
- ✓ Semantic color usage
- ✓ Improved visual hierarchy

---

## Testing Checklist

- [x] Error handler with all 10 types
- [x] Tool checker with fallbacks
- [x] Command suggester with typo detection
- [x] Improved ylock with validation
- [x] Improved gc with git checks
- [x] Improved nxg with Nx validation
- [x] Improved killport with safety checks
- [x] Example functions
- [x] Color coding consistency
- [x] No error suppression
- [x] Concise messages
- [x] Phenomenon theme colors
