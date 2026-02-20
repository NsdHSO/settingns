# Fuzzy Git Branch Selection
# Usage: fgb - select and checkout a git branch using fzf

function fgb --description "Fuzzy find and checkout git branch"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        set_color --bold red
        echo "Error: Not in a git repository"
        set_color normal
        return 1
    end

    # Get all branches (local and remote), format them, and let user select
    set -l branch (git branch -a --format='%(refname:short)' | \
        sed 's/^origin\///' | \
        sort -u | \
        fzf --prompt="Select branch: " \
            --preview="git log --oneline --graph --date=short --pretty='format:%C(auto)%cd %h%d %s' {} | head -50" \
            --preview-window=right:60% \
            --height=50% \
            --border \
            --ansi)

    # If a branch was selected, check it out
    if test -n "$branch"
        set_color --bold magenta
        echo "Checking out: $branch"
        set_color normal

        # Remove 'remotes/origin/' prefix if present
        set branch (string replace "remotes/origin/" "" $branch)

        git checkout $branch
    else
        set_color yellow
        echo "No branch selected"
        set_color normal
    end
end
