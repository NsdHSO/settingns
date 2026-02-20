# Fish Shell Theme Management System

A comprehensive theme management framework for Fish shell that allows easy theme switching and custom theme creation.

## Directory Structure

```
~/.config/fish/
├── themes/                    # Theme files directory
│   ├── phenomenon.fish       # Default theme (vibrant pink/magenta)
│   ├── minimal.fish          # Clean minimalist theme
│   ├── ocean.fish            # Ocean-inspired blue/teal theme
│   ├── dracula.fish          # Dark Dracula-inspired theme
│   ├── template.fish         # Template for creating custom themes
│   └── README.md             # This file
├── conf.d/
│   └── 00-theme.fish         # Theme loader (loads before prompt)
└── functions/
    ├── theme_switch.fish     # Switch between themes
    ├── theme_list.fish       # List available themes
    ├── theme_preview.fish    # Preview themes without switching
    └── theme_current.fish    # Show current theme info
```

## Available Commands

### `theme_list`
List all available themes with descriptions.

```fish
theme_list
```

Output:
```
Available themes:

  * phenomenon (active)
      Vibrant theme with pink/magenta accents and comprehensive git status
    minimal
      Clean and minimal theme with subtle colors
    ocean
      Calming ocean-inspired theme with blue and teal tones
    dracula
      Dark theme inspired by Dracula color palette

To switch themes: theme_switch <theme_name>
To preview a theme: theme_preview <theme_name>
```

### `theme_switch <theme_name>`
Switch to a different theme permanently.

```fish
theme_switch minimal
```

The theme preference is saved and will persist across all terminal sessions.

### `theme_preview <theme_name>`
Preview a theme without actually switching to it.

```fish
theme_preview ocean
```

This shows sample prompts with the new theme and then restores your current theme.

### `theme_current`
Display information about the currently active theme.

```fish
theme_current
```

Shows the theme name, description, and color palette.

## Built-in Themes

### Phenomenon (Default)
- **Style**: Vibrant and modern
- **Colors**: Pink/magenta accents, blue git info, green success, red errors
- **Best for**: Users who like colorful, eye-catching prompts
- **Features**: Comprehensive git status, command duration tracking

### Minimal
- **Style**: Clean and subtle
- **Colors**: Muted blues, grays, and subtle greens
- **Best for**: Users who prefer understated, professional-looking prompts
- **Features**: Simple git indicators, minimal visual noise

### Ocean
- **Style**: Calming and nature-inspired
- **Colors**: Turquoise, teal, and various shades of blue
- **Best for**: Users who like ocean/water themes
- **Features**: Unicode symbols, emoji indicators

### Dracula
- **Style**: Dark and sophisticated
- **Colors**: Official Dracula color palette (purple, cyan, pink, green)
- **Best for**: Users of Dracula terminal themes who want matching prompts
- **Features**: High contrast, dark-theme optimized

## Creating Custom Themes

### Step 1: Copy the Template

```fish
cp ~/.config/fish/themes/template.fish ~/.config/fish/themes/mytheme.fish
```

### Step 2: Edit Your Theme

Open the file in your editor:

```fish
nano ~/.config/fish/themes/mytheme.fish
```

### Step 3: Customize

Replace the following elements:

1. **Theme metadata** (lines 4-6):
   ```fish
   set -l theme_name "MyTheme"
   set -l theme_author "Your Name"
   set -l theme_description "Description of your theme"
   ```

2. **Color definitions** (use hex colors without #):
   ```fish
   set -g mytheme_directory FF5733    # Your color
   set -g mytheme_git_info 3498DB     # Your color
   # ... etc
   ```

3. **Variable prefix**: Replace all instances of `yourtheme_` with `mytheme_`

4. **Symbols and format**: Customize prompt symbols, git indicators, etc.

### Step 4: Test Your Theme

Preview your theme:
```fish
theme_preview mytheme
```

If you're happy with it, switch to it:
```fish
theme_switch mytheme
```

## Theme Anatomy

Each theme file contains:

### 1. Color Variables
Define all colors used in the prompt:
```fish
set -g themename_directory RRGGBB
set -g themename_git_info RRGGBB
set -g themename_success RRGGBB
set -g themename_error RRGGBB
set -g themename_time RRGGBB
set -g themename_symbols RRGGBB
set -g themename_normal RRGGBB
```

### 2. Helper Functions
- `_git_status_info`: Display git branch and status
- `_print_pwd`: Display current directory path

### 3. Prompt Functions
- `fish_prompt`: Main left-side prompt
- `fish_right_prompt`: Right-side prompt (time, duration)
- `pre_exec`: Event handler for command timing

## Color Codes

Colors are specified using 6-digit hex codes (RRGGBB format):
- Red: `FF0000`
- Green: `00FF00`
- Blue: `0000FF`
- Yellow: `FFFF00`
- Cyan: `00FFFF`
- Magenta: `FF00FF`
- White: `FFFFFF`

Find more colors:
- [HTML Color Codes](https://htmlcolorcodes.com/)
- [Coolors Color Picker](https://coolors.co/)
- [Adobe Color](https://color.adobe.com/)

## Unicode Symbols

Common symbols for prompts:

### Arrows
- `→` (U+2192) - Rightwards arrow
- `❯` (U+276F) - Heavy right-pointing angle quotation mark
- `⇒` (U+21D2) - Rightwards double arrow
- `➜` (U+279C) - Heavy round-tipped rightwards arrow

### Status Indicators
- `✓` (U+2713) - Check mark
- `✔` (U+2714) - Heavy check mark
- `✗` (U+2717) - Ballot X
- `✘` (U+2718) - Heavy ballot X
- `●` (U+25CF) - Black circle
- `◉` (U+25C9) - Fisheye

### Git Symbols
- `⎇` (U+2387) - Alternative key symbol (branch)
- `±` (U+00B1) - Plus-minus sign (changes)
- `⚡` (U+26A1) - High voltage sign (stash)
- `★` (U+2605) - Black star

### Other
- `🐳` Docker whale
- `☸` Kubernetes
- `⬢` Node.js hexagon
- `🐍` Python snake
- `🔋` Battery
- `🔌` Charging

Find more at [Unicode Table](https://unicode-table.com/)

## Advanced Customization

### Adding New Prompt Components

You can extend themes with custom functions:

```fish
# Add a custom function to show time of day greeting
function _prompt_greeting
    set -l hour (date +%H)
    if test $hour -lt 12
        echo -n "🌅 Good morning! "
    else if test $hour -lt 18
        echo -n "☀️ Good afternoon! "
    else
        echo -n "🌙 Good evening! "
    end
end

# Add to fish_prompt function
function fish_prompt
    _prompt_greeting  # Add this line
    _print_pwd
    # ... rest of prompt
end
```

### Conditional Prompts

Show different information based on context:

```fish
# Show different symbols for different directories
function _print_pwd
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))

    if string match -q "*/projects/*" $pwd_str
        set_color $mytheme_directory
        echo -n "💼 $pwd_str"
    else if string match -q "*/Documents/*" $pwd_str
        set_color $mytheme_directory
        echo -n "📄 $pwd_str"
    else
        set_color $mytheme_directory
        echo -n $pwd_str
    end
end
```

### Performance Tips

1. **Cache expensive operations**: Git status checks can be slow in large repos
2. **Use conditional logic**: Only show information when relevant
3. **Avoid external commands**: Use Fish built-ins when possible
4. **Test in large repos**: Ensure prompt remains responsive

## Troubleshooting

### Theme doesn't apply after switching
Run `exec fish` to restart Fish shell:
```fish
theme_switch mytheme
exec fish
```

### Colors look wrong
- Ensure your terminal supports 24-bit color (true color)
- Check terminal color scheme compatibility
- Verify hex codes are 6 digits without # symbol

### Prompt is slow
- Reduce git status checks
- Remove expensive operations from prompt functions
- Use caching for slow operations

### Theme not found
```fish
theme_list  # Check available themes
ls ~/.config/fish/themes/  # Verify file exists
```

## Contributing Themes

Created a great theme? Share it with the community!

1. Ensure your theme follows the template structure
2. Add meaningful metadata (name, author, description)
3. Test in various scenarios (git repos, long paths, etc.)
4. Document any special features or requirements

## Resources

- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Fish Prompt Tutorial](https://fishshell.com/docs/current/tutorial.html#prompt)
- [Awesome Fish](https://github.com/jorgebucaran/awsm.fish)
- [Fish Theme Gallery](https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md)

## License

These themes are part of your personal Fish shell configuration.
Feel free to modify, share, and distribute as you see fit.

---

**Created**: 2026-02-19
**Author**: David Nechifor
**Version**: 1.0.0
