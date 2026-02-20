# FZF Keybindings Reference

## Standard FZF Keybindings (with fzf.fish plugin)

### Core Navigation Keys

| Keybinding | Description | Action |
|------------|-------------|--------|
| `Ctrl+R` | Fuzzy Command History | Search and execute commands from history |
| `Ctrl+T` | Fuzzy File Finder | Find files and insert path at cursor |
| `Alt+C` | Fuzzy Directory Changer | Change to any directory in the system |
| `Ctrl+Alt+F` | Fuzzy File Search | Advanced file search with preview |
| `Ctrl+Alt+L` | Fuzzy Git Log | Browse git commit history |

### Inside FZF Interface

| Keybinding | Description |
|------------|-------------|
| `↑` / `↓` | Navigate up/down |
| `Tab` | Select multiple items (multi-select mode) |
| `Shift+Tab` | Deselect items |
| `Enter` | Confirm selection |
| `Esc` / `Ctrl+C` | Cancel and exit |
| `Ctrl+/` | Toggle preview window |
| `Page Up` / `Page Down` | Scroll preview |
| `Ctrl+U` | Clear query |

## Custom FZF Functions (No keybindings - run as commands)

### Git Operations

| Command | Description | Usage |
|---------|-------------|-------|
| `fgb` | Fuzzy Git Branch | Select and checkout git branches |
| `fge` | Fuzzy Git Edit | Edit modified git files (multi-select) |

### System Operations

| Command | Description | Usage |
|---------|-------------|-------|
| `fkill [signal]` | Fuzzy Process Killer | Kill processes with optional signal |
| `fcd [base_dir]` | Fuzzy Directory Change | Change to any directory with preview |
| `fh` | Fuzzy History Execute | Search and execute from history |

### Utility

| Command | Description | Usage |
|---------|-------------|-------|
| `fzf-check` | Installation Check | Verify fzf setup and dependencies |

## FZF Interface Controls (Inside any FZF prompt)

### Search and Navigation

```
Type to search → Fuzzy matching in real-time
↑/↓ or j/k    → Move selection up/down
Ctrl+N/P      → Next/Previous (alternative)
Home/End      → First/Last item
```

### Selection

```
Tab           → Toggle selection (multi-select)
Shift+Tab     → Deselect
Ctrl+A        → Select all
Ctrl+D        → Deselect all (if implemented)
```

### Preview Window

```
Ctrl+/        → Toggle preview window
Shift+↑/↓     → Scroll preview up/down
```

### Actions

```
Enter         → Confirm selection
Esc           → Cancel/Exit
Ctrl+C        → Cancel/Exit
Ctrl+U        → Clear current query
```

## Installation Instructions

### 1. Install fzf.fish Plugin (Recommended)

```bash
fisher install PatrickF1/fzf.fish
```

This will enable the standard keybindings (Ctrl+R, Ctrl+T, Alt+C, etc.)

### 2. Without Plugin

The custom functions (`fgb`, `fkill`, `fcd`, `fge`, `fh`) work without the plugin.
Just reload your shell:

```bash
source ~/.config/fish/config.fish
```

## Keybinding Conflicts

### Checking for Conflicts

To check if any keybindings conflict with existing ones:

```bash
bind | grep -E "(\\cr|\\ct|\\ec)"
```

### Custom Keybindings

If you want to add custom keybindings for the custom functions, add to your config:

```fish
# Example: Bind Ctrl+G Ctrl+B to fgb (git branch)
bind \cg\cb fgb

# Example: Bind Ctrl+K to fkill
bind \ck fkill

# Example: Bind Alt+D to fcd
bind \ed fcd
```

**Note**: The custom functions are designed to be run as commands, not keybindings, to avoid conflicts.

## Optional Keybindings You Can Add

Add these to `/Users/davidsamuel.nechifor/.config/fish/conf.d/fzf.fish` if desired:

```fish
# Git branch switcher
bind \cg\cb 'fgb'

# Git file editor
bind \cg\ce 'fge'

# Fuzzy directory change
bind \cd\cf 'fcd'

# Fuzzy process kill (careful with this one!)
# bind \ck 'fkill'
```

## Phenomenon Theme Colors in FZF

Your fzf interface uses these colors from the Phenomenon theme:

- **Background**: Dark (`#0d0d0d`, `#1e1e2e`)
- **Foreground**: Light gray (`#E5E5E5`)
- **Directory**: Magenta/Pink (`#BF409D`)
- **Git Info**: Blue (`#3B82F6`)
- **Success**: Green (`#22C55E`)
- **Error**: Red (`#EF4444`)
- **Time**: Teal (`#14B8A6`)
- **Symbols**: Pink/Red (`#F43F5E`)

## Troubleshooting

### Keybindings Not Working

1. Check if fzf.fish is installed:
   ```bash
   fisher list | grep fzf
   ```

2. Reload your shell:
   ```bash
   source ~/.config/fish/config.fish
   ```

3. Check for conflicts:
   ```bash
   bind | grep -E "(\\cr|\\ct|\\ec)"
   ```

### Custom Functions Not Found

Run the installation checker:
```bash
fzf-check
```

This will verify:
- fzf binary installation
- fzf.fish plugin status
- Optional dependencies (fd, bat, eza)
- Custom function availability
- Configuration files
- Environment variables

## Quick Reference Card

```
╔══════════════════════════════════════════════════════════════╗
║                    FZF Quick Reference                       ║
╠══════════════════════════════════════════════════════════════╣
║ KEYBINDINGS (with fzf.fish plugin)                          ║
║   Ctrl+R      Command history                                ║
║   Ctrl+T      File finder                                    ║
║   Alt+C       Directory changer                              ║
║                                                              ║
║ CUSTOM COMMANDS                                              ║
║   fgb         Git branch switcher                            ║
║   fkill       Process killer                                 ║
║   fcd         Directory changer (enhanced)                   ║
║   fge         Git file editor                                ║
║   fh          History executor                               ║
║   fzf-check   Installation checker                           ║
║                                                              ║
║ INSIDE FZF                                                   ║
║   ↑/↓         Navigate                                       ║
║   Tab         Multi-select                                   ║
║   Enter       Confirm                                        ║
║   Esc         Cancel                                         ║
║   Ctrl+/      Toggle preview                                 ║
╚══════════════════════════════════════════════════════════════╝
```

## Examples

### Example 1: Git Workflow
```bash
# Switch to a different branch
fgb

# Edit modified files
fge

# Check and select specific files to edit
Ctrl+T  # Then type file name to filter
```

### Example 2: Process Management
```bash
# Find and kill a process
fkill

# Kill with specific signal
fkill KILL
fkill 9
```

### Example 3: Directory Navigation
```bash
# Change to any directory from home
fcd

# Change to directory from specific location
fcd /usr/local

# Quick directory jump with Alt+C
Alt+C  # (if fzf.fish is installed)
```

### Example 4: Command History
```bash
# Search full history and execute
fh

# Search history with fzf.fish
Ctrl+R  # (if fzf.fish is installed)
```

## Integration Status

✓ Configuration: `/Users/davidsamuel.nechifor/.config/fish/conf.d/fzf.fish`
✓ Functions: `/Users/davidsamuel.nechifor/.config/fish/functions/fgb.fish` (and 5 more)
✓ Theme: Phenomenon colors integrated
✓ Documentation: This file

Optional:
⚠ fzf.fish plugin: Install with `fisher install PatrickF1/fzf.fish`
⚠ fd: Install with `brew install fd`
⚠ bat: Install with `brew install bat`
⚠ eza: Install with `brew install eza`
