function run_tests --description "Run all fish function tests using fishtape"
    set -l test_dir ~/.config/fish/tests

    # Check if fishtape is installed
    if not type -q fishtape
        set_color red
        echo "Error: fishtape is not installed!"
        echo "Install it with: fisher install jorgebucaran/fishtape"
        set_color normal
        return 1
    end

    # Check if tests directory exists
    if not test -d $test_dir
        set_color red
        echo "Error: Tests directory not found at $test_dir"
        set_color normal
        return 1
    end

    set -l test_files $test_dir/*.test.fish

    if test (count $test_files) -eq 0
        set_color yellow
        echo "No test files found in $test_dir"
        set_color normal
        return 0
    end

    set_color cyan
    echo "Running Fish Function Tests..."
    echo "=============================="
    set_color normal

    set -l total_tests 0
    set -l failed_tests 0

    for test_file in $test_files
        set_color blue
        echo ""
        echo "Running: "(basename $test_file)
        set_color normal

        if fishtape $test_file
            set_color green
            echo "  PASSED"
            set_color normal
        else
            set_color red
            echo "  FAILED"
            set failed_tests (math $failed_tests + 1)
            set_color normal
        end

        set total_tests (math $total_tests + 1)
    end

    echo ""
    set_color cyan
    echo "=============================="
    echo "Test Summary:"
    set_color normal
    echo "  Total test files: $total_tests"

    if test $failed_tests -eq 0
        set_color green
        echo "  All tests PASSED!"
        set_color normal
        return 0
    else
        set_color red
        echo "  Failed tests: $failed_tests"
        set_color normal
        return 1
    end
end
