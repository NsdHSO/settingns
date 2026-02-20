function auto_update_docs --description "Automatically update documentation when functions change"
    set -l config_dir "$HOME/.config/fish"
    set -l functions_dir "$config_dir/functions"
    set -l timestamp_file "$config_dir/.docs_timestamp"

    # Check if any function file has been modified since last doc generation
    set -l needs_update 0

    if not test -f $timestamp_file
        set needs_update 1
    else
        set -l last_update (cat $timestamp_file)

        # Find any function file modified after last doc generation
        for func_file in (find $functions_dir -name "*.fish" -type f -newer $timestamp_file 2>/dev/null)
            set needs_update 1
            break
        end
    end

    if test $needs_update -eq 1
        set_color yellow
        echo "🔄 Function changes detected. Updating documentation..."
        set_color normal

        generate_docs

        # Update timestamp
        date +%s > $timestamp_file
    end
end
