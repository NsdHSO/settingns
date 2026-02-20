# Advanced Error Handler with Phenomenon Colors
# Provides consistent error formatting, suggestions, and recovery

function error_handler
    set -l error_type $argv[1]
    set -l error_details $argv[2..-1]

    # Use Phenomenon colors from config
    set -l error_color $phenomenon_error      # EF4444 (Red)
    set -l warn_color F59E0B                  # Warning amber
    set -l info_color $phenomenon_git_info    # 3B82F6 (Blue)
    set -l success_color $phenomenon_success  # 22C55E (Green)

    switch $error_type
        case missing_tool
            set -l tool_name $error_details[1]
            set -l fallback $error_details[2]

            set_color $error_color
            echo "✗ Error: '$tool_name' is not installed"
            set_color normal

            if test -n "$fallback"
                set_color $warn_color
                echo "→ Using fallback: $fallback"
                set_color normal
                return 0
            else
                set_color $info_color
                echo "→ Install with: brew install $tool_name"
                set_color normal
                return 1
            end

        case missing_arg
            set -l function_name $error_details[1]
            set -l expected_args $error_details[2]

            set_color $error_color
            echo "✗ Missing argument"
            set_color normal
            set_color $info_color
            echo "→ Usage: $function_name $expected_args"
            set_color normal
            return 1

        case invalid_arg
            set -l arg_value $error_details[1]
            set -l arg_type $error_details[2]

            set_color $error_color
            echo "✗ Invalid argument: '$arg_value'"
            set_color normal
            set_color $info_color
            echo "→ Expected: $arg_type"
            set_color normal
            return 1

        case typo_suggestion
            set -l typed_command $error_details[1]
            set -l suggestions $error_details[2..-1]

            set_color $error_color
            echo "✗ Unknown command: '$typed_command'"
            set_color normal

            if test (count $suggestions) -gt 0
                set_color $warn_color
                echo "→ Did you mean:"
                set_color normal
                for suggestion in $suggestions
                    set_color $info_color
                    echo "  • $suggestion"
                    set_color normal
                end
            end
            return 1

        case git_not_repo
            set_color $error_color
            echo "✗ Not a git repository"
            set_color normal
            set_color $info_color
            echo "→ Initialize with: git init"
            set_color normal
            return 1

        case no_lockfile
            set_color $error_color
            echo "✗ No package lockfile found"
            set_color normal
            set_color $info_color
            echo "→ Create one with: npm install, yarn install, or pnpm install"
            set_color normal
            return 1

        case permission_denied
            set -l resource $error_details[1]
            set_color $error_color
            echo "✗ Permission denied: $resource"
            set_color normal
            set_color $info_color
            echo "→ Try with sudo or check file permissions"
            set_color normal
            return 1

        case not_found
            set -l resource_type $error_details[1]
            set -l resource_name $error_details[2]
            set_color $error_color
            echo "✗ $resource_type not found: $resource_name"
            set_color normal
            return 1

        case success_recovery
            set -l message $error_details[1..-1]
            set_color $success_color
            echo "✓ $message"
            set_color normal
            return 0

        case custom
            set -l message $error_details[1..-1]
            set_color $error_color
            echo "✗ $message"
            set_color normal
            return 1

        case '*'
            set_color $error_color
            echo "✗ Unknown error type: $error_type"
            set_color normal
            return 1
    end
end
