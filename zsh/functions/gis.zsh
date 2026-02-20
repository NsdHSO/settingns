# Git status with enhanced formatting
function gis() {
    echo -e "\033[1;34m🔍 Git Status Report 📊\033[0m"
    echo "----------------------"

    local git_status=$(git status -b --porcelain=v2 2>/dev/null)
    local branch_info=$(echo "$git_status" | grep "# branch.head" | sed 's/# branch.head //')
    local upstream_info=$(echo "$git_status" | grep "# branch.ab")

    if [[ -n "$branch_info" ]]; then
        echo -e "\033[1;32m🌿 Branch: $branch_info\033[0m"
    fi

    if [[ -n "$upstream_info" ]]; then
        local ahead=$(echo "$upstream_info" | sed -n 's/# branch.ab +\([0-9]*\) -.*/\1/p')
        local behind=$(echo "$upstream_info" | sed -n 's/# branch.ab +[0-9]* -\([0-9]*\)/\1/p')

        if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
            echo -e "\033[0;36m✨ Branch is up to date\033[0m"
        elif [[ "$behind" -gt 0 ]]; then
            echo -e "\033[0;33m⚠️ Branch needs pulling ($behind commits behind)\033[0m"
        elif [[ "$ahead" -gt 0 ]]; then
            echo -e "\033[0;35m🚀 Branch needs pushing ($ahead commits ahead)\033[0m"
        fi
    fi

    local status_lines=$(git status --porcelain 2>/dev/null)

    if [[ -z "$status_lines" ]]; then
        echo -e "\033[0;32m✅ Working tree clean\033[0m"
    else
        echo -e "\033[0;33m📝 Changes detected:\033[0m"

        echo "$status_lines" | while IFS= read -r line; do
            local status_code="${line:0:2}"
            local file_name="${line:3}"

            case "$status_code" in
                M*)
                    echo -e "\033[0;36m  🔄 Modified: $file_name\033[0m"
                    ;;
                A*)
                    echo -e "\033[0;32m  ➕ Added: $file_name\033[0m"
                    ;;
                D*)
                    echo -e "\033[0;31m  ❌ Deleted: $file_name\033[0m"
                    ;;
                R*)
                    echo -e "\033[0;35m  ♻️  Renamed: $file_name\033[0m"
                    ;;
                \?\?)
                    echo -e "\033[0;33m  ❓ Untracked: $file_name\033[0m"
                    ;;
                *)
                    echo "  $file_name"
                    ;;
            esac
        done
    fi

    echo -e "\033[1;34m----------------------\033[0m"
}
