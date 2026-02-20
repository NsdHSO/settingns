# Fuzzy Directory Change
# Usage: fcd - change to any directory in your system using fzf

function fcd --description "Fuzzy find and change directory"
    # Set search base (default to home directory)
    set -l search_base $HOME
    if test (count $argv) -gt 0
        set search_base $argv[1]
    end

    # Find directories and let user select
    set -l selected_dir

    if command -q fd
        # Use fd for faster directory search
        set selected_dir (fd --type d --hidden --follow --exclude .git --base-directory $search_base . $search_base | \
            fzf --prompt="Select directory: " \
                --preview="eza --tree --level=2 --color=always $search_base/{} 2>/dev/null || ls -la $search_base/{}" \
                --preview-window=right:60% \
                --height=60% \
                --border \
                --ansi)
    else
        # Fallback to find command
        set selected_dir (find $search_base -type d -not -path '*/\.git/*' 2>/dev/null | \
            fzf --prompt="Select directory: " \
                --preview="ls -la {}" \
                --preview-window=right:60% \
                --height=60% \
                --border \
                --ansi)
    end

    # Change to selected directory
    if test -n "$selected_dir"
        # Handle relative paths from fd
        if test -d "$search_base/$selected_dir"
            cd "$search_base/$selected_dir"
        else if test -d "$selected_dir"
            cd "$selected_dir"
        else
            set_color red
            echo "Error: Directory not found"
            set_color normal
            return 1
        end

        set_color --bold green
        echo "Changed to: "(pwd)
        set_color normal

        # List contents if eza is available
        if command -q eza
            eza --long --git --icons
        else
            ls -la
        end
    else
        set_color yellow
        echo "No directory selected"
        set_color normal
    end
end
