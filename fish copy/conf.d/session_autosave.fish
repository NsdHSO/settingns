# Session Auto-Save Configuration

# Enable/disable auto-save on exit
# Set to 1 to enable, 0 to disable
set -g SESSION_AUTOSAVE_ENABLED 0

# Default session name for auto-save (uses current directory name if empty)
set -g SESSION_AUTOSAVE_NAME ""

# Auto-save on shell exit
function __session_autosave_on_exit --on-event fish_exit
    if test $SESSION_AUTOSAVE_ENABLED -eq 1
        # Determine session name
        set -l session_name $SESSION_AUTOSAVE_NAME
        if test -z "$session_name"
            set session_name (basename $PWD)
        end

        # Auto-save session quietly
        session_save --auto $session_name 2>/dev/null
    end
end

# Helper function to enable auto-save
function session_autosave_enable -d "Enable automatic session saving on exit"
    set -g SESSION_AUTOSAVE_ENABLED 1
    echo "Session auto-save enabled"
    echo "Sessions will be automatically saved when you exit the shell"
    echo "Disable with: session_autosave_disable"
end

# Helper function to disable auto-save
function session_autosave_disable -d "Disable automatic session saving on exit"
    set -g SESSION_AUTOSAVE_ENABLED 0
    echo "Session auto-save disabled"
end

# Helper function to set auto-save session name
function session_autosave_name -d "Set the default session name for auto-save"
    if test (count $argv) -eq 0
        echo "Current auto-save session name: $SESSION_AUTOSAVE_NAME"
        echo "Usage: session_autosave_name <name>"
        return 1
    end

    set -g SESSION_AUTOSAVE_NAME $argv[1]
    echo "Auto-save session name set to: $SESSION_AUTOSAVE_NAME"
end
