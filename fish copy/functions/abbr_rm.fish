#!/usr/bin/env fish
# ==============================================================================
# Remove Custom Abbreviation
# ==============================================================================
# Function to remove personal abbreviations from file and session
# Usage: abbr_rm <name>
# Example: abbr_rm gpp
# ==============================================================================

function abbr_rm --description "Remove a custom abbreviation permanently"
    if test (count $argv) -ne 1
        echo "Usage: abbr_rm <name>"
        echo "Example: abbr_rm gpp"
        return 1
    end

    set -l abbr_name $argv[1]
    set -l abbr_file ~/.config/fish/personalized/abbreviations.fish

    # Check if abbreviation exists
    if not abbr --show | grep -q "abbr -a $abbr_name "
        echo "❌ Abbreviation '$abbr_name' does not exist"
        return 1
    end

    # Show current expansion
    echo "Current expansion: "(abbr --show | grep "^abbr -a $abbr_name " | sed "s/abbr -a $abbr_name //")

    # Remove from current session
    abbr -e $abbr_name

    # Remove from file if it exists
    if test -f $abbr_file
        if grep -q "abbr -a $abbr_name " $abbr_file
            sed -i '' "/abbr -a $abbr_name /d" $abbr_file
            echo "✅ Abbreviation '$abbr_name' removed from $abbr_file"
        end
    end

    echo "✅ Abbreviation '$abbr_name' removed from current session"
end
