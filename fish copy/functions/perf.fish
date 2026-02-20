function perf -d "Performance monitoring dashboard for fish shell"
    set -l command $argv[1]

    # If no command, show help
    if test -z "$command"
        echo "Fish Shell Performance Monitor"
        echo "═══════════════════════════════"
        echo ""
        echo "Usage: perf <command>"
        echo ""
        echo "Commands:"
        echo "  status    - Show current performance status"
        echo "  startup   - Measure startup time"
        echo "  profile   - Profile startup components"
        echo "  slow      - Show slow command history"
        echo "  tips      - Show optimization tips"
        echo "  function  - Profile a specific function"
        echo "  reset     - Clear performance logs"
        echo ""
        echo "Examples:"
        echo "  perf status"
        echo "  perf startup"
        echo "  perf function gc \"commit message\""
        return
    end

    switch $command
        case status
            __perf_status

        case startup
            fish_startup_time

        case profile
            profile_startup

        case slow
            show_slow_commands

        case tips
            performance_tips

        case function
            if test (count $argv) -lt 2
                set_color red
                echo "Error: Function name required"
                set_color normal
                echo "Usage: perf function <function_name> [args...]"
                return 1
            end
            profile_function $argv[2..-1]

        case reset
            set_color yellow
            echo "Clearing performance logs..."
            set_color normal
            rm -f ~/.config/fish/slow_commands.log
            echo "✓ Logs cleared"

        case '*'
            set_color red
            echo "Unknown command: $command"
            set_color normal
            echo "Run 'perf' for help"
            return 1
    end
end

function __perf_status -d "Show current performance status"
    echo "Fish Shell Performance Status"
    echo "═════════════════════════════"
    echo ""

    # Quick startup test
    echo "Testing startup time..."
    set -l start (date +%s%N)
    fish -c exit 2>/dev/null
    set -l end (date +%s%N)
    set -l startup_ms (math \( $end - $start \) / 1000000)

    echo ""
    echo "Startup Performance:"
    echo "  Current: {$startup_ms}ms"
    echo "  Target:  200ms"

    if test $startup_ms -lt 200
        set_color green
        echo "  Status:  ✓ Excellent"
    else if test $startup_ms -lt 500
        set_color yellow
        echo "  Status:  ⚠ Needs optimization"
    else
        set_color red
        echo "  Status:  ✗ Critical"
    end
    set_color normal

    echo ""

    # Function count
    set -l func_count (functions -n | wc -l | string trim)
    echo "Functions:"
    echo "  Total loaded: $func_count"

    # Config analysis
    set -l config_lines (wc -l < ~/.config/fish/config.fish | string trim)
    echo ""
    echo "Configuration:"
    echo "  config.fish: $config_lines lines"

    # Conf.d analysis
    if test -d ~/.config/fish/conf.d
        set -l conf_count (count ~/.config/fish/conf.d/*.fish 2>/dev/null)
        echo "  conf.d files: $conf_count"
    end

    # Slow command stats
    echo ""
    if test -f ~/.config/fish/slow_commands.log
        set -l slow_count (wc -l < ~/.config/fish/slow_commands.log | string trim)
        echo "Slow Commands:"
        echo "  Logged: $slow_count commands (>30s)"
        if test $slow_count -gt 0
            set_color yellow
            echo "  Run 'perf slow' to view"
            set_color normal
        end
    else
        echo "Slow Commands:"
        echo "  None logged yet"
    end

    # Recommendations
    echo ""
    echo "Quick Actions:"
    if test $startup_ms -gt 200
        echo "  • Run 'perf profile' to identify bottlenecks"
    end
    echo "  • Run 'perf tips' for optimization suggestions"
    echo "  • Run 'perf startup' for detailed timing"
    echo ""
end
