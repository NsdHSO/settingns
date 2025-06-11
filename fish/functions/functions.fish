# Nx Generator Shortcuts
function nxg
    if test (count $argv) -lt 2
        set_color red
        echo "Usage: nxg <type> <name>"
        set_color normal
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
            set_color cyan
            echo "Directory ✋🏿🧑🏿‍🦲🤚🏿🔫👮🏻: $name | 🚥 Changed into directory"
            set_color normal
            nx g @nx/angular:component --name=$name --standalone=true --nameAndDirectoryFormat=as-provided
            set_color green
            echo "Component ▄︻デ۪۞━一💥 : $name created"
            set_color normal

        case '*'
            nx g @nx/angular:$type --name=$name --standalone=true
    end
end

function gc
    set -l input_type $argv[1]
    set -l message "$argv[2..-1]"

    # Normalize type and determine emoj
    switch (string lower $input_type)
        case r
            set type refactor; set emoji "👷"
        case fi
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
        case f
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
            set_color red
            echo "❌ Unknown commit type: $input_type"
            set_color normal
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
            set_color yellow
            echo "🧹 Removing $lockfiles[$i]..."
            set_color normal
            rm -f $lockfiles[$i]
            set_color cyan
            echo "📦 Installing with $managers[$i]..."
            set_color normal
            command $managers[$i] install
            return
        end
    end

    set_color red
    echo "❌ No lockfile found"
    set_color normal
    return 1
end

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

function yas
    set -l managers pnpm yarn npm
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json

    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            set_color cyan
            echo "🚀 Starting with $managers[$i]..."
            set_color normal
            command $managers[$i] start
            return
        end
    end

    set_color red
    echo "❌ No lockfile found"
    set_color normal
    return 1
end

# Git Operations
function gio
    set_color -o blue
    echo "🛰️👽 ---->>>>----M<<<<<---- 👽🛰️"
    set_color cyan
    echo "🔍📡 Scanning the galaxy (fetching)..."
    set_color normal
    git fetch
    set_color magenta
    echo "🧲🌀 Engaging tractor beam (pulling)..."
    set_color normal
    git pull
    set_color green
    echo "🌈🛸 Sync complete. Universe updated! 🌍✅"
    set_color -o yellow
    echo "💥 BOOM 💥 ---->>>>----M<<<<<---- 💥"
    set_color normal
end

function gis
    set_color -o blue
    echo "🔍 Git Status Report 📊"
    echo "----------------------"
    set_color normal
    
    # Get branch info
    set -l branch (git branch --show-current 2>/dev/null)
    if test $status -eq 0
        set_color -o green
        echo "🌿 Branch: $branch"
        set_color normal
    end

    # Check if branch is up to date
    git remote update >/dev/null 2>&1
    set -l upstream_status (git status -uno)
    if string match -q "*up to date*" $upstream_status
        set_color cyan
        echo "✨ Branch is up to date"
    else if string match -q "*behind*" $upstream_status
        set_color yellow
        echo "⚠️ Branch needs pulling"
    else if string match -q "*ahead*" $upstream_status
        set_color magenta
        echo "🚀 Branch needs pushing"
    end
    set_color normal

    # Get status
    set -l status (git status --porcelain 2>/dev/null)
    if test -z "$status"
        set_color green
        echo "✅ Working tree clean"
    else
        set_color yellow
        echo "📝 Changes detected:"
        set_color normal
        
        # Modified files
        git status --porcelain | while read -l line
            switch (echo $line | string sub -l 2)
                case "M*"
                    set_color cyan
                    echo "  🔄 Modified: "(echo $line | string sub -s 4)
                case "A*"
                    set_color green
                    echo "  ➕ Added: "(echo $line | string sub -s 4)
                case "D*"
                    set_color red
                    echo "  ❌ Deleted: "(echo $line | string sub -s 4)
                case "R*"
                    set_color magenta
                    echo "  ♻️  Renamed: "(echo $line | string sub -s 4)
                case "??"
                    set_color yellow
                    echo "  ❓ Untracked: "(echo $line | string sub -s 4)
                case "*"
                    set_color normal
                    echo "  "(echo $line | string sub -s 4)
            end
        end
    end
    
    set_color -o blue
    echo "----------------------"
    set_color normal
end

# Process Management
function killport
    if test (count $argv) -eq 0
        set_color red
        echo "🚨 Usage: killport <port>"
        set_color normal
        return 1
    end

    if not string match -qr '^\d+$' -- $argv[1]
        set_color yellow
        echo "🌪️ Invalid port number!"
        set_color normal
        return 1
    end

    set -l port $argv[1]
    git init
    set_color green
    echo "✅ Git repository initialized without hooks"
    set_color normal
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

function ghard
    set_color yellow
    echo "⚠️  WARNING: This will delete all local changes!"
    echo "📁 Current directory: "(pwd)
    set_color normal
    
    read -l -P "🔥 Press ENTER to confirm (or type 'n' to cancel): " confirm

    if test -z "$confirm" -o "$confirm" = "y" -o "$confirm" = "yes"
        set_color red
        echo "💣 Resetting all changes..."
        git reset --hard
        set_color green
        echo "✨ Reset complete. All changes have been discarded."
        set_color normal
    else
        set_color cyan
        echo "🛟 Operation cancelled. Your changes are safe."
        set_color normal
    end
end
