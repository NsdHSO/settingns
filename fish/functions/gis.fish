function gis
    set_color -o blue
    echo "🔍 Git Status Report 📊"
    echo "----------------------"
    set_color normal
    set -l git_status (git status -b --porcelain=v2 2>/dev/null)
    set -l branch_info (string match -r "# branch.head (.+)" $git_status)[2]
    set -l upstream_info (string match -r "# branch.ab \\+([0-9]+) -([0-9]+)" $git_status)
    if test -n "$branch_info"
        set_color -o green
        echo "🌿 Branch: $branch_info"
        set_color normal
    end
    if test -n "$upstream_info"
        set -l ahead $upstream_info[2]
        set -l behind $upstream_info[3]
        if test $ahead -eq 0 -a $behind -eq 0
            set_color cyan
            echo "✨ Branch is up to date"
        else if test $behind -gt 0
            set_color yellow
            echo "⚠️ Branch needs pulling ($behind commits behind)"
        else if test $ahead -gt 0
            set_color magenta
            echo "🚀 Branch needs pushing ($ahead commits ahead)"
        end
    end
    set_color normal
    set -l status_lines (git status --porcelain 2>/dev/null)
    if test -z "$status_lines"
        set_color green
        echo "✅ Working tree clean"
    else
        set_color yellow
        echo "📝 Changes detected:"
        set_color normal
        git status --porcelain | while read -l line
            switch (echo $line | string sub -l 2)
                case "M*"
                    set_color cyan
                    echo "  🔄 Modified: "(echo $line | string sub -s 4)
                case "A*"
                    set_color green
                    echo "  ➕ Added: "(echo $line | string sub -s 4)
                case "D*"
                    set_color red
                    echo "  ❌ Deleted: "(echo $line | string sub -s 4)
                case "R*"
                    set_color magenta
                    echo "  ♻️  Renamed: "(echo $line | string sub -s 4)
                case "??"
                    set_color yellow
                    echo "  ❓ Untracked: "(echo $line | string sub -s 4)
                case "*"
                    set_color normal
                    echo "  "(echo $line | string sub -s 4)
            end
        end
    end
    set_color -o blue
    echo "----------------------"
    set_color normal
end
