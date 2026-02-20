# Fish Configuration Backup System

Automatic git-based backup system for fish configuration.

## Overview

This backup system provides automatic and manual backup capabilities for your fish shell configuration using git. It ensures your configuration is safely versioned while keeping sensitive data (like `fish_variables`) out of version control.

## Features

- Manual backup with `backup_fish_config`
- Restore from any backup with `restore_fish_config`
- Pre-modification snapshots with `snapshot_fish_config`
- List all snapshots with `list_fish_snapshots`
- Optional daily auto-backup via launchd

## Functions

### backup_fish_config

Creates a backup commit of current fish configuration.

```fish
backup_fish_config
```

- Commits all changes in `~/.config/fish/`
- Respects `.gitignore` (excludes `fish_variables` and `agent-state/`)
- Creates timestamped commit message
- Shows what was backed up

### restore_fish_config

Restores fish configuration from a previous backup.

```fish
restore_fish_config [tag-name or commit-hash]
```

- Without arguments: restores from HEAD (latest commit)
- With tag/commit: restores from specific snapshot
- Prompts for confirmation if there are uncommitted changes
- Shows what was restored

**Examples:**
```fish
# Restore from latest backup
restore_fish_config

# Restore from specific snapshot
restore_fish_config fish-snapshot-agent-mod-2026-02-19_10:30:00

# Restore from specific commit
restore_fish_config abc1234
```

### snapshot_fish_config

Creates a tagged snapshot before making modifications (useful for agents).

```fish
snapshot_fish_config [snapshot-name]
```

- Creates a commit with descriptive name
- Creates a git tag for easy restoration
- Timestamped automatically
- Provides restore command for later use

**Examples:**
```fish
# Create snapshot before agent modifications
snapshot_fish_config agent-mod

# Create snapshot before manual changes
snapshot_fish_config before-cleanup
```

### list_fish_snapshots

Lists all available backups and snapshots.

```fish
list_fish_snapshots
```

- Shows all snapshot tags with dates
- Shows last 10 backup commits
- Provides restore instructions

### toggle_fish_autobackup

Enable/disable automatic daily backups.

```fish
toggle_fish_autobackup [enable|disable|status]
```

**Commands:**
- `enable` - Enable daily backup at 23:59
- `disable` - Disable automatic backup
- `status` - Check if auto-backup is enabled

**Examples:**
```fish
# Enable daily auto-backup
toggle_fish_autobackup enable

# Check status
toggle_fish_autobackup status

# Disable auto-backup
toggle_fish_autobackup disable
```

## What's Backed Up

✅ **Included:**
- `config.fish`
- `functions/*.fish`
- `conf.d/*.fish`
- `completions/*.fish`
- `personalized/*.fish`
- `hooks/*.fish` (excluding logs)
- `themes/`
- `fish_plugins`

❌ **Excluded (via .gitignore):**
- `fish_variables` (contains secrets and session state)
- `agent-state/` (agent temporary state)
- Any other files in `.gitignore`

## Auto-Backup Setup

The auto-backup system uses macOS launchd to run daily at 23:59.

**To enable:**
```fish
toggle_fish_autobackup enable
```

**Logs:**
- Output: `~/.config/fish/hooks/backup.log`
- Errors: `~/.config/fish/hooks/backup.error.log`

**To disable:**
```fish
toggle_fish_autobackup disable
```

## Agent Integration

Agents should create a pre-modification snapshot before making changes:

```fish
# Before agent modifications
snapshot_fish_config agent-<task-name>

# Make modifications...

# After modifications (optional manual backup)
backup_fish_config
```

## Typical Workflows

### Manual Backup
```fish
# Make some changes to fish config
# ...

# Backup the changes
backup_fish_config
```

### Before Agent Modifications
```fish
# Agent creates snapshot
snapshot_fish_config agent-component-5

# Agent makes changes
# ...

# If something goes wrong, restore
restore_fish_config fish-snapshot-agent-component-5-<timestamp>
```

### List and Restore
```fish
# See all available backups
list_fish_snapshots

# Restore from a specific snapshot
restore_fish_config fish-snapshot-before-cleanup-2026-02-19_15:30:00
```

### Daily Auto-Backup
```fish
# Enable once
toggle_fish_autobackup enable

# Your config is automatically backed up every day at 23:59
# No manual intervention needed
```

## Safety Features

1. **Protected Files**: `fish_variables` is never committed (contains sensitive data)
2. **Confirmation Prompts**: Restore asks for confirmation if there are uncommitted changes
3. **Non-Intrusive**: Backups don't interfere with your workflow
4. **Easy Recovery**: All snapshots are tagged for easy restoration
5. **Commit History**: Full git history shows all changes over time

## Troubleshooting

### "Not a git repository" error
Ensure `~/.config` is a git repository:
```fish
cd ~/.config
git status
```

### Auto-backup not running
Check launchd status:
```fish
toggle_fish_autobackup status
launchctl list | grep com.fish.autobackup
```

Check logs:
```fish
cat ~/.config/fish/hooks/backup.log
cat ~/.config/fish/hooks/backup.error.log
```

### Restore didn't work
List available snapshots:
```fish
list_fish_snapshots
```

Use the exact tag name or commit hash from the list.

## Notes

- All backup operations happen in `~/.config` git repository
- Backups are LOCAL only (not pushed to remote)
- You maintain full control over when and what to backup
- Agent operations create isolated snapshots for safety
