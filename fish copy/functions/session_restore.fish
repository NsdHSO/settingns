function session_restore -d "Restore a saved terminal session"
    # Parse arguments
    set -l session_name ""
    set -l no_cd 0

    argparse 'n/name=' 'no-cd' -- $argv
    or return 1

    if set -q _flag_name
        set session_name $_flag_name
    else if test (count $argv) -gt 0
        set session_name $argv[1]
    else
        echo "Error: Session name required" >&2
        echo "Usage: session_restore <session_name>" >&2
        echo "       session_restore -n <session_name>" >&2
        echo "       session_restore --no-cd <session_name>  # Don't change directory" >&2
        return 1
    end

    if set -q _flag_no_cd
        set no_cd 1
    end

    # Session directory
    set -l session_dir ~/.config/fish/sessions
    set -l session_file "$session_dir/$session_name.session"

    # Check if session exists
    if not test -f $session_file
        echo "Error: Session '$session_name' not found" >&2
        echo "Available sessions:" >&2
        session_list
        return 1
    end

    echo "Restoring session: $session_name"

    # Source the session file to load variables
    source $session_file

    # Restore working directory
    if set -q saved_pwd; and test $no_cd -eq 0
        if test -d $saved_pwd
            cd $saved_pwd
            echo "Changed to directory: $saved_pwd"
        else
            echo "Warning: Saved directory no longer exists: $saved_pwd" >&2
        end
    end

    # Display git branch info
    if set -q git_branch
        echo "Previous git branch: $git_branch"
        if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
            set -l current_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if test "$current_branch" != "$git_branch"
                echo "Current branch: $current_branch (different from saved)"
            end
        end
    end

    # Display tmux info
    if set -q tmux_session
        echo "Previous tmux session: $tmux_session"
    end

    # Source project state if exists
    if set -q has_project_state; and test -f ./.project_state
        echo "Loading project state..."
        source ./.project_state
    end

    # Restore custom session data
    if functions -q session_restore_custom
        session_restore_custom
    end

    # Display session history info
    if set -q session_history
        echo "Session history loaded: "(count $session_history)" commands"
        echo "Tip: Use 'history merge' to integrate with current history"
    end

    echo "Session '$session_name' restored successfully!"

    return 0
end
