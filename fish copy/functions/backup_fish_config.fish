function backup_fish_config --description 'Backup fish configuration to git'
    set -l config_dir ~/.config
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

    # Check if there are any changes to commit
    set -l git_status (git status --porcelain fish/)

    if test -z "$git_status"
        echo "No changes to backup in fish configuration"
        cd $prev_dir
        return 0
    end

    # Show what will be backed up
    echo "Fish configuration changes to backup:"
    git status --short fish/
    echo ""

    # Add all fish config files (respecting .gitignore)
    git add fish/

    # Create commit with timestamp
    set -l commit_message "backup: fish config - $timestamp"

    if git commit -m "$commit_message"
        echo "✓ Fish configuration backed up successfully"
        echo "Commit: $commit_message"
    else
        echo "Error: Failed to create backup commit"
        cd $prev_dir
        return 1
    end

    # Return to previous directory
    cd $prev_dir
    return 0
end
