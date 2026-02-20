# fzf key bindings
# Ctrl+R: Command history search
# Ctrl+T: File search
# Alt+C: Directory search

# Enable fzf key bindings
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Additional custom bindings
bindkey -e  # Use emacs key bindings

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Line editing
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word

# Option+Backspace to delete word backward
bindkey '^[^?' backward-kill-word  # Option+Backspace
bindkey '^[^H' backward-kill-word  # Alternative binding

# Option+Delete to delete word forward
bindkey '^[[3;3~' kill-word  # Option+Delete
