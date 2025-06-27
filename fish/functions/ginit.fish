function ginit
    if test -d .git
        rm -rf .git/hooks
        set_color yellow
        echo "🧹 Removed existing git hooks"
        set_color normal
    end
    git init
    set_color green
    echo "✅ Git repository initialized"
    set_color normal
    if test -d hooks/hooks
        cp -R hooks/hooks/. .git/hooks/
        set_color cyan
        echo "🔗 Custom hooks copied to .git/hooks"
        set_color normal
    end
end
