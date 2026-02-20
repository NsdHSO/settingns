function show_slow_commands -d "Show history of slow commands"
    set -l log_file ~/.config/fish/slow_commands.log

    if not test -f $log_file
        set_color yellow
        echo "No slow commands logged yet"
        set_color normal
        echo ""
        echo "Slow commands (>30s by default) will be logged automatically"
        echo "Customize threshold: set -Ux FISH_SLOW_COMMAND_THRESHOLD 60"
        return
    end

    set -l count (count (cat $log_file))

    echo "Slow Command History ($count entries)"
    echo ""
    set_color cyan
    printf "%-20s %-12s %s\n" "Timestamp" "Duration" "Command"
    echo "────────────────────────────────────────────────────────────────"
    set_color normal

    # Show last 20 entries
    tail -n 20 $log_file | while read -l line
        echo $line | string replace " | " "\t" | while read -l timestamp duration command
            printf "%-20s " $timestamp

            # Color code by duration
            set -l seconds (string replace 's' '' $duration)
            if test $seconds -gt 120
                set_color red
            else if test $seconds -gt 60
                set_color yellow
            else
                set_color green
            end

            printf "%-12s " $duration
            set_color normal
            echo $command
        end
    end

    echo ""
    echo "Tip: Clear log with 'rm ~/.config/fish/slow_commands.log'"
    echo "Tip: Change threshold with 'set -Ux FISH_SLOW_COMMAND_THRESHOLD <seconds>'"
end
