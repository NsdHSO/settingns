ylock() {
    local lockfiles=(pnpm-lock.yaml yarn.lock package-lock.json)
    local managers=(pnpm yarn npm)
    for i in {1..${#lockfiles[@]}}; do
        if [[ -f "${lockfiles[$i]}" ]]; then
            echo -e "\033[33m🧹 Removing ${lockfiles[$i]}...\033[0m"
            rm -f "${lockfiles[$i]}"
            echo -e "\033[36m📦 Installing with ${managers[$i]}...\033[0m"
            command ${managers[$i]} install
            return
        fi
    done
    echo -e "\033[31m❌ No lockfile found\033[0m"
    return 1
}
