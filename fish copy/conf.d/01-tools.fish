# ============================================================================
# Tool Initializations for Fish Shell
# ============================================================================
# This file initializes external tools that enhance shell functionality.
# Tools are loaded in order of dependency.

# ----------------------------------------------------------------------------
# Modern CLI Tools Aliases
# ----------------------------------------------------------------------------
# bat - cat replacement with syntax highlighting
# eza - ls replacement with icons
# fd - find replacement (faster, user-friendly)
# ripgrep - grep replacement (faster)
# delta - git diff pager (configured in ~/.gitconfig)

# bat configuration - cat with syntax highlighting
alias cat='bat --paging=never --style=plain'

# eza configuration - modern ls replacement
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'

# fd configuration - modern find replacement
alias find='fd'

# ripgrep configuration - modern grep replacement
alias grep='rg'

# ----------------------------------------------------------------------------
# Zoxide - Smart Directory Navigation
# ----------------------------------------------------------------------------
# Zoxide learns your most used directories and provides intelligent jumping.
# Usage:
#   z <partial-path>  - Jump to a directory matching the query
#   zi                - Interactive directory selection with fzf
#   z -                - Jump to previous directory
#   zoxide query <query> - Query the database without jumping

if command -q zoxide
    zoxide init fish | source
end
set -e RIPGREP_CONFIG_PATH 2>/dev/null
