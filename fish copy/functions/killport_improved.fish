# Improved killport with Advanced Error Handling
function killport_improved
    # Check for required tool
    if not command -q lsof
        error_handler missing_tool lsof
        return 1
    end

    # Validate arguments
    if test (count $argv) -eq 0
        error_handler missing_arg killport "<port>"
        set_color $phenomenon_git_info
        echo "→ Example: killport 3000"
        set_color normal
        return 1
    end

    # Validate port number
    set -l port $argv[1]
    if not string match -qr '^[0-9]+$' -- $port
        error_handler invalid_arg $port "numeric port (1-65535)"
        return 1
    end

    # Validate port range
    if test $port -lt 1 -o $port -gt 65535
        error_handler invalid_arg $port "port number between 1 and 65535"
        return 1
    end

    # Get processes on port
    set -l pids (lsof -ti :$port 2>/dev/null | string split " ")

    # Check if any processes found
    if test -z "$pids" -o (count $pids) -eq 0
        set_color $phenomenon_time
        echo "→ Port $port: No active processes"
        set_color normal
        return 0
    end

    # Display found processes
    set_color $phenomenon_git_info
    echo "→ Processes on port $port:"
    set_color normal

    set -l index 1
    for pid in $pids
        # Validate PID exists
        if not ps -p $pid >/dev/null 2>&1
            continue
        end

        set -l app (ps -p $pid -o comm= 2>/dev/null)
        set -l user (ps -p $pid -o user= 2>/dev/null)

        set_color $phenomenon_directory
        echo "$index) PID $pid [$app] (user: $user)"
        set_color normal
        set index (math $index + 1)
    end

    # If no valid PIDs, return
    if test $index -eq 1
        error_handler custom "No valid processes found (race condition?)"
        return 1
    end

    # Prompt for selection
    set_color $phenomenon_symbols
    read -l -P "→ Enter numbers to kill (space-separated, 0 to abort): " choices
    set_color normal

    # Handle abort
    if test -z "$choices" -o "$choices" = "0"
        set_color $phenomenon_time
        echo "→ Operation cancelled"
        set_color normal
        return 0
    end

    # Process each choice
    set -l killed_count 0
    for choice in (string split " " -- $choices)
        # Validate choice is numeric
        if not string match -qr '^[0-9]+$' -- "$choice"
            error_handler invalid_arg $choice "numeric selection"
            continue
        end

        # Validate choice is in range
        if test $choice -lt 1 -o $choice -ge $index
            error_handler invalid_arg $choice "valid selection (1-"(math $index - 1)")"
            continue
        end

        set -l target_pid $pids[$choice]

        # Check if we have permission
        set -l pid_user (ps -p $target_pid -o user= 2>/dev/null)
        set -l current_user (whoami)

        if test "$pid_user" != "$current_user" -a "$current_user" != "root"
            set_color $phenomenon_symbols
            echo "→ PID $target_pid requires elevated privileges"
            set_color normal
            continue
        end

        # Attempt to kill process
        set_color $phenomenon_symbols
        echo "→ Terminating PID $target_pid..."
        set_color normal

        if kill -9 $target_pid 2>/dev/null
            set_color $phenomenon_success
            echo "✓ PID $target_pid terminated successfully"
            set_color normal
            set killed_count (math $killed_count + 1)
        else
            error_handler permission_denied "PID $target_pid"
            set_color $phenomenon_git_info
            echo "→ Try with sudo: sudo fish -c 'killport $port'"
            set_color normal
        end
    end

    # Summary
    if test $killed_count -gt 0
        set_color $phenomenon_success
        echo "✓ Killed $killed_count process(es)"
        set_color normal
        return 0
    else
        error_handler custom "No processes were killed"
        return 1
    end
end
