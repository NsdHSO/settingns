function session_delete -d "Delete a saved session"
    # Parse arguments
    set -l session_name ""
    set -l force 0

    argparse 'n/name=' 'f/force' -- $argv
    or return 1

    if set -q _flag_name
        set session_name $_flag_name
    else if test (count $argv) -gt 0
        set session_name $argv[1]
    else
        echo "Error: Session name required" >&2
        echo "Usage: session_delete <session_name>" >&2
        echo "       session_delete -f <session_name>  # Skip confirmation" >&2
        return 1
    end

    if set -q _flag_force
        set force 1
    end

    # Session directory
    set -l session_dir ~/.config/fish/sessions
    set -l session_file "$session_dir/$session_name.session"

    # Check if session exists
    if not test -f $session_file
        echo "Error: Session '$session_name' not found" >&2
        return 1
    end

    # Confirm deletion unless force flag is set
    if test $force -eq 0
        echo "Are you sure you want to delete session '$session_name'?"
        echo "Location: $session_file"
        read -l -P "Type 'yes' to confirm: " confirm

        if test "$confirm" != "yes"
            echo "Deletion cancelled."
            return 1
        end
    end

    # Delete the session file
    rm $session_file

    if test $status -eq 0
        echo "Session '$session_name' deleted successfully."
        return 0
    else
        echo "Error: Failed to delete session '$session_name'" >&2
        return 1
    end
end
