#!/usr/bin/env fish
# ==============================================================================
# List All Abbreviations
# ==============================================================================
# Function to display all abbreviations in a readable format
# Usage: abbr_list [filter]
# Example: abbr_list git
# ==============================================================================

function abbr_list --description "List all abbreviations with optional filter"
    set -l filter $argv[1]

    if test -n "$filter"
        echo "🔍 Abbreviations matching '$filter':"
        abbr --show | grep "$filter" | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color green
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end
    else
        echo "📋 All Abbreviations:"
        echo ""

        # Group by category
        echo "🔷 Git:"
        abbr --show | grep "abbr -a g" | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color green
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end

        echo ""
        echo "🔷 Docker:"
        abbr --show | grep "abbr -a d" | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color cyan
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end

        echo ""
        echo "🔷 Kubernetes:"
        abbr --show | grep "abbr -a k" | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color blue
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end

        echo ""
        echo "🔷 Package Managers:"
        abbr --show | grep -E "abbr -a [npy]" | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color yellow
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end

        echo ""
        echo "💡 Tip: Use 'abbr_list <filter>' to filter abbreviations"
        echo "📝 Tip: Use 'abbr_add <name> <expansion>' to add custom abbreviations"
    end
end
