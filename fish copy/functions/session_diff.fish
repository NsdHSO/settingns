function session_diff -d "Show differences between saved session and current state"
    # Parse arguments
    set -l session_name ""

    argparse 'n/name=' -- $argv
    or return 1

    if set -q _flag_name
        set session_name $_flag_name
    else if test (count $argv) -gt 0
        set session_name $argv[1]
    else
        echo "Error: Session name required" >&2
        echo "Usage: session_diff <session_name>" >&2
        return 1
    end

    # Session directory
    set -l session_dir ~/.config/fish/sessions
    set -l session_file "$session_dir/$session_name.session"

    # Check if session exists
    if not test -f $session_file
        echo "Error: Session '$session_name' not found" >&2
        return 1
    end

    echo "Comparing session '$session_name' with current state:"
    echo ""

    # Load session variables
    source $session_file

    # Compare working directory
    echo "Working Directory:"
    if set -q saved_pwd
        if test "$saved_pwd" = "$PWD"
            echo "  ✓ Same: $PWD"
        else
            echo "  ✗ Different:"
            echo "    Saved:   $saved_pwd"
            echo "    Current: $PWD"
        end
    end
    echo ""

    # Compare git branch
    if set -q git_branch
        if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
            set -l current_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            echo "Git Branch:"
            if test "$git_branch" = "$current_branch"
                echo "  ✓ Same: $git_branch"
            else
                echo "  ✗ Different:"
                echo "    Saved:   $git_branch"
                echo "    Current: $current_branch"
            end
            echo ""
        end
    end

    # Compare environment variables
    echo "Environment Variables:"
    set -l diff_count 0

    # Get all exported vars from session
    set -l session_vars (grep "^set -gx" $session_file | sed 's/set -gx //' | cut -d' ' -f1 | sort -u)

    for var in $session_vars
        set -l session_value (grep "^set -gx $var" $session_file | sed "s/^set -gx $var '//;s/'\$//")
        set -l current_value ""

        if set -q $var
            set current_value $$var
        end

        if test "$session_value" != "$current_value"
            set diff_count (math $diff_count + 1)
            echo "  ✗ $var"
            echo "    Saved:   $session_value"
            echo "    Current: $current_value"
        end
    end

    if test $diff_count -eq 0
        echo "  ✓ All environment variables match"
    end

    echo ""
    return 0
end
