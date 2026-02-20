# This function is sourced automatically by all_functions.fish
function giofetch
    set_color -o blue
    echo "🛰️👽 ---->>>>----M<<<<<---- 👽🛰️"
    set_color cyan
    echo "🔍📡 Fetching all references from all remotes..."
    set_color normal
    # Fetch all references from all remotes, prune deleted branches, and update tags
    for remote in (git remote)
        git fetch --prune --tags $remote 2>/dev/null
        set -l fetch_status $status
        if test $fetch_status -ne 0
            set_color red
            echo "❌ Fetch failed for $remote!"
            set_color normal
        else
            set_color green
            echo "✅ References updated for $remote"
            set_color normal
        end
    end
    set_color cyan
    echo "🌐 All remote references updated."
    set_color normal
end