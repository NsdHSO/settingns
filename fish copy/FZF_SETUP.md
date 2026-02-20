# FZF Integration Setup Guide

## Overview
This document describes the fzf integration for your Fish shell configuration.

## Installation Status

### ✓ Already Installed
- **fzf**: `/opt/homebrew/bin/fzf`

### Optional: Install fzf.fish Plugin (Recommended)
The `fzf.fish` plugin provides enhanced key bindings and integration:

```bash
fisher install PatrickF1/fzf.fish
```

## Configuration Files Created

1. **`/Users/davidsamuel.nechifor/.config/fish/conf.d/fzf.fish`**
   - Main fzf configuration with Phenomenon theme colors
   - Environment variables and default options
   - Auto-loads on shell startup

## Custom Functions Created

### 1. `fgb` - Fuzzy Git Branch
**Location**: `/Users/davidsamuel.nechifor/.config/fish/functions/fgb.fish`

**Usage**: `fgb`

**Description**:
- Fuzzy find and checkout git branches (local and remote)
- Shows git log preview for each branch
- Supports both local and remote branches

**Features**:
- Preview: Git log with graph for selected branch
- Multi-line preview with commit history
- Auto-removes `origin/` prefix when checking out

---

### 2. `fkill` - Fuzzy Process Killer
**Location**: `/Users/davidsamuel.nechifor/.config/fish/functions/fkill.fish`

**Usage**: `fkill [signal]`

**Description**:
- Enhanced version of killport with fuzzy finding
- Select one or more processes to kill
- Default signal: TERM

**Features**:
- Multi-select support (TAB to select multiple)
- Preview: Detailed process information
- Confirmation prompt before killing
- Custom signal support

**Examples**:
```bash
fkill           # Kill with TERM signal
fkill KILL      # Kill with KILL signal
fkill 9         # Kill with signal 9
```

---

### 3. `fcd` - Fuzzy Directory Change
**Location**: `/Users/davidsamuel.nechifor/.config/fish/functions/fcd.fish`

**Usage**: `fcd [base_directory]`

**Description**:
- Change to any directory using fuzzy search
- Default search base: $HOME
- Shows directory preview with eza or ls

**Features**:
- Fast search with `fd` (falls back to `find`)
- Preview: Directory tree or file list
- Auto-lists contents after cd
- Uses eza if available for pretty output

**Examples**:
```bash
fcd              # Search from home directory
fcd /usr/local   # Search from /usr/local
```

---

### 4. `fge` - Fuzzy Git Edit
**Location**: `/Users/davidsamuel.nechifor/.config/fish/functions/fge.fish`

**Usage**: `fge`

**Description**:
- Select modified git files and open in editor
- Multi-select support for editing multiple files
- Uses $EDITOR or defaults to nvim

**Features**:
- Preview: File contents with bat or cat
- Multi-select: Edit multiple files at once
- Respects $EDITOR environment variable

---

### 5. `fh` - Fuzzy History Execute
**Location**: `/Users/davidsamuel.nechifor/.config/fish/functions/fh.fish`

**Usage**: `fh`

**Description**:
- Search command history and execute selected command
- Reverse chronological order (newest first)
- Preview shows the full command

**Features**:
- Full history search
- Exact matching
- Shows command preview before execution

---

## Key Bindings (with fzf.fish plugin)

If you install the `fzf.fish` plugin, these key bindings will be available:

- **Ctrl+R**: Fuzzy command history search
- **Ctrl+T**: Fuzzy file finder (insert path)
- **Alt+C**: Fuzzy directory changer
- **Ctrl+Alt+F**: Fuzzy file search
- **Ctrl+Alt+L**: Fuzzy git log browser

## Phenomenon Theme Colors

The fzf integration uses your Phenomenon theme colors:

- **Background**: Dark (#0d0d0d, #1e1e2e)
- **Foreground**: Light gray (#E5E5E5)
- **Selected**: Pink/Magenta (#BF409D)
- **Pointer**: Pink/Red (#F43F5E)
- **Info**: Teal (#14B8A6)
- **Success**: Green (#22C55E)
- **Highlight**: Blue (#3B82F6)

## Environment Variables

### FZF_DEFAULT_OPTS
- Height: 40%
- Layout: Reverse
- Border: Enabled
- Preview: Right side, 60% width
- Ctrl+/: Toggle preview

### FZF_DEFAULT_COMMAND
Uses `fd` if available (faster than find):
- Type: Files only
- Hidden files: Included
- Follows symlinks
- Excludes: .git directories

### FZF_CTRL_T_OPTS
File finder preview with bat (syntax highlighting)

### FZF_ALT_C_OPTS
Directory preview with eza tree view

## Optional Dependencies

### Recommended (for enhanced features):

1. **fd** - Faster file/directory finding
   ```bash
   brew install fd
   ```

2. **bat** - Syntax highlighting for file previews
   ```bash
   brew install bat
   ```

3. **eza** - Modern ls replacement with colors and icons
   ```bash
   brew install eza
   ```

4. **fzf.fish** - Enhanced Fish integration
   ```bash
   fisher install PatrickF1/fzf.fish
   ```

## Testing

After reloading your shell, test each function:

```bash
# Reload shell configuration
source ~/.config/fish/config.fish

# Test functions
fgb     # Git branch switcher
fkill   # Process killer
fcd     # Directory changer
fge     # Git file editor
fh      # History search
```

## Integration Status

- [x] fzf installed via Homebrew
- [x] Theme colors configured (Phenomenon)
- [x] Custom functions created (fgb, fkill, fcd, fge, fh)
- [x] Configuration file in conf.d/
- [ ] fzf.fish plugin (optional, install with fisher)

## Notes

- All functions include error handling and user-friendly messages
- Colors match your Phenomenon theme
- Functions work standalone (don't require fzf.fish plugin)
- Installing fzf.fish plugin will add additional key bindings
- All functions are optional and can be used independently
