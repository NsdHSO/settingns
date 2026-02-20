function add_function_docs --description "Add --description flag to function if missing"
    if test (count $argv) -lt 2
        set_color red
        echo "Usage: add_function_docs <function_name> <description>"
        set_color normal
        return 1
    end

    set -l func_name $argv[1]
    set -l description $argv[2..-1]
    set -l func_file "$HOME/.config/fish/functions/$func_name.fish"

    if not test -f $func_file
        set_color red
        echo "❌ Function file not found: $func_file"
        set_color normal
        return 1
    end

    # Check if description already exists
    if grep -q "\-\-description" $func_file
        set_color yellow
        echo "⚠️  Function already has a description"
        set_color normal
        return 0
    end

    # Create backup
    cp $func_file "$func_file.backup"

    # Read the file and add description
    set -l temp_file (mktemp)
    set -l modified 0

    while read -l line
        if string match -q "function $func_name*" $line; and test $modified -eq 0
            # Add description flag to function declaration
            if string match -q "function $func_name" $line
                echo "function $func_name --description \"$description\"" >> $temp_file
            else
                # Function already has arguments, append description
                echo (string replace "function $func_name" "function $func_name --description \"$description\"" $line) >> $temp_file
            end
            set modified 1
        else
            echo $line >> $temp_file
        end
    end < $func_file

    if test $modified -eq 1
        mv $temp_file $func_file
        set_color green
        echo "✅ Added description to $func_name"
        echo "📝 Backup saved: $func_file.backup"
        set_color normal
    else
        rm $temp_file
        set_color red
        echo "❌ Could not find function declaration"
        set_color normal
        return 1
    end
end
