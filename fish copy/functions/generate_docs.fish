function generate_docs --description "Generate documentation for all fish functions"
    set -l config_dir "$HOME/.config/fish"
    set -l functions_dir "$config_dir/functions"
    set -l docs_dir "$config_dir/docs"
    set -l readme_file "$config_dir/README.md"
    set -l keybindings_file "$config_dir/KEYBINDINGS.md"

    # Create docs directory if it doesn't exist
    if not test -d $docs_dir
        mkdir -p $docs_dir
        set_color cyan
        echo "📁 Created docs directory: $docs_dir"
        set_color normal
    end

    set_color -o blue
    echo "📚 Generating Fish Shell Documentation..."
    echo "========================================"
    set_color normal

    # Initialize README
    set -l readme_content "# Fish Shell Configuration Documentation\n\n"
    set readme_content "$readme_content""Generated on: "(date "+%Y-%m-%d %H:%M:%S")"\n\n"
    set readme_content "$readme_content""## Overview\n\n"
    set readme_content "$readme_content""This documentation covers all custom functions available in this Fish shell configuration.\n\n"
    set readme_content "$readme_content""## Categories\n\n"

    # Categories for organization
    set -l git_functions
    set -l node_functions
    set -l utility_functions
    set -l nav_functions

    # Scan all function files
    set -l function_files (find $functions_dir -name "*.fish" -type f | sort)
    set -l total_functions 0

    for func_file in $function_files
        set -l func_name (basename $func_file .fish)

        # Skip internal/private functions
        if string match -q "_*" $func_name
            continue
        end

        # Skip nvm and fisher functions
        if string match -q "nvm*" $func_name; or string match -q "fisher*" $func_name
            continue
        end

        set total_functions (math $total_functions + 1)

        # Categorize functions
        if string match -q "g*" $func_name; and not string match -q "generate*" $func_name
            set -a git_functions $func_file
        else if string match -q "y*" $func_name; or string match -q "n*" $func_name
            set -a node_functions $func_file
        else if string match -q ".*" $func_name
            set -a nav_functions $func_file
        else
            set -a utility_functions $func_file
        end
    end

    set_color cyan
    echo "📊 Found $total_functions custom functions"
    set_color normal

    # Generate documentation for each category
    function _generate_category_docs
        set -l category $argv[1]
        set -l files $argv[2..-1]

        if test (count $files) -eq 0
            return
        end

        set readme_content "$readme_content""### $category\n\n"

        for func_file in $files
            set -l func_name (basename $func_file .fish)
            set -l description ""
            set -l usage ""
            set -l example ""

            # Parse function file for documentation
            set -l in_function 0
            set -l line_num 0

            while read -l line
                set line_num (math $line_num + 1)

                # Extract description from --description flag
                if string match -q "*--description*" $line
                    set description (string match -r '"([^"]+)"' $line)[2]
                end

                # Extract comments at the beginning of file
                if string match -q "#*" $line; and test $line_num -lt 10
                    set -l comment (string trim (string replace -r "^#\\s*" "" $line))
                    if test -n "$comment"
                        if test -z "$description"
                            set description $comment
                        end
                    end
                end

                # Detect function signature
                if string match -q "function $func_name*" $line
                    set in_function 1
                end

                # Look for usage patterns in error messages
                if string match -q '*Usage:*' $line
                    set usage (string match -r 'Usage: (.+)"' $line)[2]
                    if test -z "$usage"
                        set usage (string match -r "Usage: (.+)" $line)[2]
                    end
                end

                # Break after reading enough of the function
                if test $line_num -gt 30
                    break
                end
            end < $func_file

            # Generate function documentation
            set -l func_doc_file "$docs_dir/$func_name.md"

            # Create individual function documentation
            echo "# $func_name\n" > $func_doc_file

            if test -n "$description"
                echo "**Description:** $description\n" >> $func_doc_file
            else
                echo "**Description:** Custom fish function\n" >> $func_doc_file
                set description "Custom fish function"
            end

            if test -n "$usage"
                echo "## Usage\n" >> $func_doc_file
                echo '```fish' >> $func_doc_file
                echo "$usage" >> $func_doc_file
                echo '```' >> $func_doc_file
                echo "" >> $func_doc_file
            end

            # Generate example based on function name and content
            echo "## Example\n" >> $func_doc_file
            echo '```fish' >> $func_doc_file
            _generate_example $func_name >> $func_doc_file
            echo '```' >> $func_doc_file
            echo "" >> $func_doc_file

            # Add to README
            set readme_content "$readme_content""#### \`$func_name\`\n\n"
            set readme_content "$readme_content""$description\n\n"
            if test -n "$usage"
                set readme_content "$readme_content""**Usage:** \`$usage\`\n\n"
            end
            set readme_content "$readme_content""[View details](docs/$func_name.md)\n\n"

            set_color green
            echo "  ✓ Documented: $func_name"
            set_color normal
        end

        set readme_content "$readme_content""\n"
    end

    # Helper function to generate examples
    function _generate_example
        set -l func_name $argv[1]

        switch $func_name
            case gc
                echo "# Commit with feat type"
                echo "gc feat \"add new feature\""
                echo ""
                echo "# Commit with fix type"
                echo "gc fix \"resolve bug in parser\""
            case ginit
                echo "# Initialize git repository without hooks"
                echo "ginit"
            case gis
                echo "# Display detailed git status"
                echo "gis"
            case gip
                echo "# Push to remote"
                echo "gip"
                echo ""
                echo "# Force push"
                echo "gip --force"
            case ghard
                echo "# Reset all local changes (with confirmation)"
                echo "ghard"
            case gtore
                echo "# Interactively restore modified files"
                echo "gtore"
            case gio
                echo "# Fetch and pull from remote"
                echo "gio"
            case giofetch
                echo "# Fetch all references from all remotes"
                echo "giofetch"
            case giopull
                echo "# Pull latest changes"
                echo "giopull"
            case killport
                echo "# Kill process on port 3000"
                echo "killport 3000"
            case yas
                echo "# Auto-detect package manager and start dev server"
                echo "yas"
            case yaw
                echo "# Run tests in watch mode with detected package manager"
                echo "yaw"
            case ylock
                echo "# Remove lockfile and reinstall dependencies"
                echo "ylock"
            case yall
                echo "# Remove node_modules and reinstall fresh"
                echo "yall"
            case nxg
                echo "# Generate Nx component"
                echo "nxg component my-component"
                echo ""
                echo "# Generate Nx service"
                echo "nxg service my-service"
            case '....'
                echo "# Navigate up multiple directories"
                echo "..    # Go up 1 level"
                echo "...   # Go up 2 levels"
                echo "....  # Go up 3 levels"
            case '*'
                echo "# Use the $func_name function"
                echo "$func_name"
        end
    end

    # Generate documentation by category
    set_color yellow
    echo "📝 Generating Git Functions documentation..."
    set_color normal
    _generate_category_docs "Git Functions" $git_functions

    set_color yellow
    echo "📝 Generating Node/Package Manager Functions documentation..."
    set_color normal
    _generate_category_docs "Node & Package Manager Functions" $node_functions

    set_color yellow
    echo "📝 Generating Navigation Functions documentation..."
    set_color normal
    _generate_category_docs "Navigation Functions" $nav_functions

    set_color yellow
    echo "📝 Generating Utility Functions documentation..."
    set_color normal
    _generate_category_docs "Utility Functions" $utility_functions

    # Add quick reference section
    set readme_content "$readme_content""## Quick Reference\n\n"
    set readme_content "$readme_content""### Most Used Commands\n\n"
    set readme_content "$readme_content""| Command | Description |\n"
    set readme_content "$readme_content""|---------|-------------|\n"
    set readme_content "$readme_content""| \`gc feat \"message\"\` | Commit with conventional commit format |\n"
    set readme_content "$readme_content""| \`gis\` | Enhanced git status |\n"
    set readme_content "$readme_content""| \`gio\` | Fetch and pull from remote |\n"
    set readme_content "$readme_content""| \`gip\` | Push to remote |\n"
    set readme_content "$readme_content""| \`yas\` | Start dev server (auto-detect package manager) |\n"
    set readme_content "$readme_content""| \`yall\` | Fresh install dependencies |\n"
    set readme_content "$readme_content""| \`killport 3000\` | Kill process on port |\n"
    set readme_content "$readme_content""\n"

    # Write README
    echo -e $readme_content > $readme_file

    # Generate keybindings reference
    _generate_keybindings_docs

    set_color -o green
    echo "========================================"
    echo "✅ Documentation generation complete!"
    echo ""
    echo "📄 Main documentation: $readme_file"
    echo "📁 Function docs: $docs_dir/"
    echo "⌨️  Keybindings: $keybindings_file"
    set_color normal
end

function _generate_keybindings_docs
    set -l config_dir "$HOME/.config/fish"
    set -l keybindings_file "$config_dir/KEYBINDINGS.md"

    set -l kb_content "# Fish Shell Keybindings Reference\n\n"
    set kb_content "$kb_content""Generated on: "(date "+%Y-%m-%d %H:%M:%S")"\n\n"

    set kb_content "$kb_content""## Default Fish Keybindings\n\n"
    set kb_content "$kb_content""### Editing\n\n"
    set kb_content "$kb_content""| Key | Action |\n"
    set kb_content "$kb_content""|-----|--------|\n"
    set kb_content "$kb_content""| \`Ctrl+A\` | Move to beginning of line |\n"
    set kb_content "$kb_content""| \`Ctrl+E\` | Move to end of line |\n"
    set kb_content "$kb_content""| \`Ctrl+K\` | Delete from cursor to end of line |\n"
    set kb_content "$kb_content""| \`Ctrl+U\` | Delete from cursor to beginning of line |\n"
    set kb_content "$kb_content""| \`Ctrl+W\` | Delete word before cursor |\n"
    set kb_content "$kb_content""| \`Alt+D\` | Delete word after cursor |\n"
    set kb_content "$kb_content""| \`Ctrl+T\` | Transpose characters |\n"
    set kb_content "$kb_content""\n"

    set kb_content "$kb_content""### Navigation\n\n"
    set kb_content "$kb_content""| Key | Action |\n"
    set kb_content "$kb_content""|-----|--------|\n"
    set kb_content "$kb_content""| \`Ctrl+F\` or \`→\` | Move forward one character |\n"
    set kb_content "$kb_content""| \`Ctrl+B\` or \`←\` | Move backward one character |\n"
    set kb_content "$kb_content""| \`Alt+F\` | Move forward one word |\n"
    set kb_content "$kb_content""| \`Alt+B\` | Move backward one word |\n"
    set kb_content "$kb_content""| \`Ctrl+P\` or \`↑\` | Previous command in history |\n"
    set kb_content "$kb_content""| \`Ctrl+N\` or \`↓\` | Next command in history |\n"
    set kb_content "$kb_content""\n"

    set kb_content "$kb_content""### History & Search\n\n"
    set kb_content "$kb_content""| Key | Action |\n"
    set kb_content "$kb_content""|-----|--------|\n"
    set kb_content "$kb_content""| \`Ctrl+R\` | Search command history |\n"
    set kb_content "$kb_content""| \`Alt+↑\` | Search history for current token |\n"
    set kb_content "$kb_content""| \`Alt+↓\` | Search history for current token (reverse) |\n"
    set kb_content "$kb_content""\n"

    set kb_content "$kb_content""### Completion & Suggestions\n\n"
    set kb_content "$kb_content""| Key | Action |\n"
    set kb_content "$kb_content""|-----|--------|\n"
    set kb_content "$kb_content""| \`Tab\` | Accept autosuggestion or show completions |\n"
    set kb_content "$kb_content""| \`Shift+Tab\` | Show completions (reverse) |\n"
    set kb_content "$kb_content""| \`→\` | Accept autosuggestion |\n"
    set kb_content "$kb_content""| \`Ctrl+F\` | Accept one word of autosuggestion |\n"
    set kb_content "$kb_content""\n"

    set kb_content "$kb_content""### Process Control\n\n"
    set kb_content "$kb_content""| Key | Action |\n"
    set kb_content "$kb_content""|-----|--------|\n"
    set kb_content "$kb_content""| \`Ctrl+C\` | Cancel current command |\n"
    set kb_content "$kb_content""| \`Ctrl+D\` | Exit shell (if line is empty) |\n"
    set kb_content "$kb_content""| \`Ctrl+Z\` | Suspend current job |\n"
    set kb_content "$kb_content""\n"

    set kb_content "$kb_content""## Custom Keybindings\n\n"
    set kb_content "$kb_content""_No custom keybindings configured._\n\n"
    set kb_content "$kb_content""To add custom keybindings, edit \`~/.config/fish/config.fish\` and add:\n\n"
    set kb_content "$kb_content""```fish\n"
    set kb_content "$kb_content""bind \\c<key> '<command>'\n"
    set kb_content "$kb_content""```\n\n"

    echo -e $kb_content > $keybindings_file

    set_color cyan
    echo "⌨️  Generated keybindings reference"
    set_color normal
end
