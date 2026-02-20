# Zoxide Smart Navigation Guide

## Overview
Zoxide is an intelligent directory navigation tool that learns your most frequently and recently used directories. It replaces traditional `cd` with a smarter alternative that gets you where you want to go with minimal typing.

## Installation Status
✓ Zoxide is installed and initialized in `/Users/davidsamuel.nechifor/.config/fish/conf.d/01-tools.fish`

## Basic Commands

### Core Zoxide Commands

#### `z <query>`
Jump to a directory matching the query. Zoxide uses frecency (frequency + recency) to pick the best match.

```fish
# Examples:
z docs          # Jump to ~/Documents or any frequently used directory containing "docs"
z proj web      # Jump to a directory matching both "proj" and "web"
z -             # Jump to previous directory (like cd -)
```

#### `zi`
Interactive directory selection with fzf (fuzzy finder).

```fish
zi              # Opens interactive menu to browse and select from your most used directories
                # Features:
                # - Live preview of directory contents
                # - Fuzzy search
                # - Ctrl-/ to toggle preview
```

### Zoxide Management Commands

#### `zl [query]`
List zoxide tracked directories with their frecency scores.

```fish
zl              # List all tracked directories with scores
zl project      # List only directories matching "project"
```

#### `zr <path>`
Remove a directory from zoxide database.

```fish
zr /old/path    # Remove specific path from tracking
```

#### `zc`
Clean up invalid paths from zoxide database (removes non-existent directories).

```fish
zc              # Automatically finds and removes deleted directories from database
```

## Project Shortcuts

These are custom shortcuts for quick navigation to common locations:

### `zp [project-name]`
Jump to project directories. Searches in:
- `~/projects`
- `~/work`
- `~/dev`
- `~/code`
- `~/Documents/projects`
- `~/workspace`

```fish
zp              # List all available projects
zp myapp        # Jump to project matching "myapp"
```

### Quick Directory Shortcuts

```fish
zconf           # Jump to ~/.config
zhome           # Jump to $HOME
zdl             # Jump to ~/Downloads
zdocs           # Jump to ~/Documents
```

## How Zoxide Learns

Zoxide automatically tracks every directory you `cd` into and builds a database of:
- **Frequency**: How often you visit each directory
- **Recency**: How recently you visited each directory
- **Frecency**: A smart combination of both

The more you use directories, the higher they rank in zoxide's database.

## Integration with Other Tools

### Works With
- **fzf**: Powers the interactive `zi` command
- **eza**: Directory previews show with modern ls output
- **Fish shell**: Native Fish completion support

### Does NOT Conflict With
- Standard `cd` command still works normally
- All existing navigation patterns remain functional

## Tips and Best Practices

1. **Start Using `z` Instead of `cd`**
   ```fish
   # Old way:
   cd ~/Documents/projects/my-app

   # New way:
   z my-app
   ```

2. **Use Interactive Mode When Unsure**
   ```fish
   zi              # Browse and select visually
   ```

3. **Clean Database Periodically**
   ```fish
   zc              # Remove deleted directories
   ```

4. **Check Your Most Used Directories**
   ```fish
   zl | head -20   # See your top 20 directories
   ```

5. **Combine with Other Tools**
   ```fish
   z myproject && code .        # Jump and open in VS Code
   zi && ls -la                 # Interactive jump and list files
   ```

## Advanced Usage

### Query Syntax
```fish
z foo           # Matches any directory with "foo" in the path
z foo bar       # Matches directories with both "foo" AND "bar"
z foo/bar       # Prefer exact path match
```

### Direct Query (No Jump)
```fish
zoxide query foo        # Show what directory would be selected
zoxide query -l foo     # List all matches for "foo"
zoxide query -l -s      # List all directories with scores
```

### Add Directory Without Visiting
```fish
zoxide add /some/path   # Manually add a directory to database
```

## Troubleshooting

### Zoxide Selects Wrong Directory
```fish
# Solution 1: Be more specific
z proj web backend

# Solution 2: Use interactive mode
zi

# Solution 3: Remove the unwanted match
zr /unwanted/path

# Solution 4: Use exact path once to boost its score
cd /correct/path
```

### Database Gets Cluttered
```fish
# Clean up deleted directories
zc

# Or manually remove specific entries
zr /old/path
```

### Zoxide Not Working
```fish
# Check if zoxide is installed
which zoxide

# Restart your shell
exec fish

# Check initialization
cat ~/.config/fish/conf.d/01-tools.fish | grep zoxide
```

## Files Created

1. **Configuration**
   - `/Users/davidsamuel.nechifor/.config/fish/conf.d/01-tools.fish` - Zoxide initialization

2. **Functions**
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zi.fish` - Interactive selection
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zl.fish` - List directories
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zr.fish` - Remove directory
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zc.fish` - Clean database
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zp.fish` - Project shortcuts
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zconf.fish` - Config shortcut
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zhome.fish` - Home shortcut
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zdl.fish` - Downloads shortcut
   - `/Users/davidsamuel.nechifor/.config/fish/functions/zdocs.fish` - Documents shortcut

## Quick Reference Card

| Command | Description |
|---------|-------------|
| `z foo` | Jump to directory matching "foo" |
| `zi` | Interactive directory selection |
| `z -` | Jump to previous directory |
| `zl` | List all tracked directories |
| `zl foo` | List directories matching "foo" |
| `zr path` | Remove path from database |
| `zc` | Clean invalid paths |
| `zp` | List all projects |
| `zp name` | Jump to project matching "name" |
| `zconf` | Jump to ~/.config |
| `zhome` | Jump to home |
| `zdl` | Jump to Downloads |
| `zdocs` | Jump to Documents |

---

**Note**: Zoxide becomes more accurate the more you use it. Give it a few days to learn your patterns for the best experience!
