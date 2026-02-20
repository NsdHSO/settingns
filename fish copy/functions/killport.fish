function killport
    if test (count $argv) -eq 0
        set_color red
        echo "🚨 Usage: killport <port>"
        set_color normal
        return 1
    end
    if not string match -qr '^[0-9]+$' -- $argv[1]
        set_color yellow
        echo "🌪️ Invalid port number!"
        set_color normal
        return 1
    end
    set -l port $argv[1]
    set -l pids (lsof -ti :$port | string split " ")
    if test -z "$pids"
        set_color cyan
        echo "🛸 Port $port: No active processes"
        set_color normal
        return
    end
    set_color -o blue
    echo "🎯 Targeted Port: $port"
    echo "📡 Detected Processes:"
    set -l index 1
    for pid in $pids
        set -l app (ps -p $pid -o comm=)
        set_color magenta
        echo "$index) 💀 PID $pid [APP: $app]"
        set_color normal
        set index (math $index + 1)
    end
    set_color -o yellow
    read -l -P "🌌 Enter numbers to kill (0 to abort): " choices
    set_color normal
    if test -z "$choices" || string match -qr '^0+$' -- "$choices"
        set_color cyan
        echo "🛸 Mission aborted"
        set_color normal
        return
    end
    for choice in (string split " " -- $choices)
        if not string match -qr '^[0-9]+$' -- "$choice" || test $choice -ge $index
            echo "⚠️ Invalid choice: $choice"
            continue
        end
        set -l pid $pids[$choice]
        set_color red
        echo "🔥 Terminating PID $pid..."
        if kill -9 $pid
            set_color green
            echo "✅ Success! PID $pid terminated"
        else
            set_color red
            echo "❌ Failed to kill PID $pid"
        end
        set_color normal
    end
    set_color -o cyan
    echo "🪐 Operation complete"
    set_color normal
end
