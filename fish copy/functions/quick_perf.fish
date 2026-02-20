function quick_perf -d "Ultra-quick performance snapshot (1 measurement)"
    # Single iteration for instant feedback
    set -l start (date +%s%N)
    fish -c exit 2>/dev/null
    set -l end (date +%s%N)
    set -l startup_ms (math \( $end - $start \) / 1000000)

    echo -n "Startup: {$startup_ms}ms "

    if test $startup_ms -lt 200
        set_color green
        echo "✓"
    else if test $startup_ms -lt 500
        set_color yellow
        echo "⚠"
    else
        set_color red
        echo "✗"
    end
    set_color normal
end
