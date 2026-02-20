# Fuzzy History Execute
# Usage: fh - search command history and execute selected command

function fh --description "Fuzzy find and execute command from history"
    # Get command from history with fzf
    set -l cmd (history | \
        fzf --prompt="Select command: " \
            --tac \
            --no-sort \
            --exact \
            --height=50% \
            --border \
            --ansi \
            --preview="echo {}" \
            --preview-window=down:3:wrap)

    if test -n "$cmd"
        set_color --bold magenta
        echo "Executing: $cmd"
        set_color normal

        # Execute the selected command
        eval $cmd
    else
        set_color yellow
        echo "No command selected"
        set_color normal
    end
end
