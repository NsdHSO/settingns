# Auto-source all function files from ~/.config/zsh/functions/
for func_file in ~/.config/zsh/functions/*.zsh(N); do
  source "$func_file"
done
