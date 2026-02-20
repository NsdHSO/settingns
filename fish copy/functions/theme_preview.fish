function theme_preview --description "Preview a Fish shell theme without switching"
    set -l theme_dir ~/.config/fish/themes

    # Check if theme name was provided
    if test (count $argv) -eq 0
        echo "Usage: theme_preview <theme_name>"
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

    # Save current theme functions
    functions -c fish_prompt __saved_fish_prompt
    functions -c fish_right_prompt __saved_fish_right_prompt
    if functions -q _git_status_info
        functions -c _git_status_info __saved_git_status_info
    end
    if functions -q _print_pwd
        functions -c _print_pwd __saved_print_pwd
    end

    # Load the preview theme
    source $theme_file

    set_color --bold yellow
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "THEME PREVIEW: $theme_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set_color normal
    echo ""

    # Show sample prompts
    echo "Sample prompts:"
    echo ""

    # Simulate different scenarios
    set -l saved_status $status

    # Success prompt
    true
    echo -n "Success: "
    fish_prompt
    echo ""

    # Error prompt
    false
    echo -n "Error:   "
    fish_prompt
    echo ""

    # Show right prompt
    echo -n "Right:   "
    set -g cmd_start_time (math (date +%s) - 10)
    echo (fish_right_prompt)
    set -e cmd_start_time
    echo ""

    set_color --bold yellow
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set_color normal
    echo ""

    # Restore original theme functions
    functions -c __saved_fish_prompt fish_prompt
    functions -c __saved_fish_right_prompt fish_right_prompt
    if functions -q __saved_git_status_info
        functions -c __saved_git_status_info _git_status_info
    end
    if functions -q __saved_print_pwd
        functions -c __saved_print_pwd _print_pwd
    end

    # Clean up saved functions
    functions -e __saved_fish_prompt
    functions -e __saved_fish_right_prompt
    functions -e __saved_git_status_info
    functions -e __saved_print_pwd

    # Restore status
    test $saved_status

    echo "To apply this theme permanently:"
    echo "  theme_switch $theme_name"
end
