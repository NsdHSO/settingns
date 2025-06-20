function gc
    if test (count $argv) -lt 2
        set_color red
        echo "❌ Usage: gc <type> <message>"
        set_color normal
        return 1
    end

    # Use associative arrays for fast lookup
    set -l type_map r=refactor fi=fix d=docs s=style t=test c=chore p=perf f=feat revert=revert
    set -l emoji_map refactor=👷 fix=🛠️ docs=📝 style=🎨 test=🐳 chore=🌻 perf=🚀 feat=🎸 revert=⏪
    set -l color_map refactor=cyan fix=yellow docs=blue style=magenta test=green chore=cyan perf=blue feat=green revert=red

    set -l input_type (string lower $argv[1])
    set -l message "$argv[2..-1]"

    set -l type $type_map[$input_type]
    if test -z "$type"
        set -l type $input_type
    end
    set -l emoji $emoji_map[$type]
    set -l color $color_map[$type]

    if test -z "$emoji"; or test -z "$color"
        set_color red
        echo "❌ Unknown commit type: $input_type"
        set_color normal
        return 1
    end

    # Capitalize if input was uppercase
    if string match -rq '^[A-Z]' -- $argv[1]
        set type (string upper (string sub -s 1 -l 1 $type))(string sub -s 2 $type)
    end

    set_color $color
    echo "📝 Committing changes..."
    git commit -m "$type: $emoji $message"
    set -l commit_status $status
    if test $commit_status -eq 0
        set_color green
        echo "✅ Commit successful!"
        echo "🏷️  $type: $emoji $message"
    else
        set_color red
        echo "❌ Commit failed!"
    end
    set_color normal
end
