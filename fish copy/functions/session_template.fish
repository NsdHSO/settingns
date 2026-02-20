function session_template -d "Create or use session templates for different project types"
    # Parse arguments
    argparse 'c/create=' 'l/list' 'a/apply=' -- $argv
    or return 1

    set -l template_dir ~/.config/fish/sessions/templates
    mkdir -p $template_dir

    # List templates
    if set -q _flag_list
        echo "Available Session Templates:"
        echo ""

        set -l templates (find $template_dir -name "*.template" -type f 2>/dev/null)

        if test (count $templates) -eq 0
            echo "No templates found."
            echo "Create a template with: session_template -c <name>"
            return 0
        end

        for template_file in $templates
            set -l template_name (basename $template_file .template)
            set -l description (grep "^# Description:" $template_file | sed 's/# Description: //')

            echo "  $template_name"
            if test -n "$description"
                echo "    $description"
            end
        end

        echo ""
        echo "Apply a template with: session_template -a <name>"
        return 0
    end

    # Create new template
    if set -q _flag_create
        set -l template_name $_flag_create
        set -l template_file "$template_dir/$template_name.template"

        echo "Creating template: $template_name"
        echo ""
        read -l -P "Description: " description
        read -l -P "Default working directory (optional): " default_dir

        echo "# Fish Shell Session Template: $template_name" > $template_file
        echo "# Description: $description" >> $template_file
        echo "# Created: $(date '+%Y-%m-%d %H:%M:%S')" >> $template_file
        echo "" >> $template_file

        if test -n "$default_dir"
            echo "# Default Working Directory" >> $template_file
            echo "set -l template_pwd '$default_dir'" >> $template_file
            echo "" >> $template_file
        end

        echo "# Environment Variables" >> $template_file
        echo "# Add template-specific environment variables here" >> $template_file
        echo "# Example: set -gx NODE_ENV 'development'" >> $template_file
        echo "" >> $template_file

        echo "# Startup Commands" >> $template_file
        echo "# Add commands to run when applying this template" >> $template_file
        echo "# Example: set -l startup_commands 'npm install' 'npm run dev'" >> $template_file
        echo "" >> $template_file

        echo "Template created: $template_file"
        echo "Edit this file to customize the template"
        echo "Apply with: session_template -a $template_name"

        return 0
    end

    # Apply template
    if set -q _flag_apply
        set -l template_name $_flag_apply
        set -l template_file "$template_dir/$template_name.template"

        if not test -f $template_file
            echo "Error: Template '$template_name' not found" >&2
            echo "Use 'session_template -l' to list available templates" >&2
            return 1
        end

        echo "Applying template: $template_name"

        # Source the template
        source $template_file

        # Change to template directory if specified
        if set -q template_pwd; and test -d $template_pwd
            cd $template_pwd
            echo "Changed to directory: $template_pwd"
        end

        # Run startup commands if defined
        if set -q startup_commands
            echo "Running startup commands..."
            for cmd in $startup_commands
                echo "  > $cmd"
                eval $cmd
            end
        end

        echo "Template '$template_name' applied successfully!"

        # Optionally save as a regular session
        read -l -P "Save as session? (y/N): " save_session
        if test "$save_session" = "y"; or test "$save_session" = "Y"
            read -l -P "Session name: " session_name
            if test -n "$session_name"
                session_save $session_name
            end
        end

        return 0
    end

    # No flags - show usage
    echo "Usage:"
    echo "  session_template -l           List available templates"
    echo "  session_template -c <name>    Create a new template"
    echo "  session_template -a <name>    Apply a template"
    echo ""
    echo "Templates are stored in: $template_dir"

    return 0
end
