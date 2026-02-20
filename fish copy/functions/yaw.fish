function yaw
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json
    set -l managers pnpm yarn npm
    set -l found 0
    set -l manager ""
    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            set manager $managers[$i]
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
