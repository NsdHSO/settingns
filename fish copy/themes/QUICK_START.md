# Theme System Quick Start Guide

## 🚀 Getting Started

### View Available Themes
```fish
theme_list
```

### Switch Theme
```fish
theme_switch minimal      # Switch to minimal theme
theme_switch ocean        # Switch to ocean theme
theme_switch dracula      # Switch to dracula theme
theme_switch phenomenon   # Switch back to default
```

### Preview Before Switching
```fish
theme_preview ocean       # See what ocean theme looks like
```

### Check Current Theme
```fish
theme_current            # Show active theme and colors
```

## 🎨 Built-in Themes

| Theme       | Style      | Description                                    |
|-------------|------------|------------------------------------------------|
| phenomenon  | Vibrant    | Pink/magenta accents (default)                 |
| minimal     | Clean      | Subtle colors, professional look               |
| ocean       | Calming    | Blue/teal ocean-inspired                       |
| dracula     | Dark       | Dracula color palette                          |

## 🛠️ Create Your Own Theme

### Quick Method
```fish
# 1. Copy template
cp ~/.config/fish/themes/template.fish ~/.config/fish/themes/mytheme.fish

# 2. Edit the file
nano ~/.config/fish/themes/mytheme.fish

# 3. Change these things:
#    - Theme name and description
#    - Color values (6-digit hex codes)
#    - Replace 'yourtheme_' with 'mytheme_'
#    - Customize symbols if desired

# 4. Test it
theme_preview mytheme

# 5. Use it
theme_switch mytheme
```

## 📋 Color Code Examples

Common colors you can use:

```
Red:       FF0000
Green:     00FF00
Blue:      0000FF
Yellow:    FFFF00
Cyan:      00FFFF
Magenta:   FF00FF
Orange:    FF8800
Purple:    8800FF
Pink:      FF69B4
Teal:      008080
```

## 🔧 Customization Tips

### Change Prompt Symbol
In your theme file, find:
```fish
echo -n " > "
```
Replace `>` with: `→` `❯` `➜` `⇒` or any symbol you like

### Change Success/Error Symbols
Find:
```fish
echo -n " ✓"    # Success
echo -n " ✗"    # Error
```
Replace with your preferred symbols

### Add Emoji (Optional)
```fish
echo -n "🚀 "   # Before prompt
echo -n "📁 "   # Before directory
```

## ⚡ Pro Tips

1. **Persistent Changes**: Theme switches are saved automatically
2. **Apply Immediately**: Run `exec fish` after switching themes
3. **Multiple Terminals**: All new terminals will use the selected theme
4. **Safe Testing**: Use `theme_preview` to test before committing

## 🆘 Common Issues

**Theme doesn't change?**
```fish
exec fish  # Restart Fish shell
```

**Colors look wrong?**
- Make sure terminal supports true color
- Check hex codes are 6 digits (no # symbol)

**Want to reset?**
```fish
theme_switch phenomenon  # Back to default
```

## 📚 More Information

For detailed documentation, see: `~/.config/fish/themes/README.md`

---

**Quick Commands Summary:**
- `theme_list` - Show all themes
- `theme_switch <name>` - Change theme
- `theme_preview <name>` - Test theme
- `theme_current` - Show active theme
