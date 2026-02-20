# Session Management Quick Reference

## Save/Restore Sessions

```fish
# Save current session
session_save                    # Uses directory name
session_save my-project         # Custom name

# Restore session
session_restore my-project      # Full restore
session_restore --no-cd proj    # Don't change directory

# List sessions
session_list                    # Simple list
session_list -l                 # Detailed view

# Delete session
session_delete old-project      # With confirmation
session_delete -f old-project   # Force delete
```

## Templates

```fish
# List templates
session_template -l

# Apply template
session_template -a nodejs      # Node.js environment
session_template -a python      # Python environment
session_template -a rust        # Rust environment
session_template -a web-dev     # Web development

# Create custom template
session_template -c mytemplate
```

## Auto-Save

```fish
# Enable auto-save on exit
session_autosave_enable

# Set auto-save session name
session_autosave_name daily-work

# Disable auto-save
session_autosave_disable
```

## Advanced

```fish
# Compare session with current state
session_diff my-project

# Export to bash script
session_export -n proj -f bash -o setup.sh

# Export to JSON
session_export -n proj -f json
```

## Quick Workflows

### Daily Routine
```fish
# Morning
session_restore daily-work

# Evening
session_save daily-work
```

### Project Switching
```fish
session_save current-project
cd ~/other-project
session_restore other-project
```

### Team Onboarding
```fish
session_export -n setup -f bash -o team-setup.sh
# Share team-setup.sh with team
```

## What Gets Saved

- Working directory
- Environment variables (non-sensitive)
- Command history (last 50)
- Git branch
- Tmux session info
- Custom data (via hooks)

## Storage Location

```
~/.config/fish/sessions/
├── <name>.session              # Your sessions
└── templates/                  # Session templates
    ├── nodejs.template
    ├── python.template
    ├── rust.template
    └── web-dev.template
```

## Security

Auto-filtered sensitive variables:
- PASSWORD, TOKEN, SECRET, KEY
- API, CREDENTIALS, AUTH
- Fish internal variables (_*, FISH_*)

## Tips

1. Name sessions descriptively: `frontend-auth-feature`
2. Save before major changes: `session_save before-refactor`
3. Use templates for new projects
4. Create aliases for frequent sessions
5. Use `session_diff` to see what changed
