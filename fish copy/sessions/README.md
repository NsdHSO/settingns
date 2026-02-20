# Fish Shell Session Management

Complete session management system for saving, restoring, and managing terminal sessions.

## Features

- Save and restore terminal sessions with all context
- Project-based session templates
- Auto-save on shell exit (optional)
- Session comparison and export
- Secure handling of sensitive data

## Commands

### Core Functions

#### `session_save [name]`
Save current session state including working directory, environment variables, and command history.

**Options:**
- `-n, --name <name>` - Session name (defaults to current directory name)
- `-a, --auto` - Mark as auto-saved (used internally)

**Examples:**
```fish
# Save current session with directory name
session_save

# Save with custom name
session_save my-project

# Save with explicit name flag
session_save -n backend-dev
```

#### `session_restore <name>`
Restore a previously saved session.

**Options:**
- `-n, --name <name>` - Session name to restore
- `--no-cd` - Don't change to saved directory

**Examples:**
```fish
# Restore session
session_restore my-project

# Restore without changing directory
session_restore --no-cd my-project
```

#### `session_list`
List all available saved sessions.

**Options:**
- `-l, --long` - Show detailed information
- `-j, --json` - Output in JSON format

**Examples:**
```fish
# Simple list
session_list

# Detailed view with metadata
session_list -l

# JSON output for scripting
session_list -j
```

#### `session_delete <name>`
Delete a saved session.

**Options:**
- `-n, --name <name>` - Session name to delete
- `-f, --force` - Skip confirmation prompt

**Examples:**
```fish
# Delete with confirmation
session_delete old-project

# Delete without confirmation
session_delete -f old-project
```

### Advanced Functions

#### `session_diff <name>`
Compare saved session with current state.

**Examples:**
```fish
session_diff my-project
```

#### `session_export <name>`
Export session to portable format (bash, zsh, or JSON).

**Options:**
- `-n, --name <name>` - Session name to export
- `-f, --format <format>` - Output format (bash, zsh, json)
- `-o, --output <file>` - Output file path

**Examples:**
```fish
# Export to bash script
session_export -n my-project -f bash -o setup.sh

# Export to JSON
session_export -n my-project -f json

# Export to zsh
session_export -n my-project -f zsh -o setup.zsh
```

### Templates

#### `session_template`
Create and use session templates for different project types.

**Options:**
- `-l, --list` - List available templates
- `-c, --create <name>` - Create new template
- `-a, --apply <name>` - Apply a template

**Examples:**
```fish
# List templates
session_template -l

# Create new template
session_template -c django-project

# Apply template
session_template -a nodejs
```

**Built-in Templates:**
- `nodejs` - Node.js development environment
- `python` - Python development environment
- `rust` - Rust development environment
- `web-dev` - Full-stack web development

### Auto-Save

#### `session_autosave_enable`
Enable automatic session saving on shell exit.

#### `session_autosave_disable`
Disable automatic session saving.

#### `session_autosave_name <name>`
Set default session name for auto-save.

**Examples:**
```fish
# Enable auto-save
session_autosave_enable

# Set auto-save name
session_autosave_name my-daily-session

# Disable auto-save
session_autosave_disable
```

## What Gets Saved

### Included:
- Current working directory
- Environment variables (non-sensitive)
- Recent command history (last 50 commands)
- Git branch information
- Tmux session info (if applicable)
- Custom session data (via hooks)

### Excluded (Security):
Variables containing these keywords are automatically filtered:
- PASSWORD
- TOKEN
- SECRET
- KEY
- API
- CREDENTIALS
- AUTH

Also excluded:
- Fish internal variables (_*)
- Shell system variables (FISH_*)

## Storage

Sessions are stored in:
```
~/.config/fish/sessions/
├── <session-name>.session      # Saved sessions
└── templates/
    ├── nodejs.template         # Built-in templates
    ├── python.template
    ├── rust.template
    └── web-dev.template
```

## Workflows

### Daily Development Workflow
```fish
# Morning: Restore yesterday's session
session_restore my-project

# Work on your project...

# Evening: Save current state
session_save my-project
```

### Project Switching
```fish
# Save current project
session_save frontend-app

# Switch to another project
cd ~/projects/backend-api
session_restore backend-api

# Or start fresh with template
session_template -a nodejs
```

### Team Collaboration
```fish
# Export session for team member
session_export -n project-setup -f bash -o team-setup.sh

# Share team-setup.sh with your team
# They can run: bash team-setup.sh
```

### Custom Hooks

Create custom functions for advanced session management:

**session_save_custom** - Called during save to add custom data
```fish
function session_save_custom
    echo "# My Custom Data"
    echo "set -l custom_var 'my_value'"
end
```

**session_restore_custom** - Called during restore to handle custom data
```fish
function session_restore_custom
    if set -q custom_var
        echo "Restoring custom data: $custom_var"
    end
end
```

## Tips

1. **Naming Sessions**: Use descriptive names that include project and context
   ```fish
   session_save frontend-feature-auth
   session_save backend-bugfix-api
   ```

2. **Regular Backups**: Save sessions before major changes
   ```fish
   session_save before-refactor
   # Make changes...
   session_save after-refactor
   ```

3. **Template Customization**: Edit templates to match your workflow
   ```fish
   edit ~/.config/fish/sessions/templates/nodejs.template
   ```

4. **Session Comparison**: Check what changed since last save
   ```fish
   session_diff my-project
   ```

5. **Quick Switching**: Create aliases for common sessions
   ```fish
   alias work-front='session_restore frontend-app'
   alias work-back='session_restore backend-api'
   ```

## Troubleshooting

### Session won't restore directory
- Check if directory still exists
- Use `--no-cd` flag to restore without changing directory

### Missing environment variables
- Ensure variables aren't filtered as sensitive
- Check session file: `~/.config/fish/sessions/<name>.session`

### Auto-save not working
- Verify it's enabled: `set -g SESSION_AUTOSAVE_ENABLED`
- Check Fish exit hooks: `functions --details __session_autosave_on_exit`

## Examples

### Complete Development Session
```fish
# Start new project
cd ~/projects/new-app
session_template -a nodejs

# Work on the project...
# Install dependencies, start servers, etc.

# Save everything before lunch
session_save new-app-dev

# After lunch, restore
session_restore new-app-dev

# Compare what changed
session_diff new-app-dev

# End of day: save and export for tomorrow
session_save new-app-dev
session_export -n new-app-dev -f bash -o daily-setup.sh
```

### Multiple Project Juggling
```fish
# Save current work
session_save project-a

# Quick fix on another project
cd ~/projects/project-b
session_restore project-b

# Back to main project
cd ~/projects/project-a
session_restore project-a
```

## Integration with Other Tools

### Tmux
Sessions automatically detect and save tmux session info. Combine with tmux session management for full workspace restoration.

### Git
Git branch information is saved and displayed on restore, helping you track which branch you were working on.

### Project-Specific State
Create `.project_state` file in your project directory for custom project initialization that runs on session restore.

---

For more information, see individual function help:
```fish
session_save --help
session_restore --help
session_list --help
```
