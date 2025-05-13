# Nx Generator Shortcuts
function nxg
    if test (count $argv) -lt 2
        echo "Usage: nxg <type> <name>"
        return 1
    end

    set -l type $argv[1]
    set -l name $argv[2]

    switch $type
        case interface
            nx g interface $name

        case service s
            nx g @nx/angular:service --name=$name

        case component c
            mkdir -p $name && cd $name
            echo "Directory ✋🏿🧑🏿‍🦲🤚🏿🔫👮🏻: $name | 🚥 Changed into directory"
            nx g @nx/angular:component --name=$name --standalone=true --nameAndDirectoryFormat=as-provided
            echo "Component ▄︻デ۪۞━一💥 : $name created"

        case '*'
            nx g @nx/angular:$type --name=$name --standalone=true
    end
end
function gc
    set -l type $argv[1]
    set -l message (string join " " $argv[2..-1])

    # Check for Unicode/emoji support
    set -l emoji_supported
    if string match -qr 'UTF-8|utf8' -- $LANG
        set emoji_supported true
    end

    # Define both text and emoji markers
    switch $type
        case feat    
            set emoji "🎸"
            set text  "=>"
        case test    
            set emoji "🐳"
            set text  "=>"
        case chore   
            set emoji "🌻"
            set text  "~>"
        case fix     
            set emoji "🛠️"
            set text  "!>"
        case style   
            set emoji "🎯"
            set text  "**"
        case docs    
            set emoji "📝"
            set text  "##"
        case refactor
            set emoji "👷"
            set text  "<>"
        case '*'     
            return 1
    end

    # Choose marker based on support
    if set -q emoji_supported
        set marker $emoji
    else
        set marker $text
    end

    git commit -m "$type: $marker $message"
end

# Directory Navigation
function ...;    cd ../..; end
function ....;   cd ../../..; end
function .....;  cd ../../../..; end

# Package Manager Helpers
function ylock
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json
    set -l managers pnpm yarn npm

    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            echo "🧹 Removing $lockfiles[$i]..."
            rm -f $lockfiles[$i]
            echo "📦 Installing with $managers[$i]..."
            command $managers[$i] install
            return
        end
    end

    echo "❌ No lockfile found"
    return 1
end

function yall
    echo "🔥 Removing node_modules..."
    rm -rf node_modules
    ylock
    echo "🎉 Fresh start complete 💫"
end

function yas
    set -l managers pnpm yarn npm
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json

    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            echo "🚀 Starting with $managers[$i]..."
            command $managers[$i] start
            return
        end
    end

    echo "❌ No lockfile found"
    return 1
end

# Git Operations
function gio
    echo "🛰️👽 ---->>>>----M<<<<<---- 👽🛰️"
    echo "🔍📡 Scanning the galaxy (fetching)..."
    git fetch
    echo "🧲🌀 Engaging tractor beam (pulling)..."
    git pull
    echo "🌈🛸 Sync complete. Universe updated! 🌍✅"
    echo "💥 BOOM 💥 ---->>>>----M<<<<<---- 💥"
end

# Process Management
function killport
    if test (count $argv) -eq 0
        echo "🚨 Usage: killport <port>"
        return 1
    end

    if not string match -qr '^\d+$' -- $argv[1]
        echo "🌪️ Invalid port number!"
        return 1
    end

    set -l port $argv[1]
    set -l pids (lsof -ti :$port | string split " ")

    if test -z "$pids"
        echo "🛸 Port $port: No active processes"
        return
    end

    echo "🎯 Targeted Port: $port"
    echo "📡 Detected Processes:"
    
    set -l index 1
    for pid in $pids
        set -l app (ps -p $pid -o comm=)
        echo "$index) 💀 PID $pid [APP: $app]"
        set index (math $index + 1)
    end

    read -l -P "🌌 Enter numbers to kill (0 to abort): " choices

    if test -z "$choices" || string match -qr '^0+$' -- "$choices"
        echo "🛸 Mission aborted"
        return
    end

    for choice in (string split " " -- $choices)
        if not string match -qr '^\d+$' -- "$choice" || test $choice -ge $index
            echo "⚠️ Invalid choice: $choice"
            continue
        end

        set -l pid $pids[$choice]
        echo "🔥 Terminating PID $pid..."
        if kill -9 $pid
            echo "✅ Success! PID $pid terminated"
        else
            echo "❌ Failed to kill PID $pid"
        end
    end
    
    echo "🪐 Operation complete"
end