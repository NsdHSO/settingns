function yall
    set_color red
    echo "🔥 Removing node_modules..."
    set_color normal
    rm -rf node_modules
    ylock
    set_color green
    echo "🎉 Fresh start complete 💫"
    set_color normal
end
