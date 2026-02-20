function ginit
    if test -d .git
        rm -rf .git/hooks
        set_color yellow
        echo "🧹 Removed existing git hooks"
        set_color normal
    end
    git init
    set_color green
    echo "✅ Git repository initialized without hooks"
    set_color normal
end
