function profile_function -d "Profile execution time of a specific function" -a function_name
    if test -z "$function_name"
        set_color red
        echo "Error: Function name required"
        set_color normal
        echo ""
        echo "Usage: profile_function <function_name> [args...]"
        echo "Example: profile_function gc \"my commit message\""
        return 1
    end

    # Check if function exists
    if not functions -q $function_name
        set_color red
        echo "Error: Function '$function_name' not found"
        set_color normal
        return 1
    end

    # Get remaining arguments
    set -l func_args $argv[2..-1]

    echo "Profiling function: $function_name"
    if test (count $func_args) -gt 0
        echo "Arguments: $func_args"
    end
    echo ""

    # Start timing
    set -l start_time (date +%s%N)

    # Execute the function
    if test (count $func_args) -gt 0
        $function_name $func_args
    else
        $function_name
    end

    set -l exit_status $status

    # End timing
    set -l end_time (date +%s%N)
    set -l duration_ns (math $end_time - $start_time)
    set -l duration_ms (math $duration_ns / 1000000)

    echo ""
    echo "Performance Report:"
    echo "  Function: $function_name"
    echo "  Duration: {$duration_ms}ms"

    if test $duration_ms -lt 100
        set_color green
        echo "  Speed: Fast (<100ms)"
    else if test $duration_ms -lt 1000
        set_color yellow
        echo "  Speed: Moderate (100-1000ms)"
    else
        set_color red
        echo "  Speed: Slow (>1s)"
    end
    set_color normal

    echo "  Exit Status: $exit_status"

    return $exit_status
end
