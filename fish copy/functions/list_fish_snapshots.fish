function list_fish_snapshots --description 'List all fish configuration snapshots and backups'
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

    echo "Fish Configuration Snapshots:"
    echo "=============================="
    echo ""

    # List snapshot tags
    set -l snapshot_tags (git tag -l "fish-snapshot-*" | sort -r)

    if test (count $snapshot_tags) -gt 0
        echo "Snapshot Tags:"
        for tag in $snapshot_tags
            # Get tag creation date and message
            set -l tag_info (git tag -l --format="%(creatordate:short) - %(contents:subject)" $tag)
            echo "  $tag"
            echo "    $tag_info"
        end
        echo ""
    else
        echo "No snapshot tags found"
        echo ""
    end

    # List recent backup commits
    echo "Recent Backup Commits (last 10):"
    git log --oneline --grep="backup: fish config" -10 --

    echo ""
    echo "To restore from a snapshot, run:"
    echo "  restore_fish_config <tag-name or commit-hash>"

    # Return to previous directory
    cd $prev_dir
    return 0
end
