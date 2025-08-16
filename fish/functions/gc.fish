
function gc
    if test (count $argv) -eq 0
        set_color red
        echo "❌ Usage: gc <type> <message> or gc <message>"
        set_color normal
        return 1
    end

    if test (count $argv) -eq 1
        set -l message "$argv[1]"
        set_color blue
        echo "📝 Committing changes..."
        git commit -m "$message"
        set -l commit_status $status
        if test $commit_status -eq 0
            set_color green
            echo "✅ Commit successful!"
            echo "🏷️  $message"
        else
            set_color red
            echo "❌ Commit failed!"
        end
        set_color normal
        return $commit_status
    end

    set -l input_type (string lower $argv[1])
    set -l message "$argv[2..-1]"

    set -l type ""
    set -l emoji ""
    set -l color ""

    switch $input_type
        case f feat
            set type feat
            set emoji "🎸"
            set color green
        case fi fix
            set type fix
            set emoji "🛠️"
            set color yellow
        case d docs
            set type docs
            set emoji "📝"
            set color blue
        case s style
            set type style
            set emoji "🎨"
            set color magenta
        case t test
            set type test
            set emoji "🐳"
            set color green
        case c chore
            set type chore
            set emoji "🌻"
            set color cyan
        case p perf
            set type perf
            set emoji "🚀"
            set color blue
        case r refactor
            set type refactor
            set emoji "👷"
            set color cyan
        case revert
            set type revert
            set emoji "⏪"
            set color red
        case '*'
            set type $input_type
    end

    if test -z "$emoji"; or test -z "$color"
        set type ""
        set emoji "🤷"
        set color blue
    end

    # Capitalize if input was uppercase
    if string match -rq '^[A-Z]' -- $argv[1]
        set type (string upper (string sub -s 1 -l 1 $type))(string sub -s 2 $type)
    end

    set_color $color
    echo "📝 Committing changes..."
    git commit -m "$emoji $message"
    set -l commit_status $status
    if test $commit_status -eq 0
        set_color green
        echo "✅ Commit successful!"
        echo "🏷️  $emoji $message"
    else
        set_color red
        echo "❌ Commit failed!"
    end
    set_color normal
end
