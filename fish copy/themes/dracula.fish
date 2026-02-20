# Dracula Theme for Fish Shell
# Dark theme inspired by Dracula color scheme

# Theme metadata
set -l theme_name "Dracula"
set -l theme_author "David Nechifor"
set -l theme_description "Dark theme inspired by Dracula color palette"

# Color definitions (Dracula official colors)
set -g dracula_directory BD93F9    # Purple for directories
set -g dracula_git_info 8BE9FD     # Cyan for git info
set -g dracula_success 50FA7B      # Green for success
set -g dracula_error FF5555        # Red for errors
set -g dracula_time FFB86C         # Orange for time
set -g dracula_symbols FF79C6      # Pink for symbols
set -g dracula_normal F8F8F2       # Foreground/white for normal text

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        set -l git_branch (git branch --show-current 2>/dev/null)
        set -l git_status (git status --porcelain 2>/dev/null)

        set_color --bold $dracula_git_info
        echo -n "  "$git_branch

        if test -n "$git_status"
            set_color $dracula_symbols
            echo -n " ●"
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color --bold $dracula_directory
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))
    echo -n $pwd_str
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    _print_pwd
    _git_status_info

    if test $last_status -eq 0
        set_color --bold $dracula_success
        echo -n " ✔"
    else
        set_color --bold $dracula_error
        echo -n " ✘"
    end

    set_color --bold $dracula_symbols
    echo -n " ❯ "

    set_color $dracula_normal
end

# Right-side prompt
function fish_right_prompt
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        if test $duration -gt 5
            set_color --bold $dracula_symbols
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

    set_color --bold $dracula_time
    echo -n (date "+%H:%M")
    set_color normal
end

# Save command execution time
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end
