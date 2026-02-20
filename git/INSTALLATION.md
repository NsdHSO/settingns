# Installation Guide

## Prerequisites

Both tools are already installed on your system:
- ✅ **git-delta** (`/opt/homebrew/bin/delta`)
- ✅ **fzf** (`/opt/homebrew/bin/fzf`)

## Setup Steps

### 1. Enable Git Configuration

Add the following to your `~/.gitconfig`:

```bash
[include]
    path = ~/.config/git/config
```

**Quick command:**
```bash
echo -e "\n[include]\n    path = ~/.config/git/config" >> ~/.gitconfig
```

### 2. Reload Fish Functions

The fish functions are already in place:
- ✅ `~/.config/fish/functions/gbr.fish`
- ✅ `~/.config/fish/functions/gstash.fish`
- ✅ `~/.config/fish/functions/gwt.fish`

Reload fish to make them available:
```bash
fish -c 'source ~/.config/fish/config.fish'
```

Or simply restart your terminal.

### 3. Test the Setup

```bash
# Test delta
echo -e "test" | delta

# Test fish functions
gbr     # Should show branch selector
gstash  # Should show stash manager
gwt     # Should show help menu

# Test git aliases
git lg  # Should show pretty log
git st  # Should show short status
```

## What Was Installed

### Git Configuration
- **File**: `~/.config/git/config`
- **Includes**:
  - Delta configuration (beautiful diffs)
  - 30+ helpful git aliases
  - Better merge conflict display
  - Enhanced color schemes

### Fish Functions

#### `gbr` - Interactive Branch Switcher
```bash
gbr  # Launch interactive branch selector
```

#### `gstash` - Interactive Stash Manager
```bash
gstash  # Launch interactive stash manager
```

#### `gwt` - Git Worktree Helper
```bash
gwt list              # List worktrees
gwt add <path> <br>   # Add worktree
gwt remove            # Remove worktree
gwt goto              # Navigate to worktree
gwt prune             # Clean stale worktrees
```

### Documentation Files
- `README.md` - Complete documentation
- `QUICK_REFERENCE.md` - Command cheat sheet
- `INSTALLATION.md` - This file
- `setup.sh` - Automated setup script

## Manual Setup (Alternative)

If you prefer not to include the config file:

```bash
# Copy delta config to main .gitconfig
cat ~/.config/git/delta.gitconfig >> ~/.gitconfig

# Copy aliases to main .gitconfig
cat ~/.config/git/config | grep -A 100 "\[alias\]" >> ~/.gitconfig
```

## Verification

Run this command to verify everything is working:

```bash
# Check git config is loaded
git config --get-regexp alias | head -5

# Check delta is configured
git config --get core.pager

# Check fish functions are available
type gbr gstash gwt
```

Expected output:
- Should see aliases like `alias.lg`, `alias.st`, etc.
- Should see `delta` as pager
- Should see function definitions

## Troubleshooting

### Delta not working
```bash
# Verify delta is in PATH
which delta

# Test delta manually
git diff | delta
```

### Functions not found
```bash
# Check function files exist
ls -l ~/.config/fish/functions/{gbr,gstash,gwt}.fish

# Reload fish config
exec fish
```

### Config not loaded
```bash
# Check git config location
git config --list --show-origin | grep -E "(pager|alias)"

# Verify include is correct
grep -A 2 "\[include\]" ~/.gitconfig
```

## Uninstallation

To remove these tools:

```bash
# Remove git config include
# Edit ~/.gitconfig and remove:
# [include]
#     path = ~/.config/git/config

# Remove fish functions
rm ~/.config/fish/functions/{gbr,gstash,gwt}.fish

# Remove config files
rm -rf ~/.config/git/{config,README.md,QUICK_REFERENCE.md,INSTALLATION.md,setup.sh}
```

## Next Steps

1. Add the include to your `~/.gitconfig`
2. Restart your terminal
3. Try the new commands!
4. Read `QUICK_REFERENCE.md` for common usage patterns

## Support

For detailed usage and examples, see:
- **Full docs**: `~/.config/git/README.md`
- **Quick ref**: `~/.config/git/QUICK_REFERENCE.md`
