function fish_startup_time -d "Measure fish shell startup time"
    set -l iterations 5

    if test (count $argv) -gt 0
        set iterations $argv[1]
    end

    echo "Measuring fish startup time ($iterations iterations)..."
    echo ""

    set -l times
    set -l total 0

    for i in (seq $iterations)
        set -l start_time (date +%s%N)
        fish -c exit
        set -l end_time (date +%s%N)

        set -l duration_ns (math $end_time - $start_time)
        set -l duration_ms (math $duration_ns / 1000000)

        set times $times $duration_ms
        set total (math $total + $duration_ms)

        echo "  Run $i: {$duration_ms}ms"
    end

    set -l average (math $total / $iterations)

    echo ""
    echo "Results:"
    echo "  Average: {$average}ms"
    echo "  Total time: {$total}ms"
    echo ""

    # Performance assessment
    if test $average -lt 200
        set_color green
        echo "  ✓ Excellent! Startup time is under 200ms target"
    else if test $average -lt 500
        set_color yellow
        echo "  ⚠ Warning: Startup time is slower than 200ms target"
        echo "  Consider running 'profile_startup' to identify bottlenecks"
    else
        set_color red
        echo "  ✗ Critical: Startup time is very slow (>500ms)"
        echo "  Run 'profile_startup' to identify slow components"
    end
    set_color normal

    echo ""
    echo "Tip: Run 'profile_startup' for detailed analysis"
end
