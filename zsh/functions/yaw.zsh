yaw() {
    local lockfiles=(pnpm-lock.yaml yarn.lock package-lock.json)
    local managers=(pnpm yarn npm)
    local found=0
    local manager=""
    for i in {1..${#lockfiles[@]}}; do
        if [[ -f "${lockfiles[$i]}" ]]; then
            manager="${managers[$i]}"
            found=1
            break
        fi
    done
    if [[ $found -eq 0 ]]; then
        echo "❌  No lockfile found. Cannot determine package manager."
        return 1
    fi
    echo "🧩  Detected package manager: $manager"
    case "$manager" in
        yarn)
            echo "🚀  Running: yarn test:w"
            yarn test:w
            ;;
        npm)
            echo "🚀  Running: npm run-script test:w"
            npm run-script test:w
            ;;
        pnpm)
            echo "🚀  Running: pnpm run test:w"
            pnpm run test:w
            ;;
        *)
            echo "⚠️  Unsupported package manager: $manager"
            return 1
            ;;
    esac
}
