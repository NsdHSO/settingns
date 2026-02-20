function session_list -d "List all available saved sessions"
    set -l session_dir ~/.config/fish/sessions

    # Check if sessions directory exists
    if not test -d $session_dir
        echo "No sessions found. Sessions directory doesn't exist yet."
        echo "Create a session with: session_save <name>"
        return 0
    end

    # Find all session files
    set -l sessions (find $session_dir -name "*.session" -type f 2>/dev/null)

    if test (count $sessions) -eq 0
        echo "No sessions found."
        echo "Create a session with: session_save <name>"
        return 0
    end

    # Parse arguments for format options
    argparse 'l/long' 'j/json' -- $argv
    or return 1

    if set -q _flag_json
        # JSON output
        echo "["
        set -l first 1
        for session_file in $sessions
            set -l session_name (basename $session_file .session)
            set -l modified (stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" $session_file 2>/dev/null || stat -c "%y" $session_file 2>/dev/null || echo "unknown")
            set -l size (stat -f "%z" $session_file 2>/dev/null || stat -c "%s" $session_file 2>/dev/null || echo "0")

            if test $first -eq 0
                echo ","
            end
            set first 0

            echo "  {"
            echo "    \"name\": \"$session_name\","
            echo "    \"file\": \"$session_file\","
            echo "    \"modified\": \"$modified\","
            echo "    \"size\": $size"
            echo -n "  }"
        end
        echo ""
        echo "]"
    else if set -q _flag_long
        # Long format with details
        echo "Available Sessions:"
        echo ""
        printf "%-20s %-20s %-10s %s\n" "NAME" "MODIFIED" "SIZE" "LOCATION"
        printf "%-20s %-20s %-10s %s\n" "----" "--------" "----" "--------"

        for session_file in $sessions
            set -l session_name (basename $session_file .session)
            set -l modified (stat -f "%Sm" -t "%Y-%m-%d %H:%M" $session_file 2>/dev/null || stat -c "%y" $session_file 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1 || echo "unknown")
            set -l size (stat -f "%z" $session_file 2>/dev/null || stat -c "%s" $session_file 2>/dev/null || echo "0")

            # Format size
            if test $size -gt 1048576
                set size (math "$size / 1048576")"M"
            else if test $size -gt 1024
                set size (math "$size / 1024")"K"
            else
                set size $size"B"
            end

            # Extract saved directory from session file
            set -l saved_dir (grep "^set -l saved_pwd" $session_file | sed "s/set -l saved_pwd '//;s/'//")

            printf "%-20s %-20s %-10s %s\n" $session_name $modified $size $saved_dir
        end

        echo ""
        echo "Total: "(count $sessions)" session(s)"
        echo ""
        echo "Usage:"
        echo "  session_restore <name>  - Restore a session"
        echo "  session_delete <name>   - Delete a session"
    else
        # Simple list format
        echo "Available Sessions:"
        for session_file in $sessions
            set -l session_name (basename $session_file .session)

            # Extract metadata
            set -l created (grep "^# Created:" $session_file | sed 's/# Created: //')
            set -l saved_dir (grep "^set -l saved_pwd" $session_file | sed "s/set -l saved_pwd '//;s/'//")

            echo ""
            echo "  $session_name"
            if test -n "$created"
                echo "    Created: $created"
            end
            if test -n "$saved_dir"
                echo "    Location: $saved_dir"
            end
        end

        echo ""
        echo "Total: "(count $sessions)" session(s)"
        echo ""
        echo "Use 'session_list -l' for detailed view"
        echo "Use 'session_restore <name>' to restore a session"
    end

    return 0
end
