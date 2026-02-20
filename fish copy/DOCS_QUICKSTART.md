# Documentation System - Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Generate Documentation
```fish
generate_docs
```

This creates:
- 📄 `README.md` - Complete function reference
- 📁 `docs/*.md` - Individual function documentation
- ⌨️ `KEYBINDINGS.md` - Keyboard shortcuts reference

### 2. View Documentation
```fish
# View all functions
docs

# View specific function
docs gc
docs killport
docs yas

# View keybindings
docs -k
```

### 3. Keep It Updated
```fish
# Auto-update when functions change
auto_update_docs

# Or watch for changes in real-time
docs_watch
```

## 📋 Common Commands

| Command | What It Does |
|---------|--------------|
| `generate_docs` | Create/update all documentation |
| `docs` | View main documentation |
| `docs <name>` | View specific function docs |
| `docs -l` | List all documented functions |
| `docs -k` | View keybindings reference |
| `auto_update_docs` | Update docs if functions changed |
| `docs_watch` | Auto-regenerate on file changes |

## 💡 Pro Tips

### Add to Shell Startup
Add to `~/.config/fish/config.fish`:
```fish
# Auto-update docs on startup
if status is-interactive
    auto_update_docs
end
```

### Better Viewing
Install `bat` for syntax highlighting:
```fish
brew install bat
```

### Watch Mode
Install `fswatch` for live updates:
```fish
brew install fswatch
docs_watch
```

### Document New Functions
When creating functions, add a description:
```fish
function my_func --description "What it does"
    # your code
end
```

Then regenerate:
```fish
generate_docs
```

### Add Docs to Existing Functions
```fish
add_function_docs gc "Create conventional commits with emoji"
```

## 📖 What Gets Documented

### Included
- ✅ All custom functions in `functions/`
- ✅ Git functions (gc, gis, gio, etc.)
- ✅ Node/Yarn functions (yas, yall, ylock, etc.)
- ✅ Navigation functions (., .., ..., etc.)
- ✅ Utility functions (killport, etc.)

### Excluded
- ❌ Internal functions (starting with `_`)
- ❌ NVM functions (framework-specific)
- ❌ Fisher functions (package manager)

## 🎯 Quick Examples

### Example 1: View Git Commands
```fish
docs | grep -A 5 "Git Functions"
```

### Example 2: Search for Specific Function
```fish
docs -l | grep kill
# Then view it:
docs killport
```

### Example 3: Update After Adding Function
```fish
# Create new function
echo 'function hello --description "Say hello"
    echo "Hello, World!"
end' > ~/.config/fish/functions/hello.fish

# Update docs
generate_docs

# View it
docs hello
```

## 📂 File Locations

```
~/.config/fish/
├── README.md              ← Main documentation
├── KEYBINDINGS.md         ← Keyboard shortcuts
├── DOCUMENTATION_USAGE.md ← Detailed guide
├── DOCS_QUICKSTART.md     ← This file
└── docs/                  ← Individual function docs
    ├── gc.md
    ├── killport.md
    └── ...
```

## ⚡ Performance

- Generation time: **< 1 second** for ~90 functions
- Auto-update: Only runs when files actually change
- Minimal startup impact
- Fast viewing with `bat`

## 🔧 Troubleshooting

### No documentation generated?
```fish
# Check if directory exists
ls ~/.config/fish/functions/

# Regenerate
generate_docs
```

### Can't view docs?
```fish
# Install bat for better viewing
brew install bat

# Or use basic view
cat ~/.config/fish/README.md
```

### Auto-update not working?
```fish
# Check timestamp
cat ~/.config/fish/.docs_timestamp

# Force update
generate_docs
```

## 📚 Learn More

- **Full Guide**: `cat ~/.config/fish/DOCUMENTATION_USAGE.md`
- **Implementation**: `cat ~/.config/fish/COMPONENT_19_SUMMARY.md`
- **Function Help**: `docs --help`

## 🎨 Example Output

When you run `generate_docs`, you'll see:
```
📚 Generating Fish Shell Documentation...
========================================
📊 Found 85 custom functions
📝 Generating Git Functions documentation...
  ✓ Documented: gc
  ✓ Documented: gis
  ✓ Documented: gio
  ...
📝 Generating Node/Package Manager Functions documentation...
  ✓ Documented: yas
  ✓ Documented: yall
  ...
⌨️  Generated keybindings reference
========================================
✅ Documentation generation complete!

📄 Main documentation: ~/.config/fish/README.md
📁 Function docs: ~/.config/fish/docs/
⌨️  Keybindings: ~/.config/fish/KEYBINDINGS.md
```

## ✨ That's It!

You now have a complete, self-updating documentation system for all your Fish functions.

**Next Steps:**
1. Run `generate_docs`
2. View with `docs`
3. Keep updated with `auto_update_docs`

---

**Generated:** 2026-02-19
**Component:** 19 - Automatic Documentation
