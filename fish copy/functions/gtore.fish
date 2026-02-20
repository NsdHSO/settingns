function gtore
    set -l modified_files (git diff --name-only)
    set -l file_count (count $modified_files)
    if test $file_count -eq 0
        set_color red
        echo "❌ No unstaged changes found."
        set_color normal
        return 0
    end
    set -l numbers (seq 1 $file_count)
    begin
        set_color cyan
        echo "📝 Modified files (unstaged):"
        echo "=========================="
        set_color yellow
        for i in $numbers
            echo "$i) $modified_files[$i]"
        end
        set_color blue
        echo \n"📋 Enter the numbers of files to restore (space-separated):"
        echo "Example: 1 3 5 or just 2"
        echo "Press Enter without typing anything to cancel"
        set_color normal
    end
    read -P "➤ " input
    if test -z "$input"
        set_color yellow
        echo "⚠️  No files selected. Exiting..."
        set_color normal
        return 0
    end
    set -l selected_files
    set -l invalid_selections
    for num in (string split ' ' $input)
        if string match -qr '^[0-9]+$' $num; and test $num -ge 1 -a $num -le $file_count
            set -a selected_files $modified_files[$num]
        else
            set -a invalid_selections $num
        end
    end
    if test (count $invalid_selections) -gt 0
        set_color red
        echo "❌ Invalid selection(s): $invalid_selections"
        echo "Valid range is 1-$file_count"
        set_color normal
        return 1
    end
    begin
        set_color green
        echo \n"✅ Selected files to restore:"
        set_color white
        printf "  - %s\n" $selected_files
        set_color yellow
        read -P "⚠️  Are you sure you want to restore these files? (Y/n): " confirm
        set_color normal
    end
    if test -z "$confirm"; or string match -qi 'y*' $confirm
        begin
            set_color green
            echo "🔄 Restoring selected files..."
            set_color cyan
            for file in $selected_files
                echo "📄 Restoring: $file"
                git checkout HEAD -- $file
            end
            set_color green
            echo "✨ Done!"
        end
    else
        set_color yellow
        echo "🚫 Operation cancelled."
    end
    set_color normal
end
