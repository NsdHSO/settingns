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
