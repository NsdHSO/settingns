# Fish Shell Automatic Documentation System

## Overview

A comprehensive automatic documentation system for all your fish shell functions. This system generates beautiful, organized documentation with usage examples, categorized by function type.

## Components Created

### 1. **generate_docs** - Main Documentation Generator
- Scans all function files in `~/.config/fish/functions/`
- Extracts function descriptions, usage patterns, and documentation
- Categorizes functions into: Git, Node/Package Manager, Navigation, and Utility
- Generates individual markdown files for each function
- Creates a comprehensive README with quick reference
- Generates keybindings reference card

**Location:** `/Users/davidsamuel.nechifor/.config/fish/functions/generate_docs.fish`

### 2. **docs** - Documentation Viewer
- Interactive documentation viewer with multiple modes
- View main README, specific function docs, or keybindings
- Integrated with `bat` (if available) for syntax highlighting
- List all documented functions

**Location:** `/Users/davidsamuel.nechifor/.config/fish/functions/docs.fish`

### 3. **auto_update_docs** - Automatic Update Checker
- Detects when functions have been modified
- Automatically triggers documentation regeneration
- Tracks last update timestamp

**Location:** `/Users/davidsamuel.nechifor/.config/fish/functions/auto_update_docs.fish`

### 4. **docs_watch** - Live Documentation Watcher
- Watches the functions directory for changes
- Automatically regenerates documentation when files change
- Requires `fswatch` (install via: `brew install fswatch`)

**Location:** `/Users/davidsamuel.nechifor/.config/fish/functions/docs_watch.fish`

### 5. **add_function_docs** - Documentation Helper
- Adds `--description` flags to existing functions
- Helps maintain consistent documentation format
- Creates backups before modification

**Location:** `/Users/davidsamuel.nechifor/.config/fish/functions/add_function_docs.fish`

## Usage

### Generate Documentation

```fish
# Generate all documentation
generate_docs

# This will create:
# - ~/.config/fish/README.md (main documentation)
# - ~/.config/fish/docs/*.md (individual function docs)
# - ~/.config/fish/KEYBINDINGS.md (keybindings reference)
```

### View Documentation

```fish
# View main README
docs

# View specific function documentation
docs gc
docs killport
docs yas

# View keybindings reference
docs --keybindings
docs -k

# List all documented functions
docs --list
docs -l

# Generate/regenerate documentation
docs --generate
docs -g

# Watch for changes and auto-update
docs --watch
docs -w

# Show help
docs --help
docs -h
```

### Auto-Update When Functions Change

```fish
# Check and update if needed
auto_update_docs

# Watch for changes in real-time (requires fswatch)
docs_watch
```

### Add Documentation to Functions

```fish
# Add description to a function
add_function_docs gc "Create conventional commits with emojis"
add_function_docs killport "Kill processes running on specified port"
```

## Documentation Format

### Function Files Should Include

1. **Description Flag** (preferred):
```fish
function my_function --description "What this function does"
    # Function code here
end
```

2. **Comment Header** (alternative):
```fish
# What this function does
function my_function
    # Function code here
end
```

3. **Usage Patterns**:
```fish
if test (count $argv) -eq 0
    echo "Usage: my_function <arg1> <arg2>"
    return 1
end
```

## Generated Documentation Structure

```
~/.config/fish/
├── README.md                      # Main documentation with all functions
├── KEYBINDINGS.md                 # Keybindings reference card
├── DOCUMENTATION_USAGE.md         # This file
├── docs/                          # Individual function documentation
│   ├── gc.md
│   ├── gis.md
│   ├── killport.md
│   ├── yas.md
│   └── ...
└── functions/                     # Your functions
    ├── generate_docs.fish
    ├── docs.fish
    ├── auto_update_docs.fish
    ├── docs_watch.fish
    ├── add_function_docs.fish
    └── ...
```

## Features

### Automatic Categorization
Functions are automatically categorized based on naming:
- **Git Functions**: Start with 'g' (gc, gis, gio, etc.)
- **Node/Package Functions**: Start with 'y' or 'n' (yas, yall, nxg, etc.)
- **Navigation Functions**: Dot commands (., .., ..., etc.)
- **Utility Functions**: Everything else

### Smart Example Generation
The system generates contextual examples for each function based on:
- Function name patterns
- Detected usage patterns
- Common use cases

### Quick Reference Table
Main README includes a quick reference table with most-used commands for fast access.

### Keybindings Documentation
Comprehensive keybindings reference covering:
- Default Fish keybindings
- Editing shortcuts
- Navigation shortcuts
- History and search
- Completion and suggestions
- Process control
- Space for custom keybindings

## Integration

### Auto-Update on Shell Startup (Optional)
Add to `~/.config/fish/config.fish`:
```fish
# Auto-update docs if functions changed
if status is-interactive
    auto_update_docs
end
```

### Watch Mode for Development
When actively developing functions:
```fish
# Run in a separate terminal
docs_watch
```

## Best Practices

1. **Add descriptions to new functions**:
   ```fish
   function new_func --description "Clear description of what it does"
       # code
   end
   ```

2. **Include usage examples in comments**:
   ```fish
   # Usage: my_func <port> [options]
   # Example: my_func 3000 --force
   ```

3. **Regenerate docs after major changes**:
   ```fish
   generate_docs
   ```

4. **Use the viewer for quick reference**:
   ```fish
   docs <function_name>
   ```

## Output Examples

### Generated Function Documentation (docs/gc.md)
```markdown
# gc

**Description:** Create conventional commits with emojis

## Usage
```fish
gc <type> <message>
```

## Example
```fish
# Commit with feat type
gc feat "add new feature"

# Commit with fix type
gc fix "resolve bug in parser"
```
```

### Main README Structure
- Overview section
- Categories (Git, Node, Navigation, Utility)
- Each function with description and usage
- Quick reference table
- Links to detailed documentation

## Requirements

- Fish shell (obviously!)
- `find` command (standard on macOS/Linux)
- `bat` (optional, for better viewing): `brew install bat`
- `fswatch` (optional, for watch mode): `brew install fswatch`

## Files Created by This Component

All new files created:
1. `/Users/davidsamuel.nechifor/.config/fish/functions/generate_docs.fish`
2. `/Users/davidsamuel.nechifor/.config/fish/functions/docs.fish`
3. `/Users/davidsamuel.nechifor/.config/fish/functions/auto_update_docs.fish`
4. `/Users/davidsamuel.nechifor/.config/fish/functions/docs_watch.fish`
5. `/Users/davidsamuel.nechifor/.config/fish/functions/add_function_docs.fish`
6. `/Users/davidsamuel.nechifor/.config/fish/DOCUMENTATION_USAGE.md`

Generated on first run:
- `~/.config/fish/README.md`
- `~/.config/fish/KEYBINDINGS.md`
- `~/.config/fish/docs/*.md` (one per function)
- `~/.config/fish/.docs_timestamp` (tracking file)

## Notes

- Documentation generation is fast (typically < 1 second)
- Individual function docs are linked from main README
- System skips internal functions (starting with `_`)
- System skips nvm and fisher functions (too many, framework-specific)
- All documentation uses standard markdown format
- Works with any number of custom functions

---

**Generated:** 2026-02-19
**Component:** 19 - Automatic Documentation
**Status:** Complete
