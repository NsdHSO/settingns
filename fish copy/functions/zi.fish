# Interactive zoxide directory selection with fzf
# Usage: zi
# Opens an interactive fzf menu to select from your most used directories

function zi -d "Interactive zoxide directory selection with fzf"
    if not command -q fzf
        echo "Error: fzf is required for interactive zoxide selection"
        echo "Install with: brew install fzf"
        return 1
    end

    if not command -q zoxide
        echo "Error: zoxide is not installed"
        echo "Install with: brew install zoxide"
        return 1
    end

    # Get zoxide results and pipe through fzf
    set -l result (zoxide query -l | fzf \
        --height=40% \
        --reverse \
        --border \
        --prompt='Jump to: ' \
        --preview 'ls -la {}' \
        --preview-window=right:50%:wrap \
        --bind 'ctrl-/:toggle-preview')

    # If a directory was selected, cd to it and add to zoxide
    if test -n "$result"
        cd "$result"
        and commandline -f repaint
    end
end
