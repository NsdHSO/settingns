# FZF Installation Checker
# Usage: fzf-check - verify fzf installation and features

function fzf-check --description "Check fzf installation and available features"
    set_color --bold magenta
    echo "=== FZF Installation Status ==="
    set_color normal
    echo ""

    # Check fzf binary
    set_color --bold cyan
    echo "1. FZF Binary:"
    set_color normal
    if command -q fzf
        set_color green
        echo "   ✓ Installed: "(which fzf)
        echo "   ✓ Version: "(fzf --version)
        set_color normal
    else
        set_color red
        echo "   ✗ Not installed"
        echo "   → Install with: brew install fzf"
        set_color normal
    end
    echo ""

    # Check fzf.fish plugin
    set_color --bold cyan
    echo "2. FZF.fish Plugin (optional):"
    set_color normal
    if type -q __fzf_search_history
        set_color green
        echo "   ✓ Installed"
        set_color normal
    else
        set_color yellow
        echo "   ⚠ Not installed (optional)"
        echo "   → Install with: fisher install PatrickF1/fzf.fish"
        set_color normal
    end
    echo ""

    # Check optional dependencies
    set_color --bold cyan
    echo "3. Optional Dependencies:"
    set_color normal

    # fd
    if command -q fd
        set_color green
        echo "   ✓ fd: "(which fd)
        set_color normal
    else
        set_color yellow
        echo "   ⚠ fd: Not installed (recommended)"
        echo "     → Install with: brew install fd"
        set_color normal
    end

    # bat
    if command -q bat
        set_color green
        echo "   ✓ bat: "(which bat)
        set_color normal
    else
        set_color yellow
        echo "   ⚠ bat: Not installed (recommended)"
        echo "     → Install with: brew install bat"
        set_color normal
    end

    # eza
    if command -q eza
        set_color green
        echo "   ✓ eza: "(which eza)
        set_color normal
    else
        set_color yellow
        echo "   ⚠ eza: Not installed (recommended)"
        echo "     → Install with: brew install eza"
        set_color normal
    end
    echo ""

    # Check custom functions
    set_color --bold cyan
    echo "4. Custom FZF Functions:"
    set_color normal

    set -l fzf_functions fgb fkill fcd fge fh
    for fn in $fzf_functions
        if type -q $fn
            set_color green
            echo "   ✓ $fn: Available"
            set_color normal
        else
            set_color red
            echo "   ✗ $fn: Not found"
            set_color normal
        end
    end
    echo ""

    # Check configuration
    set_color --bold cyan
    echo "5. Configuration Files:"
    set_color normal

    if test -f ~/.config/fish/conf.d/fzf.fish
        set_color green
        echo "   ✓ FZF config: ~/.config/fish/conf.d/fzf.fish"
        set_color normal
    else
        set_color red
        echo "   ✗ FZF config: Not found"
        set_color normal
    end
    echo ""

    # Environment variables
    set_color --bold cyan
    echo "6. Environment Variables:"
    set_color normal

    if set -q FZF_DEFAULT_OPTS
        set_color green
        echo "   ✓ FZF_DEFAULT_OPTS: Set"
        set_color normal
    else
        set_color yellow
        echo "   ⚠ FZF_DEFAULT_OPTS: Not set"
        set_color normal
    end

    if set -q FZF_DEFAULT_COMMAND
        set_color green
        echo "   ✓ FZF_DEFAULT_COMMAND: "$FZF_DEFAULT_COMMAND
        set_color normal
    else
        set_color yellow
        echo "   ⚠ FZF_DEFAULT_COMMAND: Not set"
        set_color normal
    end
    echo ""

    # Summary
    set_color --bold magenta
    echo "=== Quick Test Commands ==="
    set_color normal
    echo "  fgb     - Fuzzy git branch switcher"
    echo "  fkill   - Fuzzy process killer"
    echo "  fcd     - Fuzzy directory changer"
    echo "  fge     - Fuzzy git file editor"
    echo "  fh      - Fuzzy command history"
    echo ""

    set_color --bold yellow
    echo "Reload shell to apply changes: source ~/.config/fish/config.fish"
    set_color normal
end
