# Custom Theme Template for Fish Shell
# Copy this file and customize it to create your own theme

# Theme metadata
set -l theme_name "YourThemeName"
set -l theme_author "Your Name"
set -l theme_description "Description of your theme"

# Color definitions
# Use hex color codes (6 digits, no # symbol)
# Example: RRGGBB format like FF5733

set -g yourtheme_directory FFFFFF    # Color for directory path
set -g yourtheme_git_info FFFFFF     # Color for git branch name
set -g yourtheme_success FFFFFF      # Color for success indicator (✓)
set -g yourtheme_error FFFFFF        # Color for error indicator (✗)
set -g yourtheme_time FFFFFF         # Color for time display
set -g yourtheme_symbols FFFFFF      # Color for prompt symbols (>, arrows, etc)
set -g yourtheme_normal FFFFFF       # Color for normal text/input

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        set -l git_branch (git branch --show-current 2>/dev/null)
        set -l git_status (git status --porcelain 2>/dev/null)

        # Customize git branch display
        set_color --bold $yourtheme_git_info
        echo -n " ["$git_branch"]"  # Change format as desired

        # Show status indicator if there are changes
        if test -n "$git_status"
            set_color $yourtheme_symbols
            echo -n "±"  # Change symbol as desired
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color --bold $yourtheme_directory

    # Shorten path by replacing $HOME with ~
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))

    echo -n $pwd_str  # Add prefix/suffix if desired
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    # Display components in desired order
    _print_pwd
    _git_status_info

    # Show status indicator
    if test $last_status -eq 0
        set_color --bold $yourtheme_success
        echo -n " ✓"  # Change success symbol
    else
        set_color --bold $yourtheme_error
        echo -n " ✗"  # Change error symbol
    end

    # Prompt symbol
    set_color --bold $yourtheme_symbols
    echo -n " > "  # Change prompt character

    # Reset color for user input
    set_color $yourtheme_normal
end

# Right-side prompt (time and command duration)
function fish_right_prompt
    # Show command execution time if available
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        # Only show if command took more than 5 seconds
        if test $duration -gt 5
            set_color --bold $yourtheme_symbols
            echo -n "["

            if test $duration -gt 60
                set -l minutes (math $duration / 60)
                set -l seconds (math $duration % 60)
                echo -n $minutes"m"$seconds"s"
            else
                echo -n $duration"s"
            end

            echo -n "] "
        end
    end

    # Current time display
    set_color --bold $yourtheme_time
    echo -n "["(date "+%H:%M")"]"  # Customize time format
    set_color normal
end

# Save command execution time (required for duration tracking)
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end

# CUSTOMIZATION TIPS:
# 1. Replace all instances of "yourtheme_" with your theme's prefix
# 2. Change color codes to your desired colors
# 3. Modify symbols (✓, ✗, >, etc.) to your preference
# 4. Add/remove prompt components as needed
# 5. Adjust time format in fish_right_prompt
# 6. Add additional functions for custom features
#
# Common symbols: ❯ → ⇒ ➜ ⚡ ★ ● ◉ ⎇
# To find more symbols: https://www.compart.com/en/unicode/
