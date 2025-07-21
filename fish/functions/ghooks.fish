function ghooks
    # Check if we're in a Git repository
    if not test -d .git
        set_color red
        echo "❌ Not a git repository"
        set_color normal
        return 1
    end
    
    # Create hooks directory if it doesn't exist
    if not test -d .git/hooks
        mkdir -p .git/hooks
    end
    
    # Copy system hooks to .git/hooks
    if test -d $HOME/.config/fish/hooks/hooks
        cp -R $HOME/.config/fish/hooks/hooks/. .git/hooks/
        chmod +x .git/hooks/* 2>/dev/null
        set_color cyan
        echo "🔗 System custom hooks copied to .git/hooks"
        set_color normal
    else
        set_color red
        echo "❌ No hooks found in $HOME/.config/fish/hooks/hooks"
        set_color normal
        return 1
    end
    
    # Check for custom hooks path
    set -l custom_hooks_path (git config --get core.hooksPath)
    if test -n "$custom_hooks_path"
        set_color yellow
        echo "⚠️ This repository uses a custom hooks path: $custom_hooks_path"
        echo "   Your custom hooks in .git/hooks won't be used unless you run:"
        echo "   git config --unset core.hooksPath"
        set_color normal
    else
        set_color green
        echo "✅ Git hooks are active and will be used"
        set_color normal
    end
end
