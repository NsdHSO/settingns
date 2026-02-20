# Fuzzy Process Killer
# Usage: fkill [signal] - select and kill processes using fzf
# Enhanced version of killport with fuzzy finding

function fkill --description "Fuzzy find and kill processes"
    # Get signal argument (default to TERM)
    set -l signal TERM
    if test (count $argv) -gt 0
        set signal $argv[1]
    end

    # Get list of processes (excluding header and this grep itself)
    set -l selected (ps aux | \
        sed 1d | \
        fzf --multi \
            --prompt="Select process(es) to kill ($signal): " \
            --header="TAB to select multiple | ENTER to confirm | ESC to cancel" \
            --preview="echo {} | awk '{print \$2}' | xargs ps -p -o pid,ppid,user,%cpu,%mem,start,time,command" \
            --preview-window=down:5:wrap \
            --height=80% \
            --border \
            --ansi)

    if test -z "$selected"
        set_color yellow
        echo "No process selected"
        set_color normal
        return 0
    end

    # Extract PIDs from selected processes
    set -l pids (echo $selected | awk '{print $2}')

    if test -z "$pids"
        set_color red
        echo "Error: Could not extract PIDs"
        set_color normal
        return 1
    end

    # Show what will be killed and ask for confirmation
    set_color --bold magenta
    echo "Will kill the following process(es) with signal $signal:"
    set_color normal
    echo $selected

    set_color --bold yellow
    read -P "Continue? (y/N): " -l confirm
    set_color normal

    if test "$confirm" = "y" -o "$confirm" = "Y"
        for pid in $pids
            set_color --bold red
            echo "Killing PID $pid with signal $signal..."
            set_color normal
            kill -s $signal $pid

            if test $status -eq 0
                set_color --bold green
                echo "✓ Successfully killed PID $pid"
                set_color normal
            else
                set_color --bold red
                echo "✗ Failed to kill PID $pid"
                set_color normal
            end
        end
    else
        set_color yellow
        echo "Operation cancelled"
        set_color normal
    end
end
