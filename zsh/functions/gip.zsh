# Git push with enhanced output formatting
function gip() {
    echo -e "\033[1;34m🚀 Git Push\033[0m"

    local remote_info=$(git remote 2>/dev/null)
    if [[ -z "$remote_info" ]]; then
        echo -e "\033[0;31m❌ No remote repository configured\033[0m"
        return 1
    fi

    # Detect force push
    local is_force=0
    for arg in "$@"; do
        if [[ "$arg" == "--force" || "$arg" == "-f" ]]; then
            is_force=1
        fi
    done

    if [[ $is_force -eq 1 ]]; then
        echo -e "\033[1;31m⚠️  Force push in progress!\033[0m"
    fi

    git push --progress "$@" 2>&1 | while IFS= read -r line; do
        case "$line" in
            *fatal:*|*error:*)
                echo -e "\033[0;31m❌ $line\033[0m"
                ;;
            *"Everything up-to-date"*)
                echo -e "\033[0;32m✨ Already in sync\033[0m"
                ;;
            *"Enumerating objects"*)
                echo -e "\033[0;33m📦 Preparing changes...\033[0m"
                ;;
            *"Counting objects"*|*"Compressing objects"*)
                # Silent - just processing
                ;;
            *"Writing objects"*)
                echo -e "\033[0;36m📤 Uploading changes...\033[0m"
                ;;
            *"remote: "*|*"To "*)
                if [[ "$line" == *"-> "* ]]; then
                    echo -e "\033[0;32m✅ Push complete\033[0m"
                fi
                ;;
            *)
                # Silent for other messages
                ;;
        esac
    done

    local push_status=$?
    if [[ $push_status -ne 0 ]]; then
        echo -e "\033[0;31m❌ Push failed\033[0m"
        return 1
    fi
}
