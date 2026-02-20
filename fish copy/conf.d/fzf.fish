# FZF Configuration for Fish Shell
# Phenomenon theme colors integration

# Set FZF default options with Phenomenon theme colors
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#1e1e2e,bg:#0d0d0d,spinner:#F43F5E,hl:#3B82F6 \
--color=fg:#E5E5E5,header:#3B82F6,info:#14B8A6,pointer:#F43F5E \
--color=marker:#22C55E,fg+:#E5E5E5,prompt:#BF409D,hl+:#3B82F6 \
--height=40% \
--layout=reverse \
--border \
--inline-info \
--preview-window=right:60% \
--bind='ctrl-/:toggle-preview'"

# Use fd if available for faster file finding
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

# Enable preview with bat if available
if command -q bat
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
end

# Preview directories with eza or ls
if command -q eza
    set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=2 --color=always {}'"
else
    set -gx FZF_ALT_C_OPTS "--preview 'ls -la {}'"
end

# FZF key bindings (these will be overridden by fzf.fish plugin if installed)
# Ctrl+R: Command history
# Ctrl+T: File finder
# Alt+C: Directory changer

# Custom FZF integrations
set -gx FZF_TMUX 1
set -gx FZF_TMUX_HEIGHT "40%"
