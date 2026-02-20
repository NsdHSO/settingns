# Lazy-loaded NVM setup for Fish shell
# This replaces the default nvm.fish auto-activation to improve startup time

# Disable auto-activation from jorgebucaran/nvm.fish
# We'll handle it ourselves with lazy-loading
set -g nvm_lazy_load_enabled 1

# Cache file for current Node version
set -g nvm_version_cache "$HOME/.cache/nvm_current_version"

# Create cache directory if it doesn't exist
if not test -d (dirname $nvm_version_cache)
    mkdir -p (dirname $nvm_version_cache)
end

# Function to load NVM and activate the appropriate version
function __nvm_lazy_load
    # Only load once per session
    if set -q __nvm_loaded
        return 0
    end
    set -g __nvm_loaded 1

    # Check for .nvmrc in current directory or parents
    set -l nvmrc_path (fish -c '_nvm_find_up $PWD .nvmrc' 2>/dev/null)

    if test -n "$nvmrc_path"
        # Found .nvmrc, use that version
        set -l version (cat $nvmrc_path)
        nvm use --silent $version 2>/dev/null
    else if test -f $nvm_version_cache
        # Use cached version
        set -l cached_version (cat $nvm_version_cache)
        if test -n "$cached_version" -a "$cached_version" != "system"
            nvm use --silent $cached_version 2>/dev/null
        end
    else if set -q nvm_default_version
        # Fall back to default version
        nvm use --silent $nvm_default_version 2>/dev/null
    end

    # Cache the current version
    if set -q nvm_current_version
        echo $nvm_current_version > $nvm_version_cache
    end
end

# Function to check and auto-switch Node version on directory change
function __nvm_auto_switch --on-variable PWD
    # Only auto-switch if NVM has been loaded
    if not set -q __nvm_loaded
        return 0
    end

    # Look for .nvmrc file
    set -l nvmrc_path (fish -c '_nvm_find_up $PWD .nvmrc' 2>/dev/null)

    if test -n "$nvmrc_path"
        set -l required_version (cat $nvmrc_path)

        # Only switch if different from current version
        if not set -q nvm_current_version; or test "$nvm_current_version" != "$required_version"
            nvm use --silent $required_version 2>/dev/null
            if test $status -eq 0
                echo "Switched to Node $required_version (from .nvmrc)"
            end
        end
    end
end

# Lazy-load wrapper for node
function node --wraps=node
    __nvm_lazy_load
    command node $argv
end

# Lazy-load wrapper for npm
function npm --wraps=npm
    __nvm_lazy_load
    command npm $argv
end

# Lazy-load wrapper for npx
function npx --wraps=npx
    __nvm_lazy_load
    command npx $argv
end

# Lazy-load wrapper for yarn (if used)
function yarn --wraps=yarn
    __nvm_lazy_load
    command yarn $argv
end

# Lazy-load wrapper for pnpm (if used)
function pnpm --wraps=pnpm
    __nvm_lazy_load
    command pnpm $argv
end

# Function to get current Node version efficiently (for prompt)
function __nvm_prompt_version
    if set -q nvm_current_version
        echo $nvm_current_version
    else if test -f $nvm_version_cache
        cat $nvm_version_cache
    else
        echo "system"
    end
end
