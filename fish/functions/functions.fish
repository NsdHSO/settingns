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
    set -l input_type $argv[1]
    set -l message "$argv[2..-1]"

    # Normalize the input type
    switch $input_type
        case r
            set type refactor
        case R
            set type refactor
        case f
            set type feat
        case F
            set type fix
        case fi
            set type fix
        case Fi
            set type fix
        case d
            set type docs
        case D
            set type docs
        case s
            set type style
        case S
            set type style
        case t
            set type test
        case T
            set type test
        case c
            set type chore
        case C
            set type chore
        case p
            set type perf
        case P
            set type perf
        case feat
            set type feat
        case test
            set type test
        case chore
            set type chore
        case fix
            set type fix
        case style
            set type style
        case docs
            set type docs
        case refactor
            set type refactor
        case perf
            set type perf
        case revert
            set type revert
        case '*'
            echo "❌ Unknown commit type: $input_type"
            return 1
    end

    git commit -m "$type: $message"
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