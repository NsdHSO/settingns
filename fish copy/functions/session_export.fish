function session_export -d "Export session to a portable format"
    # Parse arguments
    argparse 'n/name=' 'f/format=' 'o/output=' -- $argv
    or return 1

    set -l session_name ""
    set -l format "bash"
    set -l output_file ""

    if set -q _flag_name
        set session_name $_flag_name
    else if test (count $argv) -gt 0
        set session_name $argv[1]
    end

    if set -q _flag_format
        set format $_flag_format
    end

    if set -q _flag_output
        set output_file $_flag_output
    end

    if test -z "$session_name"
        echo "Error: Session name required" >&2
        echo "Usage: session_export -n <session_name> [-f bash|zsh|json] [-o output_file]" >&2
        return 1
    end

    # Session directory
    set -l session_dir ~/.config/fish/sessions
    set -l session_file "$session_dir/$session_name.session"

    # Check if session exists
    if not test -f $session_file
        echo "Error: Session '$session_name' not found" >&2
        return 1
    end

    # Load session data
    source $session_file

    # Export based on format
    switch $format
        case bash zsh
            set -l export_content "#!/usr/bin/env $format\n"
            set export_content "$export_content# Exported from Fish session: $session_name\n"
            set export_content "$export_content# Created: $(date '+%Y-%m-%d %H:%M:%S')\n\n"

            # Export working directory
            if set -q saved_pwd
                set export_content "$export_content# Working Directory\n"
                set export_content "$export_contentcd '$saved_pwd'\n\n"
            end

            # Export environment variables
            set -l session_vars (grep "^set -gx" $session_file | sed 's/set -gx //')
            if test -n "$session_vars"
                set export_content "$export_content# Environment Variables\n"
                for line in $session_vars
                    set -l var_line (echo $line | sed "s/^/export /")
                    set export_content "$export_content$var_line\n"
                end
                set export_content "$export_content\n"
            end

            if test -n "$output_file"
                printf $export_content > $output_file
                chmod +x $output_file
                echo "Session exported to: $output_file"
            else
                printf $export_content
            end

        case json
            echo "{"
            echo "  \"session_name\": \"$session_name\","
            echo "  \"exported\": \"$(date -Iseconds)\","

            if set -q saved_pwd
                echo "  \"working_directory\": \"$saved_pwd\","
            end

            if set -q git_branch
                echo "  \"git_branch\": \"$git_branch\","
            end

            echo "  \"environment\": {"
            set -l first 1
            set -l session_vars (grep "^set -gx" $session_file)
            for line in $session_vars
                set -l var_name (echo $line | sed "s/set -gx //;s/ .*//" )
                set -l var_value (echo $line | sed "s/^set -gx $var_name '//;s/'\$//")

                if test $first -eq 0
                    echo ","
                end
                set first 0

                echo -n "    \"$var_name\": \"$var_value\""
            end
            echo ""
            echo "  }"
            echo "}"

        case '*'
            echo "Error: Unsupported format '$format'" >&2
            echo "Supported formats: bash, zsh, json" >&2
            return 1
    end

    return 0
end
