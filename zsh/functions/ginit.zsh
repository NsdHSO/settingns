function ginit() {
    if [[ -d .git ]]; then
        rm -rf .git/hooks
        echo -e "\033[33m🧹 Removed existing git hooks\033[0m"
    fi
    git init
    echo -e "\033[32m✅ Git repository initialized without hooks\033[0m"
}
