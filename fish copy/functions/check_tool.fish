# Tool Checker with Graceful Fallbacks
# Verifies tool availability and suggests fallbacks

function check_tool
    set -l tool_name $argv[1]
    set -l fallback_tool $argv[2]
    set -l auto_install $argv[3] # "auto" to automatically install

    # Check if primary tool exists
    if command -q $tool_name
        return 0
    end

    # Primary tool not found, try fallback
    if test -n "$fallback_tool"
        if command -q $fallback_tool
            error_handler missing_tool $tool_name $fallback_tool
            echo $fallback_tool
            return 0
        end
    end

    # Auto-install if requested
    if test "$auto_install" = "auto"
        if command -q brew
            set_color $phenomenon_symbols
            echo "→ Installing $tool_name via Homebrew..."
            set_color normal

            if brew install $tool_name 2>/dev/null
                error_handler success_recovery "$tool_name installed successfully"
                return 0
            else
                error_handler custom "Failed to auto-install $tool_name"
                return 1
            end
        else
            error_handler missing_tool $tool_name
            set_color $phenomenon_git_info
            echo "→ Auto-install requires Homebrew"
            set_color normal
            return 1
        end
    else
        # No fallback or auto-install
        error_handler missing_tool $tool_name
        return 1
    end
end
