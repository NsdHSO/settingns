function toggle_fish_autobackup --description 'Enable or disable automatic daily fish configuration backup'
    set -l plist_source ~/.config/fish/hooks/com.fish.autobackup.plist
    set -l plist_target ~/Library/LaunchAgents/com.fish.autobackup.plist
    set -l action $argv[1]

    if test "$action" = "enable"
        # Copy plist to LaunchAgents
        if cp $plist_source $plist_target
            echo "✓ Copied plist to LaunchAgents"
        else
            echo "Error: Failed to copy plist"
            return 1
        end

        # Load the agent
        if launchctl load $plist_target
            echo "✓ Auto-backup enabled"
            echo "Fish configuration will be backed up daily at 23:59"
            echo ""
            echo "Logs location:"
            echo "  Output: ~/.config/fish/hooks/backup.log"
            echo "  Errors: ~/.config/fish/hooks/backup.error.log"
        else
            echo "Error: Failed to load launchd agent"
            return 1
        end

    else if test "$action" = "disable"
        # Unload the agent
        if test -f $plist_target
            if launchctl unload $plist_target
                echo "✓ Auto-backup disabled"
            else
                echo "Warning: Failed to unload launchd agent (it may not be loaded)"
            end

            # Remove the plist
            rm -f $plist_target
            echo "✓ Removed plist from LaunchAgents"
        else
            echo "Auto-backup is not enabled"
        end

    else if test "$action" = "status"
        # Check if enabled
        if test -f $plist_target
            echo "Auto-backup: ENABLED"
            echo "Daily backup time: 23:59"
            echo ""
            echo "Check if running:"
            launchctl list | grep com.fish.autobackup
        else
            echo "Auto-backup: DISABLED"
        end

    else
        echo "Usage: toggle_fish_autobackup [enable|disable|status]"
        echo ""
        echo "Commands:"
        echo "  enable  - Enable daily automatic backup at 23:59"
        echo "  disable - Disable automatic backup"
        echo "  status  - Check if auto-backup is enabled"
        return 1
    end

    return 0
end
