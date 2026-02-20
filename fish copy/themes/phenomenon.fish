# Phenomenon Theme for Fish Shell
# A vibrant, modern theme with pink/magenta accents

# Theme metadata
set -l theme_name "Phenomenon"
set -l theme_author "David Nechifor"
set -l theme_description "Vibrant theme with pink/magenta accents and comprehensive git status"

# Color definitions
set -g phenomenon_directory BF409D    # Magenta/pink for directories
set -g phenomenon_git_info 3B82F6     # Blue for git branch info
set -g phenomenon_success 22C55E      # Green for success indicators
set -g phenomenon_error EF4444        # Red for error indicators
set -g phenomenon_time 14B8A6         # Teal for time display
set -g phenomenon_symbols F43F5E      # Pink/red for symbols
set -g phenomenon_normal E5E5E5       # Light gray for normal text

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        # Get current branch
        set -l git_branch (git branch --show-current 2>/dev/null)

        # Check git status
        set -l git_status (git status --porcelain 2>/dev/null)

        # Show branch name
        set_color --bold $phenomenon_git_info
        echo -n " ["$git_branch"]"

        # Show status indicators if needed
        if test -n "$git_status"
            set_color --bold $phenomenon_symbols
            echo -n "±"
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color --bold $phenomenon_directory

    # Shorten path by replacing $HOME with ~
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))

    echo -n $pwd_str
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    # Print working directory
    _print_pwd

    # Print git info
    _git_status_info

    # Show status indicator
    if test $last_status -eq 0
        set_color --bold $phenomenon_success
        echo -n " ✓"
    else
        set_color --bold $phenomenon_error
        echo -n " ✗"
    end

    # End with a simple > in Phenomenon pink/red
    set_color --bold $phenomenon_symbols
    echo -n " > "

    # Reset color for user input
    set_color $phenomenon_normal
end

# Right-side prompt (time and command duration)
function fish_right_prompt
    # Show command execution time if available
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        if test $duration -gt 5
            set_color --bold $phenomenon_symbols
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

    # Current time
    set_color --bold $phenomenon_time
    echo -n "["(date "+%H:%M")"]"
    set_color normal
end

# Save command execution time (event handler)
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end
