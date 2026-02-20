function giofetch() {
    echo "\033[1;34m🛰️👽 ---->>>>----M<<<<<---- 👽🛰️\033[0m"
    echo "\033[36m🔍📡 Fetching all references from all remotes...\033[0m"
    # Fetch all references from all remotes, prune deleted branches, and update tags
    for remote in $(git remote); do
        git fetch --prune --tags $remote 2>/dev/null
        local fetch_status=$?
        if [[ $fetch_status -ne 0 ]]; then
            echo "\033[31m❌ Fetch failed for $remote!\033[0m"
        else
            echo "\033[32m✅ References updated for $remote\033[0m"
        fi
    done
    echo "\033[36m🌐 All remote references updated.\033[0m"
}
