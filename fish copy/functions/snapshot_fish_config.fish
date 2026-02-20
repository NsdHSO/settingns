function snapshot_fish_config --description 'Create a pre-modification snapshot of fish configuration'
    set -l config_dir ~/.config
    set -l snapshot_name $argv[1]
    set -l timestamp (date +"%Y-%m-%d_%H:%M:%S")

    # Check if we're in a git repo
    if not test -d $config_dir/.git
        echo "Error: $config_dir is not a git repository"
        return 1
    end

    # Store current directory
    set -l prev_dir (pwd)

    # Change to config directory
    cd $config_dir

    # Check if there are any changes to snapshot
    set -l git_status (git status --porcelain fish/)

    if test -z "$git_status"
        echo "No changes to snapshot in fish configuration"
        cd $prev_dir
        return 0
    end

    # Create snapshot tag name
    if test -z "$snapshot_name"
        set -l tag_name "fish-snapshot-$timestamp"
    else
        set -l tag_name "fish-snapshot-$snapshot_name-$timestamp"
    end

    # Add all fish config files (respecting .gitignore)
    git add fish/

    # Create commit for snapshot
    set -l commit_message "snapshot: pre-modification backup - $snapshot_name - $timestamp"

    if git commit -m "$commit_message"
        echo "✓ Pre-modification snapshot created"
        echo "Commit: $commit_message"

        # Create a tag for easy restoration
        if git tag -a "$tag_name" -m "Pre-modification snapshot: $snapshot_name"
            echo "✓ Tag created: $tag_name"
            echo ""
            echo "To restore this snapshot later, run:"
            echo "  restore_fish_config $tag_name"
        end
    else
        echo "Error: Failed to create snapshot"
        cd $prev_dir
        return 1
    end

    # Return to previous directory
    cd $prev_dir
    return 0
end
