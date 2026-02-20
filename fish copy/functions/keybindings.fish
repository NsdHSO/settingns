function keybindings --description 'Display Fish shell keybindings reference'
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║          FISH SHELL KEYBINDINGS QUICK REFERENCE                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    set_color cyan
    echo "EDITOR INTEGRATION:"
    set_color normal
    echo "  Alt+E              Edit command in \$EDITOR"
    echo "  Ctrl+X Ctrl+E      Edit command (alternative)"
    echo ""

    set_color cyan
    echo "COMMAND MODIFICATION:"
    set_color normal
    echo "  Alt+S              Toggle sudo prefix"
    echo "  Alt+.              Insert last argument"
    echo ""

    set_color cyan
    echo "CLIPBOARD (macOS):"
    set_color normal
    echo "  Ctrl+X Ctrl+C      Copy command"
    echo "  Ctrl+X Ctrl+V      Paste from clipboard"
    echo ""

    set_color cyan
    echo "NAVIGATION:"
    set_color normal
    echo "  Alt+B / Alt+F      Move word backward/forward"
    echo "  Ctrl+A / Ctrl+E    Move to start/end of line"
    echo ""

    set_color cyan
    echo "HISTORY:"
    set_color normal
    echo "  Ctrl+R             Search history"
    echo "  Alt+P / Alt+N      Previous/next with prefix"
    echo ""

    set_color cyan
    echo "DIRECTORY:"
    set_color normal
    echo "  Alt+Up             Go to parent (cd ..)"
    echo "  Alt+Left           Go to previous (cd -)"
    echo ""

    set_color cyan
    echo "SCREEN:"
    set_color normal
    echo "  Ctrl+L             Clear screen & scrollback"
    echo ""

    set_color yellow
    echo "VIM MODE (disabled by default):"
    set_color normal
    echo "  Enable: set -g FISH_VIM_MODE 1"
    echo ""

    set_color green
    echo "For full documentation, see:"
    set_color normal
    echo "  ~/.config/fish/KEYBINDINGS.md"
    echo "  ~/.config/fish/KEYBINDINGS-SUMMARY.txt"
    echo ""
end
