# Fish Shell Theme Showcase

Visual guide to all available themes.

---

## 🎨 Phenomenon (Default)

**Style**: Vibrant and eye-catching
**Best For**: Personal use, creative work

### Color Palette
```
Directory:  #BF409D (Magenta/Pink)
Git Info:   #3B82F6 (Blue)
Success:    #22C55E (Green)
Error:      #EF4444 (Red)
Time:       #14B8A6 (Teal)
Symbols:    #F43F5E (Pink/Red)
Normal:     #E5E5E5 (Light Gray)
```

### Sample Prompt
```
~/projects/myapp [main]± ✓ >
```

### Features
- Bold, vibrant colors
- Clear git status with ± indicator
- Success/error indicators (✓/✗)
- Command duration tracking (>5s)
- Clean time display [HH:MM]

---

## 🌫️ Minimal

**Style**: Clean and professional
**Best For**: Work environments, professional terminals

### Color Palette
```
Directory:  #5F9EA0 (Cadet Blue)
Git Info:   #708090 (Slate Gray)
Success:    #90EE90 (Light Green)
Error:      #CD5C5C (Indian Red)
Time:       #778899 (Light Slate Gray)
Symbols:    #696969 (Dim Gray)
Normal:     #D3D3D3 (Light Gray)
```

### Sample Prompt
```
~/projects/myapp (main)* →
```

### Features
- Subtle, muted colors
- Minimal visual noise
- Simple git indicators (*)
- Clean arrow prompt (→)
- Professional appearance

---

## 🌊 Ocean

**Style**: Calming and nature-inspired
**Best For**: Long coding sessions, relaxing atmosphere

### Color Palette
```
Directory:  #00CED1 (Dark Turquoise)
Git Info:   #4682B4 (Steel Blue)
Success:    #20B2AA (Light Sea Green)
Error:      #FF6347 (Tomato Red)
Time:       #40E0D0 (Turquoise)
Symbols:    #1E90FF (Dodger Blue)
Normal:     #B0E0E6 (Powder Blue)
```

### Sample Prompt
```
📂 ~/projects/myapp ⎇ main • ◉ ❯
```

### Features
- Ocean-inspired blue/teal colors
- Emoji indicators (📂 🕐 ⏱)
- Git branch symbol (⎇)
- Status dot (•) for changes
- Unicode arrows (❯)

---

## 🧛 Dracula

**Style**: Dark and sophisticated
**Best For**: Dark terminal themes, night coding

### Color Palette
```
Directory:  #BD93F9 (Purple)
Git Info:   #8BE9FD (Cyan)
Success:    #50FA7B (Green)
Error:      #FF5555 (Red)
Time:       #FFB86C (Orange)
Symbols:    #FF79C6 (Pink)
Normal:     #F8F8F2 (White)
```

### Sample Prompt
```
~/projects/myapp  main ● ✔ ❯
```

### Features
- Official Dracula color palette
- High contrast for dark backgrounds
- Git branch icon ()
- Clear status indicators (● ✔ ✘)
- Optimized for dark themes

---

## 🛠️ Custom (Template)

**Style**: Your choice!
**Best For**: Personal preferences, company branding

### Create Your Own
```fish
# 1. Copy template
cp ~/.config/fish/themes/template.fish ~/.config/fish/themes/mytheme.fish

# 2. Edit colors and symbols
nano ~/.config/fish/themes/mytheme.fish

# 3. Test it
theme_preview mytheme

# 4. Use it
theme_switch mytheme
```

### Customizable Elements
- All 7 color values
- Prompt symbols (>, →, ❯, etc.)
- Git indicators (±, *, •, etc.)
- Success/error symbols (✓/✗, ✔/✘, etc.)
- Time format
- Directory format
- Additional components

---

## 📊 Quick Comparison

| Feature           | Phenomenon | Minimal | Ocean   | Dracula |
|-------------------|-----------|---------|---------|---------|
| **Brightness**    | High      | Low     | Medium  | High    |
| **Contrast**      | High      | Medium  | Medium  | Very High |
| **Emojis**        | No        | No      | Yes     | No      |
| **Git Detail**    | High      | Low     | Medium  | High    |
| **Best Theme**    | Light     | Any     | Light   | Dark    |
| **Mood**          | Energetic | Calm    | Relaxed | Focused |

---

## 🎯 Choosing Your Theme

### By Environment
- **Personal Projects**: Phenomenon, Ocean
- **Professional Work**: Minimal, Dracula
- **Long Sessions**: Ocean, Minimal
- **Dark Terminal**: Dracula
- **Light Terminal**: Phenomenon, Ocean

### By Personality
- **Bold & Vibrant**: Phenomenon
- **Clean & Simple**: Minimal
- **Nature Lover**: Ocean
- **Dark Mode Fan**: Dracula

### By Time of Day
- **Morning**: Minimal (clean start)
- **Afternoon**: Phenomenon (energy boost)
- **Evening**: Ocean (wind down)
- **Night**: Dracula (easy on eyes)

---

## 💡 Pro Tips

### Quick Switch
```fish
# Save your favorites as abbreviations
abbr -a tmin 'theme_switch minimal'
abbr -a tphe 'theme_switch phenomenon'
abbr -a toce 'theme_switch ocean'
abbr -a tdra 'theme_switch dracula'
```

### Preview All
```fish
# Preview each theme before choosing
for theme in phenomenon minimal ocean dracula
    theme_preview $theme
    read -P "Press Enter for next theme..."
end
```

### Context-Based Switching
```fish
# Add to config.fish for auto-switching
if test (date +%H) -lt 18
    theme_switch minimal  # Day theme
else
    theme_switch dracula  # Night theme
end
```

---

## 🎨 Color Inspiration

### For Custom Themes

**Warm Themes**
- Sunset: Orange (#FF8800), Purple (#8800FF), Pink (#FF69B4)
- Autumn: Brown (#8B4513), Orange (#FF8800), Yellow (#FFD700)
- Fire: Red (#FF0000), Orange (#FF4500), Yellow (#FFFF00)

**Cool Themes**
- Forest: Green (#228B22), Brown (#8B4513), Blue (#87CEEB)
- Arctic: White (#FFFFFF), Blue (#4682B4), Cyan (#00FFFF)
- Night: Navy (#000080), Purple (#800080), Black (#000000)

**Monochrome Themes**
- Grayscale: Shades of gray from #FFFFFF to #000000
- Sepia: Browns and tans (#F4A460, #DEB887, #D2B48C)
- Blue Only: Different blues (#191970, #4169E1, #87CEEB)

---

## 🚀 Installation & Usage

### Quick Start
```fish
# List themes
theme_list

# Preview a theme
theme_preview ocean

# Switch to a theme
theme_switch ocean

# Check current theme
theme_current
```

### Full Documentation
See `/Users/davidsamuel.nechifor/.config/fish/themes/README.md` for complete guide.

---

**Enjoy customizing your Fish shell experience!**
