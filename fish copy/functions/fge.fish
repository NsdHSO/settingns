# Fuzzy Git Edit
# Usage: fge - select modified files and open in editor

function fge --description "Fuzzy find and edit git modified files"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        set_color --bold red
        echo "Error: Not in a git repository"
        set_color normal
        return 1
    end

    # Get modified files
    set -l files (git status --short | \
        fzf --multi \
            --prompt="Select file(s) to edit: " \
            --header="TAB to select multiple | ENTER to confirm | ESC to cancel" \
            --preview="echo {} | awk '{print \$2}' | xargs bat --style=numbers --color=always 2>/dev/null || echo {} | awk '{print \$2}' | xargs cat" \
            --preview-window=right:60% \
            --height=80% \
            --border \
            --ansi | \
        awk '{print $2}')

    if test -z "$files"
        set_color yellow
        echo "No files selected"
        set_color normal
        return 0
    end

    # Open files in editor (use $EDITOR or default to nvim)
    set -l editor nvim
    if set -q EDITOR
        set editor $EDITOR
    end

    set_color --bold green
    echo "Opening files in $editor..."
    set_color normal

    $editor $files
end
