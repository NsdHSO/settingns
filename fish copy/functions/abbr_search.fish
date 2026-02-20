#!/usr/bin/env fish
# ==============================================================================
# Search Abbreviations
# ==============================================================================
# Search for abbreviations by name or expansion
# Usage: abbr_search <term>
# Example: abbr_search checkout
# ==============================================================================

function abbr_search --description "Search for abbreviations by name or expansion"
    if test (count $argv) -ne 1
        echo "Usage: abbr_search <term>"
        echo "Example: abbr_search checkout"
        return 1
    end

    set -l search_term $argv[1]
    set -l results (abbr --show | grep -i "$search_term")

    if test -z "$results"
        echo "❌ No abbreviations found matching '$search_term'"
        return 1
    end

    echo "🔍 Abbreviations matching '$search_term':"
    echo ""

    echo $results | while read -l line
        set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
        set_color green
        printf "  %-20s" $parts[1]
        set_color normal
        echo " → $parts[2]"
    end

    echo ""
    echo "💡 Found "(echo $results | wc -l | string trim)" match(es)"
end
