function session_save -d "Save current terminal session state"
    # Parse arguments
    set -l session_name ""
    set -l auto_save 0

    argparse 'n/name=' 'a/auto' -- $argv
    or return 1

    if set -q _flag_name
        set session_name $_flag_name
    else if test (count $argv) -gt 0
        set session_name $argv[1]
    else
        # Use current directory name as default
        set session_name (basename $PWD)
    end

    if set -q _flag_auto
        set auto_save 1
    end

    # Session directory
    set -l session_dir ~/.config/fish/sessions
    mkdir -p $session_dir

    # Session file
    set -l session_file "$session_dir/$session_name.session"
    set -l temp_file "$session_file.tmp"

    # Start creating session file
    echo "# Fish Shell Session: $session_name" > $temp_file
    echo "# Created: $(date '+%Y-%m-%d %H:%M:%S')" >> $temp_file
    echo "# Auto-saved: $auto_save" >> $temp_file
    echo "" >> $temp_file

    # Save current working directory
    echo "# Working Directory" >> $temp_file
    echo "set -l saved_pwd '$PWD'" >> $temp_file
    echo "" >> $temp_file

    # Save environment variables (excluding sensitive ones)
    echo "# Environment Variables" >> $temp_file
    set -l sensitive_vars PASSWORD TOKEN SECRET KEY API CREDENTIALS AUTH

    for var in (set -nx)
        set -l is_sensitive 0

        # Check if variable name contains sensitive keywords
        for sensitive in $sensitive_vars
            if string match -qi "*$sensitive*" $var
                set is_sensitive 1
                break
            end
        end

        # Skip sensitive variables and system/shell variables
        if test $is_sensitive -eq 0; and not string match -q "_*" $var; and not string match -q "FISH_*" $var
            set -l var_value (set -x | grep "^$var " | sed "s/^$var //")
            if test -n "$var_value"
                # Escape single quotes in value
                set var_value (string replace -a "'" "'\\''" $var_value)
                echo "set -gx $var '$var_value'" >> $temp_file
            end
        end
    end
    echo "" >> $temp_file

    # Save recent command history for current directory
    echo "# Recent Command History (last 50 commands from this location)" >> $temp_file
    echo "set -l session_history \\" >> $temp_file

    # Get last 50 unique commands
    if test -f ~/.local/share/fish/fish_history
        grep "^- cmd:" ~/.local/share/fish/fish_history | \
            tail -n 50 | \
            sed 's/^- cmd: //' | \
            while read -l cmd
                # Escape single quotes and backslashes
                set cmd (string replace -a "\\" "\\\\" $cmd)
                set cmd (string replace -a "'" "'\\''" $cmd)
                echo "    '$cmd' \\" >> $temp_file
            end
    end
    echo "    # end of history" >> $temp_file
    echo "" >> $temp_file

    # Save active tmux/screen session info if applicable
    if set -q TMUX
        echo "# Tmux Session" >> $temp_file
        echo "set -l tmux_session (tmux display-message -p '#S')" >> $temp_file
        echo "# To restore: tmux attach -t \$tmux_session" >> $temp_file
        echo "" >> $temp_file
    end

    # Save project-specific state
    if test -f ./.project_state
        echo "# Project State" >> $temp_file
        echo "set -l has_project_state 1" >> $temp_file
        echo "# Source ./.project_state in project directory" >> $temp_file
        echo "" >> $temp_file
    end

    # Save git branch if in a git repo
    if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -n "$branch"
            echo "# Git Information" >> $temp_file
            echo "set -l git_branch '$branch'" >> $temp_file
            echo "" >> $temp_file
        end
    end

    # Save custom session data (user can define this function)
    if functions -q session_save_custom
        echo "# Custom Session Data" >> $temp_file
        session_save_custom >> $temp_file
        echo "" >> $temp_file
    end

    # Move temp file to final location
    mv $temp_file $session_file

    if test $auto_save -eq 1
        echo "Session '$session_name' auto-saved to $session_file" >&2
    else
        echo "Session '$session_name' saved successfully!" >&2
        echo "Location: $session_file" >&2
        echo "Restore with: session_restore $session_name" >&2
    end

    return 0
end
