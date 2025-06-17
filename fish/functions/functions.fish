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
    if test (count $argv) -lt 2
        set_color red
        echo "❌ Usage: gc <type> <message>"
        set_color normal
        return 1
    end

    set -l input_type $argv[1]
    set -l message "$argv[2..-1]"
    set -l type
    set -l emoji

    # Direct mapping without redundant cases
    switch (string lower $input_type)
        case "r" "refactor"
            set type refactor; set emoji "👷"; set_color cyan
        case "fi" "fix"
            set type fix; set emoji "🛠️"; set_color yellow
        case "d" "docs"
            set type docs; set emoji "📝"; set_color blue
        case "s" "style"
            set type style; set emoji "🎨"; set_color magenta
        case "t" "test"
            set type test; set emoji "🐳"; set_color green
        case "c" "chore"
            set type chore; set emoji "🌻"; set_color cyan
        case "p" "perf"
            set type perf; set emoji "🚀"; set_color blue
        case "f" "feat"
            set type feat; set emoji "🎸"; set_color green
        case "revert"
            set type revert; set emoji "⏪"; set_color red
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

    echo "📝 Committing changes..."
    git commit -m "$type: $emoji $message"
    set -l commit_status $status
    
    if test $commit_status -eq 0
        set_color green
        echo "✅ Commit successful!"
        echo "🏷️  $type: $emoji $message"
    else
        set_color red
        echo "❌ Commit failed!"
    end
    set_color normal
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
    echo "🔍📡 Syncing with remote..."
    set_color normal
    
    # Combine fetch and pull into one command
    set -l output (git pull --ff-only 2>&1)
    set -l status
    
    if test $status -eq 0
        if string match -q "*Already up to date*" "$output"
            set_color green
            echo "✨ Already in sync!"
        else
            set_color green
            echo "🌈🛸 Sync complete. Universe updated! 🌍✅"
        end
        set_color -o yellow
        echo "💥 BOOM 💥 ---->>>>----M<<<<<---- 💥"
    else
        set_color red
        echo "❌ Sync failed!"
        echo $output
    end
    set_color normal
end

function gis
    set_color -o blue
    echo "🔍 Git Status Report 📊"
    echo "----------------------"
    set_color normal
    
    # Get all info in one go to avoid multiple git calls
    set -l git_status (git status -b --porcelain=v2 2>/dev/null)
    set -l branch_info (string match -r "# branch.head (.+)" $git_status)[2]
    set -l upstream_info (string match -r "# branch.ab \\+([0-9]+) -([0-9]+)" $git_status)
    
    if test -n "$branch_info"
        set_color -o green
        echo "🌿 Branch: $branch_info"
        set_color normal
    end

    # Check upstream status from cached info
    if test -n "$upstream_info"
        set -l ahead $upstream_info[2]
        set -l behind $upstream_info[3]
        if test $ahead -eq 0 -a $behind -eq 0
            set_color cyan
            echo "✨ Branch is up to date"
        else if test $behind -gt 0
            set_color yellow
            echo "⚠️ Branch needs pulling ($behind commits behind)"
        else if test $ahead -gt 0
            set_color magenta
            echo "🚀 Branch needs pushing ($ahead commits ahead)"
        end
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
        if not string match -qr '^\d+$' -- "$choice" || test $choice -ge $index
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


function ginit
    # Check if we're in a directory with .git
    if test -d .git
        # Remove existing hooks
        rm -rf .git/hooks
        set_color yellow
        echo "🧹 Removed existing git hooks"
        set_color normal
    end
    
    # Run git init
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

function gip
    set_color -o blue
    echo "🚀 Git Push"
    set_color normal

    # Get branch and remote info in one command
    set -l remote_info (git remote 2>/dev/null)
    if test -z "$remote_info"
        set_color red
        echo "❌ No remote repository configured"
        set_color normal
        return 1
    end

    # Push with progress but optimized output
    git push --progress 2>&1 | while read -l line
        switch "$line"
            case "*fatal:*" "*error:*"
                set_color red
                echo "❌ $line"
            case "*Everything up-to-date*"
                set_color green
                echo "✨ Already in sync"
            case "*Enumerating objects*"
                set_color yellow
                echo "📦 Preparing changes..."
            case "*Counting objects*" "*Compressing objects*"
                # Skip intermediate progress messages
                true
            case "*Writing objects*"
                set_color cyan
                echo "📤 Uploading changes..."
            case "*remote: *" "*To *"
                # Only show final confirmation
                if string match -q "*-> *" "$line"
                    set_color green
                    echo "✅ Push complete"
                end
            case "*"
                # Skip other progress messages
                true
        end
    end
    set -l push_status $status

    if test $push_status -ne 0
        set_color red
        echo "❌ Push failed"
        set_color normal
        return 1
    end
    
    set_color normal
end
