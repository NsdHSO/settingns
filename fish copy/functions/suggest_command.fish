# Command Suggestion System
# Provides "did you mean?" suggestions for typos

function suggest_command
    set -l typed_command $argv[1]
    set -l valid_commands $argv[2..-1]

    # Calculate Levenshtein distance for each command
    set -l suggestions

    for cmd in $valid_commands
        set -l distance (string_distance $typed_command $cmd)

        # Suggest if distance is small (likely a typo)
        if test $distance -le 3
            set -a suggestions $cmd
        end
    end

    if test (count $suggestions) -gt 0
        error_handler typo_suggestion $typed_command $suggestions
    else
        error_handler custom "Unknown command: '$typed_command'"
        set_color $phenomenon_git_info
        echo "→ Available commands: "(string join ", " $valid_commands)
        set_color normal
    end

    return 1
end

# Helper: Calculate Levenshtein distance between two strings
function string_distance
    set -l str1 $argv[1]
    set -l str2 $argv[2]

    set -l len1 (string length $str1)
    set -l len2 (string length $str2)

    # Quick check for exact match
    if test "$str1" = "$str2"
        echo 0
        return
    end

    # Quick check for length difference
    set -l len_diff (math "abs($len1 - $len2)")
    if test $len_diff -gt 3
        echo $len_diff
        return
    end

    # Simple implementation: count character differences
    # For production, a full Levenshtein would be better
    set -l diff_count 0
    set -l max_len (math "max($len1, $len2)")

    for i in (seq 1 $max_len)
        set -l char1 (string sub -s $i -l 1 $str1)
        set -l char2 (string sub -s $i -l 1 $str2)

        if test "$char1" != "$char2"
            set diff_count (math $diff_count + 1)
        end
    end

    echo $diff_count
end
