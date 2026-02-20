function theme_current --description "Show the currently active theme"
    set -l current_theme "phenomenon"

    if set -q fish_theme
        set current_theme $fish_theme
    end

    set -l theme_file ~/.config/fish/themes/$current_theme.fish

    set_color --bold cyan
    echo "Current theme: $current_theme"
    set_color normal

    if test -f $theme_file
        # Extract theme description
        set -l description (grep "theme_description" $theme_file | head -n 1 | sed 's/.*"\(.*\)"/\1/')
        if test -n "$description"
            echo "Description: $description"
        end

        # Show color palette
        echo ""
        echo "Color palette:"

        # Read color variables from theme file
        for line in (grep "set -g.*_" $theme_file)
            if string match -q "*#*" $line
                continue
            end

            set -l parts (string split " " $line)
            if test (count $parts) -ge 3
                set -l var_name $parts[3]
                set -l color_value $parts[4]

                if string match -q "*_*" $var_name
                    set_color $color_value
                    echo -n "  ███ "
                    set_color normal
                    echo "$var_name: $color_value"
                end
            end
        end
    end

    echo ""
    echo "To switch themes: theme_switch <theme_name>"
    echo "To see all themes: theme_list"
end
