function restore_fish_config --description 'Restore fish configuration from git backup'
    set -l config_dir ~/.config

    # Check if we're in a git repo
    if not test -d $config_dir/.git
        echo "Error: $config_dir is not a git repository"
        return 1
    end

    # Store current directory
    set -l prev_dir (pwd)

    # Change to config directory
    cd $config_dir

    # Check for uncommitted changes
    set -l git_status (git status --porcelain fish/)

    if test -n "$git_status"
        echo "Warning: You have uncommitted changes in fish configuration:"
        git status --short fish/
        echo ""
        read -l -P "Do you want to discard these changes and restore from backup? [y/N] " confirm

        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Restore cancelled"
            cd $prev_dir
            return 1
        end
    end

    # Parse arguments for specific commit/tag
    set -l target "HEAD"
    if test (count $argv) -gt 0
        set target $argv[1]
    end

    echo "Restoring fish configuration from: $target"

    # Restore fish directory from git
    if git checkout $target -- fish/
        echo "✓ Fish configuration restored successfully from $target"

        # Show what was restored
        echo ""
        echo "Restored files:"
        git diff --name-status HEAD fish/
    else
        echo "Error: Failed to restore fish configuration"
        cd $prev_dir
        return 1
    end

    # Return to previous directory
    cd $prev_dir
    return 0
end
