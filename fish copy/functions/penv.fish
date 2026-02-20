# penv - Project Environment Manager utility function
# Provides a unified interface to all project environment functions

function penv
    set -l cmd $argv[1]

    switch "$cmd"
        case save
            save_project_env
        case reload
            reload_project_env
        case show
            show_project_env
        case trust
            __trust_dir (pwd)
        case untrust
            untrust_project_env
        case list
            list_trusted_envrc
        case help -h --help
            __penv_help
        case ''
            show_project_env
        case '*'
            set_color red
            echo "Unknown command: $cmd"
            set_color normal
            __penv_help
            return 1
    end
end

function __penv_help
    set_color cyan
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Project Environment Manager (penv)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set_color normal

    echo ""
    echo "Usage: penv [command]"
    echo ""
    echo "Commands:"
    echo "  save          Save current variables to .project-env"
    echo "  reload        Force reload project environment"
    echo "  show          Show currently loaded environment"
    echo "  trust         Trust current directory for auto-loading"
    echo "  untrust       Remove current directory from trusted list"
    echo "  list          List all trusted directories"
    echo "  help          Show this help message"
    echo ""
    echo "Auto-Loading:"
    echo "  The system automatically loads environment files when you"
    echo "  change directories. Supported files (in priority order):"
    echo "    1. .envrc"
    echo "    2. .env"
    echo "    3. .project-env"
    echo ""
    echo "Security:"
    echo "  - First time in a directory: prompts for permission"
    echo "  - Choose 'y' to load once, 'always' to auto-load"
    echo "  - Use 'penv trust' to trust current directory"
    echo ""
    echo "Auto-Activation:"
    echo "  - Python venv: Auto-activates venv/.venv/env directories"
    echo "  - Node version: Auto-switches based on .nvmrc file"
    echo ""
    echo "Examples:"
    echo "  penv save              # Save variables to .project-env"
    echo "  penv show              # Show current environment"
    echo "  penv trust             # Trust this directory"
    echo ""
end
