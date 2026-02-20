# Advanced ZSH Completion Configuration
# Created: 2026-02-19

# ============================================================================
# Completion System Initialization
# ============================================================================
autoload -Uz compinit
compinit

# ============================================================================
# Completion Behavior
# ============================================================================

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Use menu selection for completion
zstyle ':completion:*' menu select

# Colorful completion (uses LS_COLORS)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group completions by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Better directory completion
zstyle ':completion:*' special-dirs true

# Fuzzy matching (typo tolerance)
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Cache completion results for faster subsequent completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion-cache

# ============================================================================
# Command-Specific Completions
# ============================================================================

# Kill command completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# SSH/SCP/RSYNC hostname completion
zstyle ':completion:*:(ssh|scp|rsync):*' hosts off

# Git completion optimization
zstyle ':completion:*:git-checkout:*' sort false

# ============================================================================
# History Substring Search Configuration
# ============================================================================

# Bind arrow keys for history substring search
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey '^P' history-substring-search-up        # Ctrl+P
bindkey '^N' history-substring-search-down      # Ctrl+N

# History substring search highlighting
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY=1

# ============================================================================
# Additional Completion Settings
# ============================================================================

# Automatically rehash commands (find new executables in PATH)
zstyle ':completion:*' rehash true

# Verbose completion for better understanding
zstyle ':completion:*' verbose yes

# Show completion menu on successive tab press
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Don't beep on ambiguous completion
setopt NO_BEEP
setopt NO_LIST_BEEP

# Automatically list choices on ambiguous completion
setopt AUTO_LIST

# ============================================================================
# Modern Tool Completions
# ============================================================================

# Enable completion for modern tools
# eza, bat, ripgrep, fd completions are built-in
# Additional completions loaded via zsh-completions plugin

# Refresh completion cache
zstyle ':completion:*' rehash true
