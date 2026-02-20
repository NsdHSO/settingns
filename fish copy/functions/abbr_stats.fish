#!/usr/bin/env fish
# ==============================================================================
# Abbreviation Statistics
# ==============================================================================
# Show statistics about abbreviations
# Usage: abbr_stats
# ==============================================================================

function abbr_stats --description "Show abbreviation statistics"
    set -l total (abbr --show | wc -l | string trim)
    set -l git_count (abbr --show | grep "abbr -a g" | wc -l | string trim)
    set -l docker_count (abbr --show | grep "abbr -a d" | wc -l | string trim)
    set -l k8s_count (abbr --show | grep "abbr -a k" | wc -l | string trim)
    set -l custom_count 0

    if test -f ~/.config/fish/personalized/abbreviations.fish
        set custom_count (grep "^abbr -a" ~/.config/fish/personalized/abbreviations.fish | wc -l | string trim)
    end

    set_color --bold cyan
    echo "╔══════════════════════════════════════════╗"
    echo "║    Abbreviation Statistics               ║"
    echo "╚══════════════════════════════════════════╝"
    set_color normal
    echo ""

    set_color yellow
    echo "📊 Total Abbreviations: $total"
    set_color normal
    echo ""

    echo "By Category:"
    set_color green
    echo "  🔷 Git:          $git_count"
    set_color cyan
    echo "  🔷 Docker:       $docker_count"
    set_color blue
    echo "  🔷 Kubernetes:   $k8s_count"
    set_color magenta
    echo "  🔷 Custom:       $custom_count"
    set_color normal
    echo ""

    if test $custom_count -gt 0
        echo "Your Custom Abbreviations:"
        grep "^abbr -a" ~/.config/fish/personalized/abbreviations.fish | while read -l line
            set -l parts (string split -m 1 " " (string replace "abbr -a " "" $line))
            set_color green
            printf "  %-15s" $parts[1]
            set_color normal
            echo " → $parts[2]"
        end
        echo ""
    end

    set_color yellow
    echo "💡 Run 'abbr_help' for usage information"
    set_color normal
end
