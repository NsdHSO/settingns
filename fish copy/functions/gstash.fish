function gstash --description 'Interactive stash management using fzf'
    # Check if fzf is installed
    if not command -v fzf >/dev/null 2>&1
        echo "Error: fzf is not installed. Install it with: brew install fzf"
        return 1
    end

    # Check if in git repo
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Check if there are any stashes
    if test (git stash list | wc -l) -eq 0
        echo "No stashes found"
        return 0
    end

    # Select stash with fzf
    set selected_stash (git stash list | \
        fzf --height=40% \
            --reverse \
            --border \
            --prompt="Select stash: " \
            --preview="git stash show -p {1} --color=always" \
            --preview-window=right:60% \
            --header="Enter: show | Ctrl-A: apply | Ctrl-P: pop | Ctrl-D: drop")

    if test -n "$selected_stash"
        # Extract stash number
        set stash_num (echo $selected_stash | cut -d: -f1)

        # Ask what to do with the stash
        echo ""
        echo "Selected: $selected_stash"
        echo ""
        echo "What would you like to do?"
        echo "  [a] Apply (keep in stash list)"
        echo "  [p] Pop (apply and remove from stash list)"
        echo "  [d] Drop (delete without applying)"
        echo "  [s] Show (view changes)"
        echo "  [q] Quit"
        echo ""
        read -P "Choice: " -n 1 choice

        switch $choice
            case a A
                git stash apply $stash_num
            case p P
                git stash pop $stash_num
            case d D
                echo ""
                read -P "Are you sure you want to drop this stash? [y/N] " -n 1 confirm
                if test "$confirm" = "y" -o "$confirm" = "Y"
                    git stash drop $stash_num
                else
                    echo "Cancelled"
                end
            case s S
                git stash show -p $stash_num
            case q Q '*'
                echo "Cancelled"
        end
    end
end
