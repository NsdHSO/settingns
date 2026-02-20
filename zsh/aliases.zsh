# Port and process management
alias lsop="lsof -i"
alias kila="kill -9"

# Yarn aliases
alias yai="ylock"
# yall and yas are defined as functions in ~/.config/zsh/functions/

# Git aliases
alias gid="git diff"
alias gdd="git add"
alias gis="git status"
alias gip="git push"
alias gic="git cz"
alias gio="git"
alias gim="git commit -m"
alias gtf="git"
alias gtt="git"
alias ghc="git"
alias gty="git"
alias gtd="git"

# Editor
alias vim=nvim

# Directory listing
alias la='ls -la'

# Python
alias pqp="python3"
alias python="python3"

# IDEs
alias idea="/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea"
alias web="/Applications/WebStorm.app/Contents/MacOS/webstorm"

# Package managers
alias pn="pnpm"
alias pnd="pnpm"

# Custom tools
alias nxg="nxg"

# Work directory shortcut
alias work®='cd /Users/davidsamuel.nechifor/Work/financial_health/; echo "🚀 Moved to /Users/davidsamuel.nechifor/Work/financial_health/"'

# ============================================================================
# Modern CLI Tool Aliases (Added 2026-02-19)
# ============================================================================

# Eza (modern ls replacement)
alias ls='eza --icons --git'
alias ll='eza -la --icons --git'
alias la='eza -a --icons --git'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=3 --icons'
alias lg='eza -la --icons --git --git-ignore'

# Bat (modern cat replacement)
alias cat='bat --theme=Dracula'
alias catt='bat --theme=Dracula --style=plain'  # cat without line numbers

# Keep original commands accessible
alias ols='\ls'
alias ocat='\cat'
alias ogrep='\grep'
alias ofind='\find'

# Additional tool shortcuts
alias tree='eza --tree --icons'
alias help='tldr'      # Quick command help
alias du='dust'        # Better disk usage
alias df='duf'         # Better disk free
alias ps='procs'       # Better process viewer

# ============================================================================
# Git Enhancement Aliases (Added 2026-02-19)
# ============================================================================

# Lazygit
alias lg='lazygit'

# Enhanced git commands (use delta automatically via gitconfig)
alias gd='git diff'
alias gds='git diff --staged'
alias gdc='git diff --cached'

# Pretty git log
alias glog='git log --graph --oneline --decorate --all'
alias gloga='git log --graph --decorate --all'
alias glogs='git log --graph --oneline --decorate --stat'

# Git status
alias gs='git status'
alias gss='git status -s'

# GitHub CLI shortcuts (if gh installed)
alias prs='gh pr status'
alias prv='gh pr view'
alias prc='gh pr create'
alias prlist='gh pr list'

# Git branch shortcuts
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
