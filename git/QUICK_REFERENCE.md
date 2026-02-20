# Git Advanced Tools - Quick Reference

## New Fish Functions

### `gbr` - Branch Switcher
```bash
gbr                  # Interactive branch selection with fzf
```
- Fuzzy search all branches (local + remote)
- Preview: recent commits
- Auto-creates tracking branches

### `gstash` - Stash Manager
```bash
gstash              # Interactive stash management
```
**Actions:**
- `a` - Apply stash (keep it)
- `p` - Pop stash (apply & delete)
- `d` - Drop stash (delete only)
- `s` - Show stash diff
- `q` - Quit

### `gwt` - Worktree Manager
```bash
gwt list                    # List all worktrees
gwt add <path> <branch>     # Create new worktree
gwt remove                  # Remove worktree (interactive)
gwt goto                    # Navigate to worktree (interactive)
gwt prune                   # Clean stale worktrees
```

## New Git Aliases

### Logs
```bash
git lg              # Pretty graph log
git lga             # Pretty graph (all branches)
git tree            # Compact tree view
git last            # Last commit details
```

### Status & Diff
```bash
git st              # Short status (git status -sb)
git df              # Diff working dir
git dfs             # Diff staged files
git dfc             # Diff cached
```

### Branch
```bash
git br              # List branches
git bra             # List all (local + remote)
git brd <branch>    # Delete branch (safe)
git brD <branch>    # Force delete branch
```

### Commit
```bash
git cm "msg"        # Commit with message
git cma "msg"       # Commit all with message
git amend           # Amend last commit
git undo            # Undo last commit (soft)
git unstage <file>  # Unstage file
git discard <file>  # Discard changes
```

### Stash
```bash
git sl              # List stashes
git sp              # Pop last stash
git ss "name"       # Save stash with name
```

### Worktree
```bash
git wl              # List worktrees
git wa <path> <br>  # Add worktree
git wr <path>       # Remove worktree
```

### Utilities
```bash
git aliases         # List all git aliases
```

## Delta Features

Automatically enabled for all diffs!

- **Side-by-side view** with syntax highlighting
- **Line numbers** for easy reference
- **Navigate**: `n` (next file), `N` (previous file)
- **Themes**: Dracula by default
- **Better merge conflicts**: diff3 style

## Workflow Examples

### Feature Branch Workflow
```bash
# Create and switch to feature branch
git checkout -b feature/awesome

# Work on feature...

# Switch to another branch quickly
gbr  # Select main

# Go back to feature
gbr  # Select feature/awesome
```

### Stash Workflow
```bash
# Quick save current work
git ss "WIP: implementing auth"

# Work on something else...

# Come back and restore
gstash  # Choose your stash and action
```

### Multi-feature Development (Worktrees)
```bash
# Create worktrees for parallel work
gwt add ../proj-feature1 feature/feature1
gwt add ../proj-bugfix hotfix/critical-bug

# List all worktrees
gwt list

# Jump between worktrees
gwt goto  # Interactive selection

# When done
gwt remove  # Select worktree to remove
```

### Code Review
```bash
# Beautiful diff view
git df              # View unstaged changes
git dfs             # View staged changes

# Compare branches
git diff main..feature/new

# View specific commit
git show abc123

# Pretty log
git lg              # Graph view
git tree            # Tree view
```

## Keyboard Shortcuts (FZF)

- `↑↓` or `Ctrl-J/K` - Navigate
- `Enter` - Select
- `Esc` - Cancel
- `Ctrl-C` - Abort
- `?` - Help

## Your Existing Functions (Unchanged)

These remain as they were:
- `gio` - Your original git function
- `gis` - Your original git function
- `gip` - Your original git function
- `giofetch` - Your original git function
- `giopull` - Your original git function
- `ginit` - Your original git function

---

**Installation Required:**
1. Add to `~/.gitconfig`:
   ```
   [include]
       path = ~/.config/git/config
   ```
2. Both delta and fzf are already installed!
