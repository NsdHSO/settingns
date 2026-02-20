function gip
    set_color -o blue
    echo "🚀 Git Push"
    set_color normal
    set -l remote_info (git remote 2>/dev/null)
    if test -z "$remote_info"
        set_color red
        echo "❌ No remote repository configured"
        set_color normal
        return 1
    end
    # Detect force push
    set -l is_force 0
    for arg in $argv
        if test "$arg" = "--force" -o "$arg" = "-f"
            set is_force 1
        end
    end
    if test $is_force -eq 1
        set_color -o red
        echo "⚠️  Force push in progress!"
        set_color normal
    end
    git push --progress $argv 2>&1 | while read -l line
        switch "$line"
            case "*fatal:*" "*error:*"
                set_color red
                echo "❌ $line"
            case "*Everything up-to-date*"
                set_color green
                echo "✨ Already in sync"
            case "*Enumerating objects*"
                set_color yellow
                echo "📦 Preparing changes..."
            case "*Counting objects*" "*Compressing objects*"
                true
            case "*Writing objects*"
                set_color cyan
                echo "📤 Uploading changes..."
            case "*remote: *" "*To *"
                if string match -q "*-> *" "$line"
                    set_color green
                    echo "✅ Push complete"
                end
            case "*"
                true
        end
    end
    set -l push_status $status
    if test $push_status -ne 0
        set_color red
        echo "❌ Push failed"
        set_color normal
        return 1
    end
    set_color normal
end