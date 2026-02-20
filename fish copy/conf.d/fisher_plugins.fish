# Fisher Plugins Installation Helper
# Install recommended plugins for context-aware completions

# Note: Run these commands manually to install plugins:
# fisher install gazorby/fish-abbreviation-tips
# fisher install laughedelic/pisces

# After installation, this file will configure the plugins

# Configure fish-abbreviation-tips
if test -d "$__fish_config_dir/functions" -a -f "$__fish_config_dir/functions/abbr_tips.fish"
    # Plugin is installed
    # Show abbreviation tips on the right side
    set -g fish_abbr_tips_position right

    # Set a custom color for tips (cyan)
    set -g fish_abbr_tips_color cyan
end

# Configure pisces (auto-pair brackets)
if test -d "$__fish_config_dir/functions" -a -f "$__fish_config_dir/functions/_pisces_*.fish"
    # Plugin is installed
    # Pisces works automatically, no configuration needed
    # It auto-closes: (), [], {}, "", '', ``
end
