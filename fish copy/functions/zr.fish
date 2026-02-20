# Remove a directory from zoxide database
# Usage: zr <path>
# Removes the specified path from zoxide's tracking

function zr -d "Remove a directory from zoxide database"
    if not command -q zoxide
        echo "Error: zoxide is not installed"
        echo "Install with: brew install zoxide"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: zr <path>"
        echo "Remove a directory from zoxide database"
        return 1
    end

    zoxide remove $argv
    and echo "Removed from zoxide: $argv"
end
