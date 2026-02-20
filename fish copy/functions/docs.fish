function docs --description "Display documentation for fish functions"
    set -l config_dir "$HOME/.config/fish"
    set -l docs_dir "$config_dir/docs"
    set -l readme_file "$config_dir/README.md"

    # If no arguments, show README or list available docs
    if test (count $argv) -eq 0
        if test -f $readme_file
            if command -q bat
                bat --style=plain --paging=always $readme_file
            else if command -q less
                less $readme_file
            else
                cat $readme_file
            end
        else
            set_color yellow
            echo "📚 Documentation not generated yet."
            echo "Run 'generate_docs' to create documentation."
            set_color normal
            return 1
        end
        return 0
    end

    # Handle special arguments
    switch $argv[1]
        case --generate -g
            generate_docs
            return 0
        case --watch -w
            docs_watch
            return 0
        case --keybindings -k
            set -l kb_file "$config_dir/KEYBINDINGS.md"
            if test -f $kb_file
                if command -q bat
                    bat --style=plain --paging=always $kb_file
                else if command -q less
                    less $kb_file
                else
                    cat $kb_file
                end
            else
                set_color yellow
                echo "⌨️  Keybindings documentation not generated yet."
                echo "Run 'generate_docs' to create documentation."
                set_color normal
                return 1
            end
            return 0
        case --list -l
            set_color -o cyan
            echo "📋 Available Documentation:"
            set_color normal
            if test -d $docs_dir
                for doc in (ls $docs_dir/*.md 2>/dev/null)
                    set -l func_name (basename $doc .md)
                    set_color green
                    echo "  • $func_name"
                    set_color normal
                end
            else
                set_color yellow
                echo "No documentation found. Run 'generate_docs' first."
                set_color normal
            end
            return 0
        case --help -h
            set_color -o cyan
            echo "Fish Functions Documentation Viewer"
            echo ""
            set_color normal
            echo "Usage:"
            echo "  docs                Show main README"
            echo "  docs <function>     Show specific function documentation"
            echo "  docs --generate     Generate/regenerate documentation"
            echo "  docs --watch        Watch for changes and auto-update"
            echo "  docs --keybindings  Show keybindings reference"
            echo "  docs --list         List all documented functions"
            echo ""
            return 0
    end

    # Show specific function documentation
    set -l func_name $argv[1]
    set -l func_doc "$docs_dir/$func_name.md"

    if test -f $func_doc
        if command -q bat
            bat --style=plain --paging=always $func_doc
        else if command -q less
            less $func_doc
        else
            cat $func_doc
        end
    else
        set_color red
        echo "❌ Documentation not found for: $func_name"
        set_color yellow
        echo "💡 Run 'docs --list' to see available documentation"
        echo "💡 Run 'generate_docs' to regenerate documentation"
        set_color normal
        return 1
    end
end
