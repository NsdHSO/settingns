#!/usr/bin/env fish
# ==============================================================================
# Fish Shell Greeting
# ==============================================================================
# Custom greeting shown when starting a new Fish shell session
# ==============================================================================

function fish_greeting
    # Show a random abbreviation tip
    if type -q abbr_tips
        abbr_tips
        echo ""
    end

    # Show quick help
    set_color --dim
    echo "Type 'abbr_help' for abbreviation help, 'abbr_cheatsheet' for quick reference"
    set_color normal
end
