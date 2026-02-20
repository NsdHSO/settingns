# Minimal Theme for Fish Shell
# A clean, minimalist theme with subtle colors

# Theme metadata
set -l theme_name "Minimal"
set -l theme_author "David Nechifor"
set -l theme_description "Clean and minimal theme with subtle colors"

# Color definitions
set -g minimal_directory 5F9EA0    # Cadet blue for directories
set -g minimal_git_info 708090     # Slate gray for git info
set -g minimal_success 90EE90      # Light green for success
set -g minimal_error CD5C5C        # Indian red for errors
set -g minimal_time 778899         # Light slate gray for time
set -g minimal_symbols 696969      # Dim gray for symbols
set -g minimal_normal D3D3D3       # Light gray for normal text

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        set -l git_branch (git branch --show-current 2>/dev/null)
        set -l git_status (git status --porcelain 2>/dev/null)

        set_color $minimal_git_info
        echo -n " ("$git_branch")"

        if test -n "$git_status"
            set_color $minimal_symbols
            echo -n "*"
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color $minimal_directory
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))
    echo -n $pwd_str
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    _print_pwd
    _git_status_info

    if test $last_status -eq 0
        set_color $minimal_success
        echo -n " →"
    else
        set_color $minimal_error
        echo -n " ×"
    end

    set_color $minimal_normal
    echo -n " "
end

# Right-side prompt
function fish_right_prompt
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        if test $duration -gt 5
            set_color $minimal_symbols
            if test $duration -gt 60
                set -l minutes (math $duration / 60)
                set -l seconds (math $duration % 60)
                echo -n $minutes"m"$seconds"s "
            else
                echo -n $duration"s "
            end
        end
    end

    set_color $minimal_time
    echo -n (date "+%H:%M")
    set_color normal
end

# Save command execution time
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end
