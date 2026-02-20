function profile_startup -d "Profile fish shell startup and identify slow components"
    echo "Profiling fish shell startup..."
    echo ""

    # Create temporary profile script
    set -l profile_script /tmp/fish_profile_(random).fish

    # Write profiling commands
    echo '# Fish startup profiler' > $profile_script
    echo 'set -l start_time (date +%s%N)' >> $profile_script
    echo '' >> $profile_script

    # Profile config.fish loading
    echo 'echo "Loading config.fish..."' >> $profile_script
    echo 'set -l config_start (date +%s%N)' >> $profile_script

    # Profile conf.d files
    set -l conf_d_path ~/.config/fish/conf.d
    if test -d $conf_d_path
        echo "Found conf.d directory, profiling files..."
        for conf_file in $conf_d_path/*.fish
            if test -f $conf_file
                set -l basename (basename $conf_file)
                echo "  - $basename"
            end
        end
        echo ""
    end

    # Profile functions directory
    echo "Analyzing functions directory..."
    set -l functions_path ~/.config/fish/functions
    if test -d $functions_path
        set -l func_count (count $functions_path/*.fish)
        echo "  Total functions: $func_count"
        echo ""
    end

    # Run actual startup profiling
    echo "Running timed startup..."
    set -l start_time (date +%s%N)
    fish -c 'exit' 2>&1
    set -l end_time (date +%s%N)
    set -l total_time (math $end_time - $start_time)
    set -l total_ms (math $total_time / 1000000)

    echo ""
    echo "Startup Analysis:"
    echo "  Total startup time: {$total_ms}ms"
    echo ""

    # Analyze specific components
    echo "Component Analysis:"

    # Check config.fish complexity
    set -l config_lines (wc -l < ~/.config/fish/config.fish | string trim)
    echo "  config.fish: $config_lines lines"

    # Check if heavy operations in config.fish
    echo ""
    echo "Potential bottlenecks in config.fish:"

    set -l bottlenecks 0

    # Check for eval calls
    if grep -q "eval" ~/.config/fish/config.fish 2>/dev/null
        set bottlenecks (math $bottlenecks + 1)
        set_color yellow
        echo "  ⚠ eval commands detected (can be slow)"
        set_color normal
    end

    # Check for command substitutions
    set -l cmd_subs (grep -c '\$(' ~/.config/fish/config.fish 2>/dev/null)
    if test $cmd_subs -gt 10
        set bottlenecks (math $bottlenecks + 1)
        set_color yellow
        echo "  ⚠ Many command substitutions: $cmd_subs (consider lazy loading)"
        set_color normal
    end

    # Check for sourcing files
    set -l sources (grep -c 'source' ~/.config/fish/config.fish 2>/dev/null)
    if test $sources -gt 5
        set bottlenecks (math $bottlenecks + 1)
        set_color yellow
        echo "  ⚠ Multiple source commands: $sources"
        set_color normal
    end

    if test $bottlenecks -eq 0
        set_color green
        echo "  ✓ No obvious bottlenecks detected"
        set_color normal
    end

    echo ""
    echo "Optimization Suggestions:"

    if test $total_ms -gt 200
        set_color yellow
        echo "  1. Consider lazy-loading functions (use autoload)"
        echo "  2. Move heavy operations to background or on-demand"
        echo "  3. Use 'builtin' prefix for built-in commands"
        echo "  4. Minimize command substitutions in config.fish"
        echo "  5. Consider removing unused plugins"
        set_color normal
    else
        set_color green
        echo "  ✓ Startup time is within target (<200ms)"
        echo "  No optimizations needed at this time"
        set_color normal
    end

    # Clean up
    rm -f $profile_script 2>/dev/null

    echo ""
    echo "For more details, run: fish --profile <output_file> -c exit"
end
