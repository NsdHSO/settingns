alias lsop="lsof -i"
alias yai="ylock"
alias yall="yall"
alias yas="yarn start"
alias gid="git diff | git-split-diffs --color | less -+RFX"
alias gdd="git add"
alias gis="git status"
alias gip="git push"
alias gic="git cz"
alias gio="git"
alias gim="git commit -m"
alias kila="kill -9"
alias vim=nvim
alias la='ls -la'
alias pqp="python3"
alias python="python3"
alias idea="/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea"
alias web="/Applications/WebStorm.app/Contents/MacOS/webstorm"
alias pn="pnpm"
alias gtf="git"
alias gtt="git"
alias ghc="git"
alias gty="git"
alias gtd="git"
alias lsop="lsof"
alias kila="kill -9"
alias pnd="pnpm"
alias nxg="nxg"
alias workd1='cd /Volumes/Work; echo "🚀 Moved to /Volumes/Work"'
alias work='cd /Volumes/Best; echo "🚀 Moved to /Volumes/Best"'

function nxg
    switch $argv[1]
        case interface
            nx g interface $argv[2]
        case service
        case s
            nx g @nx/angular:$argv[1] --name=$argv[2]
        case "component"
        case "c"
            mkdir $argv[2]
            echo "Directory ✋🏿🧑🏿‍🦲🤚🏿🔫👮🏻: $argv[2] was cr eated"
            cd $argv[2]
            echo "Change Directory 🚥: $argv[2]"
            nx g @nx/angular:$argv[1] --name=$argv[2] --standalone=true --nameAndDirectoryFormat=as-provided;
            echo "Component ▄︻デ۪۞━一💥 : $argv[2] was created"
        case '*'
            nx g @nx/angular:$argv[1] --name=$argv[2] --standalone=true
    end
end


function gtf
    git commit -m  "feat:🎸 $argv"
end
function gtt
    git commit -m "test:🐳 $argv"
end
function ghc
    git commit -m "chore:🌻 $argv"
end

function gff
    git commit -m "fix:🛠  $argv"
end

function gty
    git commit -m "style 🎯 : $argv"
end

function gtd
    git commit -m "docs 📝 : $argv"
end

function grF
    git commit -m "R 👷 : $argv"
end
function grf
    git commit -m "r 🦺 : $argv"
end
function ...
    ..; ..
end

function ....
    ... ; ..
end

function .....
    cd ..;cd ..; cd ..; cd ..
end

function pnd
    git pnpm -D $argv
end

function ylock
    echo "🔍 Checking for lockfiles in the current directory..."
    
    if test -f pnpm-lock.yaml
        echo "🧹 Removing pnpm-lock.yaml..."
        rm -f pnpm-lock.yaml
        echo "📦 Installing with pnpm..."
        pnpm install

    else if test -f yarn.lock
        echo "🧹 Removing yarn.lock..."
        rm -f yarn.lock
        echo "🧶 Installing with yarn..."
        yarn install

    else if test -f package-lock.json
        echo "🧹 Removing package-lock.json..."
        rm -f package-lock.json
        echo "📘 Installing with npm..."
        npm install

    else
        echo "❌ No lockfile found. Please make sure you're in the correct project directory."
        return 1
    end

    echo "✅ Lockfile reset and dependencies installed. Ready to go! 🚀"
end


function yall
    echo "🔥 Removing node_modules... Stand back!"
    rm -rf node_modules

    echo "🔍 Checking and resetting lockfiles with ylock..."
    ylock

    echo "🎉 All done! Fresh start activated. 💫"
end


function gio
    echo "🛰️👽 ---->>>>----M<<<<<---- 👽🛰️"
    echo "🔍📡 Scanning the galaxy (fetching)..."
    git fetch
    echo "🧲🌀 Engaging tractor beam (pulling)..."
    git pull
    echo "🌈🛸 Sync complete. Universe updated! 🌍✅"
    echo "💥 BOOM 💥 ---->>>>----M<<<<<---- 💥"
end
