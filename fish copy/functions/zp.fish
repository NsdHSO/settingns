# Quick jump to project directories
# Usage: zp [project-name]
# Without args: lists all project directories
# With args: jumps to matching project

function zp -d "Quick jump to project directories"
    # Define common project base directories
    set -l project_dirs \
        "$HOME/projects" \
        "$HOME/work" \
        "$HOME/dev" \
        "$HOME/code" \
        "$HOME/Documents/projects" \
        "$HOME/workspace"

    if test (count $argv) -eq 0
        # List all projects
        echo "Available project directories:"
        for base in $project_dirs
            if test -d "$base"
                echo ""
                echo "In $base:"
                ls -1d "$base"/*/ 2>/dev/null | while read -l dir
                    set -l name (basename "$dir")
                    echo "  - $name"
                end
            end
        end
        return 0
    end

    # Search for matching project
    set -l query $argv[1]
    set -l found ""

    for base in $project_dirs
        if test -d "$base"
            for project in "$base"/*
                if test -d "$project"
                    set -l name (basename "$project")
                    if string match -q -i "*$query*" "$name"
                        set found "$project"
                        break
                    end
                end
            end
        end
        test -n "$found" && break
    end

    if test -n "$found"
        cd "$found"
        and echo "Jumped to: $found"
    else
        echo "Project not found: $query"
        echo "Use 'zp' without arguments to list available projects"
        return 1
    end
end
