# Modern CLI Tools Configuration
# Source this file in .zshrc

# ============================================================================
# Bat Configuration
# ============================================================================
export BAT_THEME="Dracula"
export BAT_STYLE="numbers,changes,header"

# ============================================================================
# Eza Configuration
# ============================================================================
export EZA_ICONS_AUTO=1

# ============================================================================
# FZF Integration with Bat for Preview
# ============================================================================
# Use bat for file previews in fzf
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}' --preview-window=right:60%"

# Use fd instead of find for fzf (respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ============================================================================
# Ripgrep Configuration
# ============================================================================
# Use ripgrep config file if it exists
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# ============================================================================
# Tool Info
# ============================================================================
# Uncomment to see which modern tools are loaded on shell startup
# echo "Modern CLI tools loaded: eza, bat, ripgrep, fd, delta, tldr, broot, procs, dust, duf"

# ============================================================================
# Tool-Specific Completion Configuration
# ============================================================================

# Homebrew completion (if installed)
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# npm completion
if type npm &>/dev/null; then
    eval "$(npm completion 2>/dev/null)"
fi

# GitHub CLI completion
if type gh &>/dev/null; then
    eval "$(gh completion -s zsh 2>/dev/null)"
fi

# Docker completion (if installed)
if type docker &>/dev/null && [ -f /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ]; then
    fpath=(/Applications/Docker.app/Contents/Resources/etc $fpath)
fi
