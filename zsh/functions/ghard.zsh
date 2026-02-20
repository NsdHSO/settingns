function ghard() {
    echo -e "\033[33m⚠️  WARNING: This will delete all local changes!\033[0m"
    echo "📁 Current directory: $(pwd)"
    echo -en "\033[33m🔥 Press ENTER to confirm (or type 'n' to cancel): \033[0m"
    read confirm
    if [[ -z "$confirm" || "$confirm" == "y" || "$confirm" == "yes" ]]; then
        echo -e "\033[31m💣 Resetting all changes...\033[0m"
        git reset --hard
        echo -e "\033[32m✨ Reset complete. All changes have been discarded.\033[0m"
    else
        echo -e "\033[36m🛟 Operation cancelled. Your changes are safe.\033[0m"
    fi
}
