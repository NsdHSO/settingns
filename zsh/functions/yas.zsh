yas() {
    local managers=(pnpm yarn npm)
    local lockfiles=(pnpm-lock.yaml yarn.lock package-lock.json)
    for i in {1..${#lockfiles[@]}}; do
        if [[ -f "${lockfiles[$i]}" ]]; then
            echo -e "\033[36m🚀 Starting with ${managers[$i]}...\033[0m"
            command ${managers[$i]} start
            return
        fi
    done
    echo -e "\033[31m❌ No lockfile found\033[0m"
    return 1
}
