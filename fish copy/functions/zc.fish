# Clean up invalid paths from zoxide database
# Usage: zc
# Removes all non-existent directories from zoxide's database

function zc -d "Clean up invalid paths from zoxide database"
    if not command -q zoxide
        echo "Error: zoxide is not installed"
        echo "Install with: brew install zoxide"
        return 1
    end

    echo "Cleaning zoxide database..."
    set -l count 0

    # Get all tracked directories
    for dir in (zoxide query -l)
        if not test -d "$dir"
            echo "Removing invalid path: $dir"
            zoxide remove "$dir"
            set count (math $count + 1)
        end
    end

    if test $count -eq 0
        echo "No invalid paths found. Database is clean!"
    else
        echo "Removed $count invalid path(s) from zoxide database"
    end
end
