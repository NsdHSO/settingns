function ghard
    set_color yellow
    echo "⚠️  WARNING: This will delete all local changes!"
    echo "📁 Current directory: "(pwd)
    set_color normal
    read -l -P "🔥 Press ENTER to confirm (or type 'n' to cancel): " confirm
    if test -z "$confirm" -o "$confirm" = "y" -o "$confirm" = "yes"
        set_color red
        echo "💣 Resetting all changes..."
        git reset --hard
        set_color green
        echo "✨ Reset complete. All changes have been discarded."
        set_color normal
    else
        set_color cyan
        echo "🛟 Operation cancelled. Your changes are safe."
        set_color normal
    end
end
