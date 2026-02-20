# Improved nxg with Advanced Error Handling
function nxg_improved
    # Check if nx is installed
    if not command -q nx
        error_handler missing_tool nx
        set_color $phenomenon_git_info
        echo "→ Install with: npm install -g nx"
        echo "→ Or locally: npm install --save-dev nx"
        set_color normal
        return 1
    end

    # Validate arguments
    if test (count $argv) -lt 2
        error_handler missing_arg nxg "<type> <name>"
        set_color $phenomenon_git_info
        echo "→ Valid types:"
        echo "  • component (or c) - Generate Angular component"
        echo "  • service (or s) - Generate Angular service"
        echo "  • interface - Generate TypeScript interface"
        echo "→ Example: nxg component my-feature"
        set_color normal
        return 1
    end

    set -l type $argv[1]
    set -l name $argv[2]

    # Validate name format (basic check)
    if not string match -rq '^[a-zA-Z][a-zA-Z0-9_-]*$' -- $name
        error_handler invalid_arg $name "valid identifier (letters, numbers, hyphens, underscores)"
        return 1
    end

    # Check if we're in an Nx workspace
    if not test -f nx.json
        error_handler not_found "file" "nx.json"
        set_color $phenomenon_git_info
        echo "→ This doesn't appear to be an Nx workspace"
        echo "→ Create one with: npx create-nx-workspace"
        set_color normal
        return 1
    end

    set_color $phenomenon_git_info
    echo "→ Generating $type: $name"
    set_color normal

    switch $type
        case interface
            if nx g interface $name
                error_handler success_recovery "Interface '$name' created successfully"
                return 0
            else
                error_handler custom "Failed to create interface '$name'"
                return 1
            end

        case service s
            if nx g @nx/angular:service --name=$name
                error_handler success_recovery "Service '$name' created successfully"
                return 0
            else
                error_handler custom "Failed to create service '$name'"
                return 1
            end

        case component c
            # Check if directory already exists
            if test -d $name
                error_handler custom "Directory '$name' already exists"
                set_color $phenomenon_symbols
                echo "→ Choose a different name or remove the existing directory"
                set_color normal
                return 1
            end

            if not mkdir -p $name
                error_handler permission_denied $name
                return 1
            end

            if not cd $name
                error_handler custom "Failed to change to directory '$name'"
                return 1
            end

            set_color $phenomenon_time
            echo "→ Directory created: $name"
            set_color normal

            if nx g @nx/angular:component --name=$name --standalone=true --nameAndDirectoryFormat=as-provided
                set_color $phenomenon_success
                echo "✓ Component '$name' created successfully"
                set_color normal
                return 0
            else
                error_handler custom "Failed to create component '$name'"
                cd ..
                return 1
            end

        case '*'
            # Unknown type - suggest correct ones
            set -l valid_types interface service component s c
            suggest_command $type $valid_types
            return 1
    end
end
