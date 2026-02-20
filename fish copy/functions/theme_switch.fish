function theme_switch --description "Switch Fish shell theme"
    set -l theme_dir ~/.config/fish/themes

    # Check if theme name was provided
    if test (count $argv) -eq 0
        echo "Usage: theme_switch <theme_name>"
        echo ""
        echo "Available themes:"
        theme_list
        return 1
    end

    set -l theme_name $argv[1]
    set -l theme_file "$theme_dir/$theme_name.fish"

    # Check if theme file exists
    if not test -f $theme_file
        set_color red
        echo "Error: Theme '$theme_name' not found!"
        set_color normal
        echo ""
        echo "Available themes:"
        theme_list
        return 1
    end

    # Save the current theme preference
    set -U fish_theme $theme_name

    # Source the theme file
    source $theme_file

    set_color green
    echo "✓ Theme switched to: $theme_name"
    set_color normal
    echo "The theme will persist across sessions."
    echo ""
    echo "To apply the theme immediately in all terminals, run:"
    echo "  exec fish"
end
