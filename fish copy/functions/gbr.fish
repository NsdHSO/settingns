function gbr --description 'Interactive branch switcher using fzf'
    # Check if fzf is installed
    if not command -v fzf >/dev/null 2>&1
        echo "Error: fzf is not installed. Install it with: brew install fzf"
        return 1
    end

    # Get current branch
    set current_branch (git branch --show-current 2>/dev/null)

    if test $status -ne 0
        echo "Error: Not in a git repository"
        return 1
    end

    # Get all branches and select with fzf
    set selected_branch (git branch --all --format='%(refname:short)' | \
        sed 's/origin\///' | \
        sort -u | \
        grep -v "^$current_branch\$" | \
        fzf --height=40% \
            --reverse \
            --border \
            --prompt="Switch to branch: " \
            --preview="git log --oneline --graph --color=always --max-count=20 {}" \
            --preview-window=right:60%)

    if test -n "$selected_branch"
        # Check if it's a remote branch
        if git show-ref --verify --quiet "refs/heads/$selected_branch"
            # Local branch exists
            git checkout $selected_branch
        else if git show-ref --verify --quiet "refs/remotes/origin/$selected_branch"
            # Remote branch exists, create local tracking branch
            git checkout -b $selected_branch --track "origin/$selected_branch"
        else
            echo "Error: Branch '$selected_branch' not found"
            return 1
        end
    end
end
