# Git commit wrapper function with conventional commits
function gc() {
    if [[ $# -lt 2 ]]; then
        echo -e "\033[0;31m❌ Usage: gc <type> <message>\033[0m"
        return 1
    fi

    local input_type="${1:l}"  # Convert to lowercase
    local message="${@:2}"

    local type=""
    local emoji=""
    local color=""

    case "$input_type" in
        f|feat)
            type="feat"
            emoji="🎸"
            color="green"
            ;;
        fi|fix)
            type="fix"
            emoji="🛠️"
            color="yellow"
            ;;
        d|docs)
            type="docs"
            emoji="📝"
            color="blue"
            ;;
        s|style)
            type="style"
            emoji="🎨"
            color="magenta"
            ;;
        t|test)
            type="test"
            emoji="🐳"
            color="green"
            ;;
        c|chore)
            type="chore"
            emoji="🌻"
            color="cyan"
            ;;
        p|perf)
            type="perf"
            emoji="🚀"
            color="blue"
            ;;
        r|ref|refactor)
            type="refactor"
            emoji="👷"
            color="cyan"
            ;;
        revert)
            type="revert"
            emoji="⏪"
            color="red"
            ;;
        *)
            type="$input_type"
            ;;
    esac

    if [[ -z "$emoji" || -z "$color" ]]; then
        echo -e "\033[0;31m❌ Unknown commit type: $input_type\033[0m"
        return 1
    fi

    # Capitalize if input was uppercase
    if [[ "$1" =~ ^[A-Z] ]]; then
        type="${(U)type:0:1}${type:1}"
    fi

    case "$color" in
        green)   echo -e "\033[0;32m📝 Committing changes...\033[0m" ;;
        yellow)  echo -e "\033[0;33m📝 Committing changes...\033[0m" ;;
        blue)    echo -e "\033[0;34m📝 Committing changes...\033[0m" ;;
        magenta) echo -e "\033[0;35m📝 Committing changes...\033[0m" ;;
        cyan)    echo -e "\033[0;36m📝 Committing changes...\033[0m" ;;
        red)     echo -e "\033[0;31m📝 Committing changes...\033[0m" ;;
    esac

    git commit -m "$type: $emoji $message"
    local commit_status=$?

    if [[ $commit_status -eq 0 ]]; then
        echo -e "\033[0;32m✅ Commit successful!\033[0m"
        echo -e "\033[0;32m🏷️  $type: $emoji $message\033[0m"
    else
        echo -e "\033[0;31m❌ Commit failed!\033[0m"
    fi
}
