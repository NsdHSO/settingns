killport() {
    if [[ $# -eq 0 ]]; then
        echo "\033[31m🚨 Usage: killport <port>\033[0m"
        return 1
    fi
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "\033[33m🌪️ Invalid port number!\033[0m"
        return 1
    fi
    local port=$1
    local pids=($(lsof -ti :$port 2>/dev/null))
    if [[ ${#pids[@]} -eq 0 ]]; then
        echo "\033[36m🛸 Port $port: No active processes\033[0m"
        return
    fi
    echo "\033[1;34m🎯 Targeted Port: $port"
    echo "📡 Detected Processes:\033[0m"
    local index=1
    for pid in "${pids[@]}"; do
        local app=$(ps -p $pid -o comm= 2>/dev/null)
        echo "\033[35m$index) 💀 PID $pid [APP: $app]\033[0m"
        ((index++))
    done
    echo -n "\033[1;33m🌌 Enter numbers to kill (0 to abort): \033[0m"
    read choices
    if [[ -z "$choices" ]] || [[ "$choices" =~ ^0+$ ]]; then
        echo "\033[36m🛸 Mission aborted\033[0m"
        return
    fi
    for choice in ${=choices}; do
        if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ $choice -ge $index ]] || [[ $choice -eq 0 ]]; then
            echo "⚠️ Invalid choice: $choice"
            continue
        fi
        local pid=${pids[$choice]}
        echo "\033[31m🔥 Terminating PID $pid...\033[0m"
        if kill -9 $pid 2>/dev/null; then
            echo "\033[32m✅ Success! PID $pid terminated\033[0m"
        else
            echo "\033[31m❌ Failed to kill PID $pid\033[0m"
        fi
    done
    echo "\033[1;36m🪐 Operation complete\033[0m"
}
