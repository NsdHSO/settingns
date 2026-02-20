# Ocean Theme for Fish Shell
# A calming ocean-inspired theme with blue and teal tones

# Theme metadata
set -l theme_name "Ocean"
set -l theme_author "David Nechifor"
set -l theme_description "Calming ocean-inspired theme with blue and teal tones"

# Color definitions
set -g ocean_directory 00CED1      # Dark turquoise for directories
set -g ocean_git_info 4682B4       # Steel blue for git info
set -g ocean_success 20B2AA        # Light sea green for success
set -g ocean_error FF6347          # Tomato red for errors
set -g ocean_time 40E0D0           # Turquoise for time
set -g ocean_symbols 1E90FF        # Dodger blue for symbols
set -g ocean_normal B0E0E6         # Powder blue for normal text

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        set -l git_branch (git branch --show-current 2>/dev/null)
        set -l git_status (git status --porcelain 2>/dev/null)

        set_color --bold $ocean_git_info
        echo -n " ⎇ "$git_branch

        if test -n "$git_status"
            set_color $ocean_symbols
            echo -n " •"
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color --bold $ocean_directory
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))
    echo -n "📂 "$pwd_str
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    _print_pwd
    _git_status_info

    if test $last_status -eq 0
        set_color --bold $ocean_success
        echo -n " ◉"
    else
        set_color --bold $ocean_error
        echo -n " ◉"
    end

    set_color --bold $ocean_symbols
    echo -n " ❯ "

    set_color $ocean_normal
end

# Right-side prompt
function fish_right_prompt
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        if test $duration -gt 5
            set_color $ocean_symbols
            echo -n "⏱ "

            if test $duration -gt 60
                set -l minutes (math $duration / 60)
                set -l seconds (math $duration % 60)
                echo -n $minutes"m"$seconds"s "
            else
                echo -n $duration"s "
            end
        end
    end

    set_color --bold $ocean_time
    echo -n "🕐 "(date "+%H:%M")
    set_color normal
end

# Save command execution time
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end
