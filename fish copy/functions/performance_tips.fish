function performance_tips -d "Show performance optimization tips for fish shell"
    echo "Fish Shell Performance Optimization Tips"
    echo "════════════════════════════════════════"
    echo ""

    # Run quick diagnostics
    set -l startup_time 0
    echo "Running diagnostics..."

    # Measure startup time
    set -l start (date +%s%N)
    fish -c exit 2>/dev/null
    set -l end (date +%s%N)
    set startup_time (math \( $end - $start \) / 1000000)

    echo "  Current startup time: {$startup_time}ms"
    echo ""

    # Analyze config.fish
    set -l config_file ~/.config/fish/config.fish
    set -l has_issues 0

    echo "Configuration Analysis:"
    echo ""

    # Check 1: Multiple eval calls
    set -l eval_count (grep -c "eval" $config_file 2>/dev/null)
    if test $eval_count -gt 3
        set has_issues 1
        set_color yellow
        echo "  ⚠ Issue: Multiple eval calls ($eval_count found)"
        set_color normal
        echo "     Tip: eval is slow. Consider alternatives or lazy loading"
        echo ""
    end

    # Check 2: Command substitutions
    set -l cmd_sub_count (grep -c '\$(' $config_file 2>/dev/null)
    if test $cmd_sub_count -gt 15
        set has_issues 1
        set_color yellow
        echo "  ⚠ Issue: Many command substitutions ($cmd_sub_count found)"
        set_color normal
        echo "     Tip: Move non-critical substitutions to functions"
        echo ""
    end

    # Check 3: Heavy functions in config
    if grep -q "function.*--on-event.*preexec" $config_file 2>/dev/null
        set_color green
        echo "  ✓ Good: Using event handlers efficiently"
        set_color normal
    end

    # Check 4: Slow startup time
    if test $startup_time -gt 500
        set has_issues 1
        set_color red
        echo "  ✗ Critical: Startup time is very slow (>500ms)"
        set_color normal
        echo "     Run 'profile_startup' for detailed analysis"
        echo ""
    else if test $startup_time -gt 200
        set has_issues 1
        set_color yellow
        echo "  ⚠ Warning: Startup time exceeds target (>200ms)"
        set_color normal
        echo "     Run 'profile_startup' to identify bottlenecks"
        echo ""
    else
        set_color green
        echo "  ✓ Excellent: Startup time is under 200ms target"
        set_color normal
        echo ""
    end

    # General tips
    echo "General Performance Tips:"
    echo ""
    echo "  1. Lazy Loading:"
    echo "     • Use autoloaded functions instead of sourcing"
    echo "     • Defer heavy operations until needed"
    echo ""
    echo "  2. Minimize Startup Work:"
    echo "     • Move PATH additions to one place"
    echo "     • Avoid running commands during startup"
    echo "     • Use 'if status is-interactive' for interactive-only code"
    echo ""
    echo "  3. Function Optimization:"
    echo "     • Use 'builtin' prefix for built-in commands"
    echo "     • Cache expensive computations"
    echo "     • Avoid unnecessary command substitutions"
    echo ""
    echo "  4. Event Handlers:"
    echo "     • Keep preexec/postexec handlers minimal"
    echo "     • Use global variables for state"
    echo "     • Avoid spawning processes in handlers"
    echo ""
    echo "  5. Plugin Management:"
    echo "     • Remove unused plugins"
    echo "     • Check plugin startup cost"
    echo "     • Consider plugin alternatives"
    echo ""

    # Tool suggestions
    echo "Performance Tools:"
    echo ""
    echo "  • fish_startup_time    - Measure startup time"
    echo "  • profile_startup      - Identify slow components"
    echo "  • profile_function     - Time specific functions"
    echo "  • show_slow_commands   - View slow command history"
    echo ""

    # Status summary
    if test $has_issues -eq 0
        set_color green
        echo "Summary: Your fish shell is well optimized!"
        set_color normal
    else
        set_color yellow
        echo "Summary: Some optimizations recommended"
        set_color normal
        echo "Run suggested commands above for detailed analysis"
    end

    echo ""
end
