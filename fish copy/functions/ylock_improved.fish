# Improved ylock with Advanced Error Handling
function ylock_improved
    set -l lockfiles pnpm-lock.yaml yarn.lock package-lock.json
    set -l managers pnpm yarn npm

    # Check if we're in a Node.js project
    if not test -f package.json
        error_handler not_found "file" "package.json"
        set_color $phenomenon_git_info
        echo "→ This doesn't appear to be a Node.js project"
        set_color normal
        return 1
    end

    # Find and process lockfile
    for i in (seq 1 (count $lockfiles))
        if test -f $lockfiles[$i]
            set_color $phenomenon_symbols
            echo "→ Found $lockfiles[$i]"
            set_color normal

            # Check if manager is installed
            set -l manager_cmd (check_tool $managers[$i] npm)
            if test $status -ne 0
                return 1
            end

            set_color $phenomenon_symbols
            echo "→ Removing $lockfiles[$i]..."
            set_color normal

            if not rm -f $lockfiles[$i]
                error_handler permission_denied $lockfiles[$i]
                return 1
            end

            set_color $phenomenon_git_info
            echo "→ Installing with $managers[$i]..."
            set_color normal

            if command $managers[$i] install
                error_handler success_recovery "Installation complete with $managers[$i]"
                return 0
            else
                error_handler custom "Installation failed with $managers[$i]"
                return 1
            end
        end
    end

    # No lockfile found
    error_handler no_lockfile
    set_color $phenomenon_git_info
    echo "→ Available package managers:"
    for mgr in $managers
        if command -q $mgr
            echo "  • $mgr (installed)"
        else
            echo "  • $mgr (not installed)"
        end
    end
    set_color normal
    return 1
end
