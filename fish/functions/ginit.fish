function ginit
    # Initialize Git repository
    git init
    set_color green
    echo "✅ Git repository initialized"
    set_color normal
    
    # Set up hooks
    ghooks
end
