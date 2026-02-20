# Advanced Git Integration

Complete git workflow enhancement with delta, fzf-based tools, and helpful aliases.

## Installation

### 1. Install Required Tools

```bash
# Install git-delta for beautiful diffs
brew install git-delta

# Install fzf for interactive selection (if not already installed)
brew install fzf
```

### 2. Link Git Config

The git config is located at `~/.config/git/config`. To use it, either:

**Option A: Include in your main .gitconfig**
```bash
echo "[include]
    path = ~/.config/git/config" >> ~/.gitconfig
```

**Option B: Set XDG_CONFIG_HOME (recommended)**
```bash
# Add to your shell config
export XDG_CONFIG_HOME="$HOME/.config"
```

Git will automatically use `~/.config/git/config` when `XDG_CONFIG_HOME` is set.

## Features

### Git Delta Configuration

Beautiful, syntax-highlighted diffs with:
- Side-by-side view
- Line numbers
- Syntax highlighting (Dracula theme)
- Better merge conflict visualization
- Navigate through diffs with n/N

### Fish Functions

#### `gbr` - Interactive Branch Switcher

Switch between branches with fuzzy search and preview.

```bash
gbr  # Opens fzf to select and switch branches
```

Features:
- Shows all local and remote branches
- Preview shows recent commits
- Automatically creates tracking branches for remote branches
- Excludes current branch from selection

#### `gstash` - Interactive Stash Management

Manage git stashes with ease.

```bash
gstash  # Opens interactive stash manager
```

Features:
- View all stashes with preview
- Apply, pop, drop, or show stashes
- Preview shows stash changes
- Keyboard shortcuts:
  - `a` - Apply (keep in stash)
  - `p` - Pop (apply and remove)
  - `d` - Drop (delete)
  - `s` - Show (view changes)
  - `q` - Quit

#### `gwt` - Git Worktree Helper

Manage git worktrees interactively.

```bash
gwt list              # List all worktrees
gwt add <path> <br>   # Add new worktree
gwt remove            # Remove worktree (interactive)
gwt goto              # Navigate to worktree (interactive)
gwt prune             # Clean up stale worktrees
```

Features:
- Interactive worktree selection with fzf
- Status preview for each worktree
- Safe deletion with confirmation
- Quick navigation between worktrees

### Git Aliases

#### Log Aliases
- `git lg` - Pretty graph log with colors
- `git lga` - Pretty graph log (all branches)
- `git tree` - Compact tree view of all branches

#### Status & Diff
- `git st` - Short status
- `git df` - Diff
- `git dfs` - Diff staged
- `git dfc` - Diff cached

#### Branch Management
- `git br` - List branches
- `git bra` - List all branches (including remotes)
- `git brd` - Delete branch (safe)
- `git brD` - Force delete branch

#### Commit Helpers
- `git cm` - Commit with message
- `git cma` - Commit all with message
- `git amend` - Amend last commit
- `git undo` - Undo last commit (keep changes)

#### Stash Helpers
- `git sl` - Stash list
- `git sp` - Stash pop
- `git ss` - Stash save

#### Worktree Helpers
- `git wl` - Worktree list
- `git wa` - Worktree add
- `git wr` - Worktree remove

#### Utilities
- `git last` - Show last commit
- `git unstage` - Unstage files
- `git discard` - Discard changes
- `git aliases` - List all aliases

## Usage Examples

### Branch Workflow

```bash
# Interactive branch switching
gbr

# Or use git alias for traditional approach
git br          # List branches
git checkout -b feature/new
```

### Stash Workflow

```bash
# Save current work
git stash save "WIP: feature implementation"

# Interactive stash management
gstash

# Or use git aliases
git sl          # List stashes
git sp          # Pop last stash
```

### Worktree Workflow

```bash
# Create a worktree for a feature branch
gwt add ../feature-auth feature/auth

# List all worktrees
gwt list

# Navigate to a worktree
gwt goto

# Remove when done
gwt remove

# Clean up stale worktrees
gwt prune
```

### Enhanced Diffs

```bash
# View beautiful side-by-side diffs
git diff
git diff --staged

# Compare branches
git diff main..feature

# View commit changes
git show HEAD
```

## Tips

1. **Delta Navigation**: In diff view, use `n`/`N` to jump between files

2. **FZF Controls**:
   - `Ctrl-J/K` or arrow keys to navigate
   - `Enter` to select
   - `Esc` to cancel
   - `?` for more shortcuts

3. **Worktrees**: Great for working on multiple features simultaneously without switching branches

4. **Stash Naming**: Always name your stashes for easy identification
   ```bash
   git stash save "descriptive-name"
   ```

## Configuration

All configuration files:
- Git config: `~/.config/git/config`
- Fish functions: `~/.config/fish/functions/`
  - `gbr.fish`
  - `gstash.fish`
  - `gwt.fish`

## Existing Git Functions (Not Modified)

Your existing git functions remain unchanged:
- `gio` - Original function
- `gis` - Original function
- `gip` - Original function
- `giofetch` - Original function
- `giopull` - Original function
- `ginit` - Original function

## Troubleshooting

### Delta not working
```bash
# Check delta is installed
which delta

# Test delta
echo "test" | delta
```

### FZF not working
```bash
# Install fzf
brew install fzf

# Setup fzf key bindings
fzf --fish | source
```

### Git config not loaded
```bash
# Check git config location
git config --list --show-origin | grep delta

# Include config in .gitconfig
[include]
    path = ~/.config/git/config
```
