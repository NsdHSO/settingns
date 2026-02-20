# Advanced Error Handling Examples
# Demonstrates all error handling patterns with Phenomenon colors

function error_examples
    set_color $phenomenon_git_info
    echo "=== Advanced Error Handling Examples ==="
    echo ""
    set_color normal

    # Example 1: Missing Tool with Fallback
    set_color $phenomenon_time
    echo "1. Tool Check with Fallback (bat → cat)"
    set_color normal

    set -l viewer (check_tool bat cat)
    if test $status -eq 0
        echo "Using viewer: $viewer"
    end
    echo ""

    # Example 2: Missing Required Argument
    set_color $phenomenon_time
    echo "2. Missing Argument Error"
    set_color normal

    error_handler missing_arg my_function "<required_arg> [optional_arg]"
    echo ""

    # Example 3: Invalid Argument Type
    set_color $phenomenon_time
    echo "3. Invalid Argument Type"
    set_color normal

    error_handler invalid_arg "abc123" "numeric port number"
    echo ""

    # Example 4: Typo Suggestion
    set_color $phenomenon_time
    echo "4. Command Typo Suggestions"
    set_color normal

    suggest_command "serv" service server servlet
    echo ""

    # Example 5: Git Repository Check
    set_color $phenomenon_time
    echo "5. Git Repository Validation"
    set_color normal

    error_handler git_not_repo
    echo ""

    # Example 6: No Lockfile Found
    set_color $phenomenon_time
    echo "6. Package Lockfile Missing"
    set_color normal

    error_handler no_lockfile
    echo ""

    # Example 7: Permission Denied
    set_color $phenomenon_time
    echo "7. Permission Denied"
    set_color normal

    error_handler permission_denied "/etc/system_file"
    echo ""

    # Example 8: Resource Not Found
    set_color $phenomenon_time
    echo "8. Resource Not Found"
    set_color normal

    error_handler not_found "configuration file" ".env"
    echo ""

    # Example 9: Success Recovery
    set_color $phenomenon_time
    echo "9. Successful Recovery"
    set_color normal

    error_handler success_recovery "Tool installed and configured successfully"
    echo ""

    # Example 10: Custom Error Message
    set_color $phenomenon_time
    echo "10. Custom Error"
    set_color normal

    error_handler custom "Database connection timeout after 30 seconds"
    echo ""

    set_color $phenomenon_success
    echo "=== Examples Complete ==="
    set_color normal
end

# Example: Smart file viewer with fallback
function smart_view
    set -l file $argv[1]

    if test -z "$file"
        error_handler missing_arg smart_view "<file>"
        return 1
    end

    if not test -f "$file"
        error_handler not_found "file" "$file"
        return 1
    end

    # Try bat first, fallback to cat
    set -l viewer (check_tool bat cat)
    if test $status -eq 0
        command $viewer $file
    else
        error_handler missing_tool "bat or cat"
        return 1
    end
end

# Example: Safe directory operations
function safe_mkdir
    set -l dir_name $argv[1]

    if test -z "$dir_name"
        error_handler missing_arg safe_mkdir "<directory_name>"
        return 1
    end

    # Validate directory name
    if not string match -rq '^[a-zA-Z0-9_-]+$' -- $dir_name
        error_handler invalid_arg $dir_name "valid directory name (letters, numbers, hyphens, underscores)"
        return 1
    end

    if test -d "$dir_name"
        error_handler custom "Directory '$dir_name' already exists"
        set_color $phenomenon_git_info
        echo "→ Use a different name or remove the existing directory"
        set_color normal
        return 1
    end

    if mkdir -p "$dir_name"
        error_handler success_recovery "Directory '$dir_name' created"
        return 0
    else
        error_handler permission_denied "$dir_name"
        return 1
    end
end

# Example: Git-aware command
function git_safe_command
    if not git rev-parse --git-dir &>/dev/null
        error_handler git_not_repo
        return 1
    end

    set -l branch (git branch --show-current 2>/dev/null)

    if test -z "$branch"
        error_handler custom "Detached HEAD state"
        set_color $phenomenon_git_info
        echo "→ Checkout a branch first: git checkout <branch>"
        set_color normal
        return 1
    end

    if test "$branch" = "main" -o "$branch" = "master"
        set_color $phenomenon_symbols
        echo "⚠ Warning: Operating on protected branch '$branch'"
        read -l -P "→ Continue? [y/N] " confirm
        set_color normal

        if test "$confirm" != "y" -a "$confirm" != "Y"
            set_color $phenomenon_time
            echo "→ Operation cancelled"
            set_color normal
            return 1
        end
    end

    error_handler success_recovery "Safe to proceed on branch '$branch'"
    return 0
end
