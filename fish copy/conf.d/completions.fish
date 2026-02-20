# Context-Aware Completions Configuration
# This file enables intelligent auto-completions for development tools

# Enable kubectl completions if kubectl is installed
if command -q kubectl
    kubectl completion fish | source
end

# Enable docker completions if docker is installed
if command -q docker
    # Docker CLI completions are built-in to Fish, but we can enhance them
    # Docker Compose completions
    if command -q docker-compose
        # Fish has built-in docker-compose completions
    end
end

# Enable GitHub CLI completions if gh is installed
if command -q gh
    gh completion -s fish | source
end

# Enable pnpm completions if installed
if command -q pnpm
    pnpm completion fish | source 2>/dev/null
end

# Enable npm completions (if needed)
if command -q npm
    # Fish has built-in npm completions
end

# Enable yarn completions (if needed)
if command -q yarn
    # Fish has built-in yarn completions
end

# Optimize completion performance
# Set a reasonable timeout for completion generation
set -g fish_complete_timeout 200

# Enable fuzzy completion matching
set -g fish_complete_fuzzy_match 1
