function gwt --description 'Git worktree helper with interactive management'
    set subcommand $argv[1]

    # Check if in git repo
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    switch $subcommand
        case list ls l
            # List all worktrees with enhanced formatting
            git worktree list | awk '{
                path = $1
                commit = $2
                branch = substr($0, index($0, $3))
                printf "%-50s %-10s %s\n", path, commit, branch
            }'

        case add a new
            # Add a new worktree
            if test (count $argv) -lt 3
                echo "Usage: gwt add <path> <branch>"
                echo "Example: gwt add ../feature-branch feature-branch"
                return 1
            end

            set worktree_path $argv[2]
            set branch_name $argv[3]

            # Check if branch exists locally
            if git show-ref --verify --quiet "refs/heads/$branch_name"
                git worktree add $worktree_path $branch_name
            else if git show-ref --verify --quiet "refs/remotes/origin/$branch_name"
                # Remote branch exists, create local tracking branch
                git worktree add -b $branch_name $worktree_path "origin/$branch_name"
            else
                # Create new branch
                read -P "Branch '$branch_name' doesn't exist. Create it? [Y/n] " -n 1 confirm
                if test "$confirm" = "n" -o "$confirm" = "N"
                    echo "Cancelled"
                    return 1
                end
                git worktree add -b $branch_name $worktree_path
            end

        case remove rm delete del
            # Remove a worktree interactively
            if command -v fzf >/dev/null 2>&1
                set selected (git worktree list | \
                    tail -n +2 | \
                    fzf --height=40% \
                        --reverse \
                        --border \
                        --prompt="Select worktree to remove: " \
                        --preview="echo 'Path: {}' && echo '' && git -C {1} status" \
                        --preview-window=right:60%)

                if test -n "$selected"
                    set worktree_path (echo $selected | awk '{print $1}')
                    echo ""
                    read -P "Remove worktree at '$worktree_path'? [y/N] " -n 1 confirm
                    if test "$confirm" = "y" -o "$confirm" = "Y"
                        git worktree remove $worktree_path
                    else
                        echo "Cancelled"
                    end
                end
            else
                if test (count $argv) -lt 2
                    echo "Usage: gwt remove <path>"
                    echo "Or install fzf for interactive selection"
                    return 1
                end
                git worktree remove $argv[2]
            end

        case prune p
            # Prune stale worktrees
            echo "Pruning stale worktrees..."
            git worktree prune -v

        case goto go cd
            # Switch to a worktree directory
            if not command -v fzf >/dev/null 2>&1
                echo "Error: fzf is required for this command"
                return 1
            end

            set selected (git worktree list | \
                fzf --height=40% \
                    --reverse \
                    --border \
                    --prompt="Go to worktree: " \
                    --preview="git -C {1} status" \
                    --preview-window=right:60%)

            if test -n "$selected"
                set worktree_path (echo $selected | awk '{print $1}')
                cd $worktree_path
            end

        case help h '*'
            echo "Git Worktree Helper"
            echo ""
            echo "Usage: gwt <command> [args]"
            echo ""
            echo "Commands:"
            echo "  list, ls, l              List all worktrees"
            echo "  add, a, new              Add a new worktree"
            echo "  remove, rm, delete, del  Remove a worktree (interactive with fzf)"
            echo "  prune, p                 Prune stale worktrees"
            echo "  goto, go, cd             Navigate to a worktree (requires fzf)"
            echo "  help, h                  Show this help message"
            echo ""
            echo "Examples:"
            echo "  gwt list                 # List all worktrees"
            echo "  gwt add ../feat feature  # Add worktree at ../feat for branch feature"
            echo "  gwt remove               # Interactive worktree removal"
            echo "  gwt goto                 # Interactive worktree navigation"
    end
end
