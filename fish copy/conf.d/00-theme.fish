# Theme Management System
# Loads the active theme for Fish shell
#
# This file should be loaded BEFORE 03-prompt.fish (hence the 00- prefix)
# to allow theme switching without conflicts.

# Set default theme if not already set
if not set -q fish_theme
    set -U fish_theme phenomenon
end

# Theme directory
set -l theme_dir ~/.config/fish/themes
set -l active_theme_file "$theme_dir/$fish_theme.fish"

# Load the active theme if it exists
if test -f $active_theme_file
    source $active_theme_file
else
    # Fallback to phenomenon theme if the selected theme doesn't exist
    if test -f "$theme_dir/phenomenon.fish"
        set -U fish_theme phenomenon
        source "$theme_dir/phenomenon.fish"
    else
        # Ultimate fallback: load from conf.d/03-prompt.fish
        # (The old location, kept for backwards compatibility)
        echo "Warning: No theme file found. Using built-in prompt from conf.d/03-prompt.fish"
    end
end
