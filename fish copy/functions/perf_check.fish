function perf_check -d "Quick performance health check"
    echo "Fish Shell Performance Health Check"
    echo "═════════════════════════════════════"
    echo ""

    set -l issues 0
    set -l warnings 0

    # 1. Measure startup time
    echo "[1/5] Measuring startup time..."
    set -l start (date +%s%N)
    fish -c exit 2>/dev/null
    set -l end (date +%s%N)
    set -l startup_ms (math \( $end - $start \) / 1000000)

    echo "      Result: {$startup_ms}ms"
    if test $startup_ms -lt 200
        set_color green
        echo "      ✓ PASS: Under 200ms target"
        set_color normal
    else if test $startup_ms -lt 500
        set warnings (math $warnings + 1)
        set_color yellow
        echo "      ⚠ WARN: Exceeds 200ms target"
        set_color normal
    else
        set issues (math $issues + 1)
        set_color red
        echo "      ✗ FAIL: Critical (>500ms)"
        set_color normal
    end
    echo ""

    # 2. Check config.fish complexity
    echo "[2/5] Analyzing config.fish..."
    set -l config_file ~/.config/fish/config.fish
    set -l config_lines (wc -l < $config_file | string trim)
    echo "      Lines: $config_lines"

    if test $config_lines -gt 200
        set warnings (math $warnings + 1)
        set_color yellow
        echo "      ⚠ WARN: Large config file (consider splitting)"
        set_color normal
    else
        set_color green
        echo "      ✓ PASS: Config size reasonable"
        set_color normal
    end
    echo ""

    # 3. Check for performance bottlenecks
    echo "[3/5] Checking for bottlenecks..."

    set -l eval_count (grep -c "eval" $config_file 2>/dev/null)
    if test $eval_count -gt 5
        set warnings (math $warnings + 1)
        set_color yellow
        echo "      ⚠ WARN: $eval_count eval commands found"
        set_color normal
    else
        echo "      eval commands: $eval_count"
        set_color green
        echo "      ✓ PASS"
        set_color normal
    end
    echo ""

    # 4. Check function count
    echo "[4/5] Checking loaded functions..."
    set -l func_count (functions -n | wc -l | string trim)
    echo "      Total: $func_count functions"

    if test $func_count -gt 200
        set warnings (math $warnings + 1)
        set_color yellow
        echo "      ⚠ WARN: Many functions loaded (consider lazy loading)"
        set_color normal
    else
        set_color green
        echo "      ✓ PASS"
        set_color normal
    end
    echo ""

    # 5. Check for slow commands
    echo "[5/5] Checking slow command history..."
    if test -f ~/.config/fish/slow_commands.log
        set -l slow_count (wc -l < ~/.config/fish/slow_commands.log | string trim)
        if test $slow_count -gt 0
            echo "      Found: $slow_count slow commands logged"
            set_color cyan
            echo "      ℹ INFO: Run 'perf slow' to view"
            set_color normal
        else
            echo "      None logged"
        end
    else
        echo "      No slow commands logged yet"
    end
    echo ""

    # Summary
    echo "═════════════════════════════════════"
    echo "Summary:"
    echo ""

    if test $issues -eq 0 -a $warnings -eq 0
        set_color green
        echo "  ✓ EXCELLENT: No issues found!"
        echo "  Your fish shell is well optimized."
        set_color normal
    else if test $issues -eq 0
        set_color yellow
        echo "  ⚠ GOOD: $warnings warning(s) found"
        echo "  Minor optimizations recommended."
        echo ""
        echo "  Next steps:"
        echo "    • Run 'perf tips' for suggestions"
        set_color normal
    else
        set_color red
        echo "  ✗ NEEDS ATTENTION: $issues issue(s), $warnings warning(s)"
        echo "  Performance optimization required."
        echo ""
        echo "  Next steps:"
        echo "    • Run 'perf profile' for detailed analysis"
        echo "    • Run 'perf tips' for optimization guide"
        set_color normal
    end

    echo ""
    echo "Performance Tools:"
    echo "  perf status   - Dashboard view"
    echo "  perf profile  - Detailed analysis"
    echo "  perf tips     - Optimization guide"
    echo ""
end
