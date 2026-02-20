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
