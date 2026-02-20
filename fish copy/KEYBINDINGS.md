# Fish Shell Keybindings Reference

Complete guide to custom keybindings configured in `conf.d/05-keybindings.fish`

## Quick Reference Card

### Editor Integration
| Keybinding | Action |
|------------|--------|
| `Alt+E` | Edit current command in $EDITOR |
| `Ctrl+X Ctrl+E` | Edit current command in $EDITOR (alternative) |

### Command Modification
| Keybinding | Action |
|------------|--------|
| `Alt+S` | Prepend/toggle 'sudo' to current command |
| `Alt+.` | Insert last argument from previous command |

### Clipboard Integration (macOS)
| Keybinding | Action |
|------------|--------|
| `Ctrl+X Ctrl+C` | Copy current command to clipboard |
| `Ctrl+X Ctrl+V` | Paste from clipboard to command line |

### Navigation
| Keybinding | Action |
|------------|--------|
| `Alt+B` | Move backward one word |
| `Alt+F` | Move forward one word |
| `Ctrl+Left` | Move backward one word (terminal-specific) |
| `Ctrl+Right` | Move forward one word (terminal-specific) |
| `Ctrl+A` | Move to beginning of line (default) |
| `Ctrl+E` | Move to end of line (default) |

### History
| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Search command history interactively |
| `Alt+P` | Previous command starting with current input |
| `Alt+N` | Next command starting with current input |
| `Up` | Navigate to previous command |
| `Down` | Navigate to next command |

### Directory Navigation
| Keybinding | Action |
|------------|--------|
| `Alt+Up` | Go to parent directory (cd ..) |
| `Alt+Left` | Go to previous directory (cd -) |

### Screen Management
| Keybinding | Action |
|------------|--------|
| `Ctrl+L` | Clear screen and scrollback buffer |

---

## Enabling Vim Mode

Vim mode is **disabled by default** to avoid conflicts with system keybindings.

### To Enable Vim Mode:

Add this line to your `~/.config/fish/config.fish` **before** the conf.d files are sourced:

```fish
set -g FISH_VIM_MODE 1
```

### Vim Mode Indicators:

When vim mode is enabled, you'll see mode indicators in your prompt:
- `[N]` = Normal mode (red)
- `[I]` = Insert mode (green)
- `[V]` = Visual mode (magenta)
- `[R]` = Replace mode (yellow)

### Vim Mode Cursor Shapes:

- **Normal mode**: Block cursor
- **Insert mode**: Line cursor
- **Replace mode**: Underscore cursor
- **Visual mode**: Block cursor

### Vim Mode Keybindings:

All custom keybindings work in **Insert mode**. In **Normal mode**, you have access to:
- Standard vim navigation (h, j, k, l)
- `Alt+E` and `Alt+S` for editor and sudo functions

---

## Usage Examples

### Edit Command in Editor
```
# Type a long command
docker run -it --rm -v $(pwd):/app node:18 npm install

# Press Alt+E to open in your $EDITOR
# Edit, save, and close editor
# Command is automatically updated
```

### Quick Sudo Toggle
```
# Type command without sudo
apt update

# Press Alt+S to prepend sudo
sudo apt update

# Press Alt+S again to remove sudo
apt update
```

### Insert Last Argument
```
# Previous command
mv /very/long/path/to/file.txt /destination/

# New command
cd <Alt+.>

# Result
cd /destination/
```

### Copy Command for Documentation
```
# Type a complex command
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 22 output.mp4

# Press Ctrl+X Ctrl+C to copy to clipboard
# Now paste into documentation
```

### Quick Parent Directory Navigation
```
# Currently in: /Users/davidsamuel.nechifor/.config/fish/conf.d/

# Press Alt+Up
# Now in: /Users/davidsamuel.nechifor/.config/fish/

# Press Alt+Up again
# Now in: /Users/davidsamuel.nechifor/.config/

# Press Alt+Left to go back
# Now in: /Users/davidsamuel.nechifor/.config/fish/
```

### History Prefix Search
```
# Type beginning of command
git

# Press Alt+P to cycle through previous git commands
# Press Alt+N to go forward through git commands
```

---

## Configuration

### Setting Default Editor

The `Alt+E` and `Ctrl+X Ctrl+E` keybindings use your `$EDITOR` environment variable. Set it in `config.fish`:

```fish
set -gx EDITOR nvim          # Use Neovim
set -gx EDITOR vim           # Use Vim
set -gx EDITOR nano          # Use Nano
set -gx EDITOR code --wait   # Use VS Code
```

If `$EDITOR` is not set, it defaults to `vim`.

### Customizing Keybindings

To add your own keybindings or modify existing ones, edit:
```
~/.config/fish/conf.d/05-keybindings.fish
```

Then reload fish:
```fish
source ~/.config/fish/config.fish
```

Or open a new terminal.

---

## Platform-Specific Notes

### macOS
- Clipboard integration (`pbcopy`/`pbpaste`) works out of the box
- `Ctrl+L` clears screen and scrollback using Terminal.app escape codes
- Alt key may need to be configured in Terminal preferences:
  - **Terminal.app**: Preferences → Profiles → Keyboard → "Use Option as Meta key"
  - **iTerm2**: Preferences → Profiles → Keys → "Left/Right Option Key: Esc+"

### Linux
- Clipboard keybindings require modification to use `xclip` or `xsel`
- Alt key typically works as Meta key by default

---

## Troubleshooting

### Alt Key Not Working
- Check terminal emulator settings for "Use Option as Meta key" or similar
- Try using Escape key instead: `Esc` then `e` instead of `Alt+E`

### Keybinding Conflicts
- Some terminal emulators intercept certain key combinations
- Check terminal preferences and disable conflicting shortcuts
- Modify keybindings in `05-keybindings.fish` to use different combinations

### Vim Mode Issues
- Ensure `set -g FISH_VIM_MODE 1` is set **before** conf.d files load
- Some keybindings may need to be rebound for specific vim modes
- Check mode indicator appears in prompt

### Editor Not Opening
- Verify `$EDITOR` is set correctly: `echo $EDITOR`
- Ensure editor is in your `$PATH`: `which vim`
- Test editor manually: `vim test.txt`

---

## Advanced Customization

### Create Your Own Helper Functions

Add to `05-keybindings.fish`:

```fish
# Custom function to run command with timing
function __fish_run_with_time
    commandline -f execute
    echo "Command executed at: "(date)
end

bind \et __fish_run_with_time  # Alt+T
```

### Bind Multiple Actions

```fish
# Clear, list directory, and repaint
bind \ca 'clear; ls -la; commandline -f repaint'
```

### Context-Aware Keybindings

```fish
# Smart enter: run command or insert newline if incomplete
function __fish_smart_enter
    if commandline --is-valid
        commandline -f execute
    else
        commandline -i \n
    end
end

bind \cm __fish_smart_enter  # Ctrl+M
```

---

## Reference

- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Fish Key Bindings](https://fishshell.com/docs/current/cmds/bind.html)
- [Fish Default Keybindings](https://fishshell.com/docs/current/interactive.html#shared-bindings)

---

**Created**: 2026-02-19
**Location**: `/Users/davidsamuel.nechifor/.config/fish/conf.d/05-keybindings.fish`
**Documentation**: `/Users/davidsamuel.nechifor/.config/fish/KEYBINDINGS.md`
