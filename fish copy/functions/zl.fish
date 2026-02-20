# List zoxide tracked directories with scores
# Usage: zl [query]
# Shows all directories tracked by zoxide, optionally filtered by query

function zl -d "List zoxide tracked directories with scores"
    if not command -q zoxide
        echo "Error: zoxide is not installed"
        echo "Install with: brew install zoxide"
        return 1
    end

    if test (count $argv) -gt 0
        # Query with filter
        zoxide query -l -s $argv
    else
        # List all directories
        zoxide query -l -s
    end
end
