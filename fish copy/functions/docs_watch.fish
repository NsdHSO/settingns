function docs_watch --description "Watch for function changes and auto-update documentation"
    set -l config_dir "$HOME/.config/fish"
    set -l functions_dir "$config_dir/functions"

    set_color -o cyan
    echo "👀 Watching for function changes..."
    echo "Press Ctrl+C to stop"
    set_color normal

    # Initial documentation generation
    generate_docs

    # Watch for changes (macOS uses fswatch if available)
    if command -q fswatch
        fswatch -o $functions_dir | while read -l event
            set_color yellow
            echo ""
            echo "🔄 Changes detected in functions directory"
            set_color normal
            generate_docs
        end
    else
        set_color yellow
        echo "⚠️  fswatch not found. Install with: brew install fswatch"
        echo "📝 Falling back to manual updates. Run 'generate_docs' when you modify functions."
        set_color normal
        return 1
    end
end
