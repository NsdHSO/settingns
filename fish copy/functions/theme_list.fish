function theme_list --description "List available Fish shell themes"
    set -l theme_dir ~/.config/fish/themes

    # Check if themes directory exists
    if not test -d $theme_dir
        set_color red
        echo "Error: Themes directory not found at $theme_dir"
        set_color normal
        return 1
    end

    set -l current_theme "phenomenon"
    if set -q fish_theme
        set current_theme $fish_theme
    end

    echo "Available themes:"
    echo ""

    # List all .fish files in themes directory
    for theme_file in $theme_dir/*.fish
        set -l theme_name (basename $theme_file .fish)

        # Skip template
        if test $theme_name = "template"
            continue
        end

        # Mark current theme
        if test $theme_name = $current_theme
            set_color --bold green
            echo "  * $theme_name (active)"
            set_color normal
        else
            set_color cyan
            echo "    $theme_name"
            set_color normal
        end

        # Try to read theme description
        set -l description (grep "theme_description" $theme_file | head -n 1 | sed 's/.*"\(.*\)"/\1/')
        if test -n "$description"
            set_color --dim
            echo "      $description"
            set_color normal
        end
    end

    echo ""
    echo "To switch themes: theme_switch <theme_name>"
    echo "To preview a theme: theme_preview <theme_name>"
    echo "To create a custom theme: cp ~/.config/fish/themes/template.fish ~/.config/fish/themes/mytheme.fish"
end
