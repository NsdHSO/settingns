function slow_command_warning -d "Warn when commands take longer than threshold"
    # This function is called by the preexec/postexec hooks
    # Default threshold: 30 seconds
    set -g SLOW_COMMAND_THRESHOLD 30

    # Allow user to customize threshold
    if set -q FISH_SLOW_COMMAND_THRESHOLD
        set SLOW_COMMAND_THRESHOLD $FISH_SLOW_COMMAND_THRESHOLD
    end
end

# Hook into command execution
function __slow_cmd_preexec --on-event fish_preexec
    set -g __slow_cmd_start (date +%s)
    set -g __slow_cmd_name "$argv"
end

function __slow_cmd_postexec --on-event fish_postexec
    if set -q __slow_cmd_start
        set -l duration (math (date +%s) - $__slow_cmd_start)

        # Get threshold (default 30 seconds)
        set -l threshold 30
        if set -q FISH_SLOW_COMMAND_THRESHOLD
            set threshold $FISH_SLOW_COMMAND_THRESHOLD
        end

        # Warn if command was slow
        if test $duration -ge $threshold
            echo ""
            set_color yellow
            echo "⚠ Slow command detected!"
            set_color normal
            echo "  Command: $__slow_cmd_name"
            echo "  Duration: {$duration}s (threshold: {$threshold}s)"
            echo ""

            # Store in slow command history
            set -l timestamp (date "+%Y-%m-%d %H:%M:%S")
            set -l log_entry "$timestamp | {$duration}s | $__slow_cmd_name"

            # Append to slow command log
            set -l log_file ~/.config/fish/slow_commands.log
            echo $log_entry >> $log_file

            # Keep only last 100 entries
            if test (count (cat $log_file)) -gt 100
                tail -n 100 $log_file > $log_file.tmp
                mv $log_file.tmp $log_file
            end
        end

        # Clean up
        set -e __slow_cmd_start
        set -e __slow_cmd_name
    end
end
