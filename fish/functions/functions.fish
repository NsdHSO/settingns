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

    # Normalize type and determine emoji
    switch (string lower $input_type)
        case r
            set type refactor; set emoji "👷"
        case f fi
            set type fix; set emoji "🛠️"
        case d
            set type docs; set emoji "📝"
        case s
            set type style; set emoji "🎨"
        case t
            set type test; set emoji "🐳"
        case c
            set type chore; set emoji "🌻"
        case p
            set type perf; set emoji "🚀"
        case feat
            set type feat; set emoji "🎸"
        case test
            set type test; set emoji "🐳"
        case chore
            set type chore; set emoji "🌻"
        case fix
            set type fix; set emoji "🛠️"
        case style
            set type style; set emoji "🎨"
        case docs
            set type docs; set emoji "📝"
        case perf
            set type perf; set emoji "🚀"
        case refactor
            set type refactor; set emoji "👷"
        case revert
            set type revert; set emoji "⏪"
        case '*'
            echo "❌ Unknown commit type: $input_type"
            return 1
    end

    # Capitalize type if original input was uppercase
    if string match -rq '^[A-Z]' -- $input_type
        set type (string upper (string sub -s 1 -l 1 $type))(string sub -s 2 $type)
    end

    git commit -m "$type: $emoji $message"
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


function ginit
    # Check if we're in a directory with .git
    if test -d .git
        # Remove existing hooks
        rm -rf .git/hooks
        echo "🧹 Removed existing git hooks"
    end
    
    # Run git init
    git init
    echo "✅ Git repository initialized without hooks"
end

function yaw
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json
    set -l managers pnpm yarn npm
    set -l found 0
    set -l manager ""  # Declare manager in the function scope

    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            set manager $managers[$i]  # No `-l`, so it's not scoped locally to the loo
            set found 1
            break
        end
    end

    if test $found -eq 0
        echo "❌  No lockfile found. Cannot determine package manager."
        return 1
    end

    echo "🧩  Detected package manager: $manager"
    
    switch $manager
        case yarn
            echo "🚀  Running: yarn test:w"
            yarn test:w
        case npm
            echo "🚀  Running: npm run-script test:w"
            npm run-script test:w
        case pnpm
            echo "🚀  Running: pnpm run test:w"
            pnpm run test:w
        case '*'
            echo "⚠️  Unsupported package manager: $manager"
            return 1
    end
end
