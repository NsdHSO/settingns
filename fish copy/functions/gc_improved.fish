# Improved gc with Advanced Error Handling
function gc_improved
    # Check if we're in a git repository
    if not git rev-parse --git-dir &>/dev/null
        error_handler git_not_repo
        return 1
    end

    # Validate arguments
    if test (count $argv) -lt 2
        error_handler missing_arg gc "<type> <message>"
        set_color $phenomenon_git_info
        echo "→ Valid types: feat, fix, docs, style, test, chore, perf, refactor, revert"
        echo "→ Shortcuts: f, fi, d, s, t, c, p, r"
        set_color normal
        return 1
    end

    set -l input_type (string lower $argv[1])
    set -l message "$argv[2..-1]"

    # Validate message is not empty
    if test -z "$message"
        error_handler invalid_arg "" "non-empty commit message"
        return 1
    end

    # Map commit types
    set -l type ""
    set -l emoji ""
    set -l color ""

    switch $input_type
        case f feat
            set type feat
            set emoji "🎸"
            set color $phenomenon_success
        case fi fix
            set type fix
            set emoji "🛠️"
            set color $phenomenon_symbols
        case d docs
            set type docs
            set emoji "📝"
            set color $phenomenon_git_info
        case s style
            set type style
            set emoji "🎨"
            set color $phenomenon_directory
        case t test
            set type test
            set emoji "🐳"
            set color $phenomenon_success
        case c chore
            set type chore
            set emoji "🌻"
            set color $phenomenon_time
        case p perf
            set type perf
            set emoji "🚀"
            set color $phenomenon_git_info
        case r ref refactor
            set type refactor
            set emoji "👷"
            set color $phenomenon_time
        case revert
            set type revert
            set emoji "⏪"
            set color $phenomenon_error
        case '*'
            # Unknown type - suggest correct ones
            set -l valid_types feat fix docs style test chore perf refactor revert f fi d s t c p r
            suggest_command $input_type $valid_types
            return 1
    end

    # Capitalize if input was uppercase
    if string match -rq '^[A-Z]' -- $argv[1]
        set type (string upper (string sub -s 1 -l 1 $type))(string sub -s 2 $type)
    end

    # Check if there are changes to commit
    set -l git_status (git status --porcelain 2>/dev/null)
    if test -z "$git_status"
        error_handler custom "No changes to commit"
        set_color $phenomenon_success
        echo "→ Working tree is clean"
        set_color normal
        return 1
    end

    # Perform the commit
    set_color $color
    echo "→ Committing changes..."
    set_color normal

    if git commit -m "$type: $emoji $message"
        set_color $phenomenon_success
        echo "✓ Commit successful!"
        echo "→ $type: $emoji $message"
        set_color normal
        return 0
    else
        error_handler custom "Commit failed"
        set_color $phenomenon_git_info
        echo "→ Check if files are staged with: git status"
        set_color normal
        return 1
    end
end
