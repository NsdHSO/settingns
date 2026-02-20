yall() {
    echo -e "\033[31m🔥 Removing node_modules...\033[0m"
    rm -rf node_modules
    ylock
    echo -e "\033[32m🎉 Fresh start complete 💫\033[0m"
}
