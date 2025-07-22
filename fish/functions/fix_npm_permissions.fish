function fix_npm_permissions --description 'Fix npm global permissions to avoid EACCES errors'
    # Create the directory for npm global installations
    mkdir -p ~/.npm-global

    # Configure npm to use the new directory
    npm config set prefix "$HOME/.npm-global"

    # Add the new bin directory to PATH in fish config
    if not grep -q "npm-global/bin" ~/.config/fish/config.fish
        echo "" >> ~/.config/fish/config.fish
        echo "# Add npm global bin to PATH" >> ~/.config/fish/config.fish
        echo "set -gx PATH \$PATH \$HOME/.npm-global/bin" >> ~/.config/fish/config.fish
        echo "Path updated in fish config"
    else
        echo "Path already updated in fish config"
    end

    # Source the updated config
    source ~/.config/fish/config.fish

    echo "npm global permissions fixed!"
    echo "You can now install global packages without sudo"
end
