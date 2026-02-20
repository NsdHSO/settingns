# Project Environment Manager
# Auto-loads project-specific environment variables when entering directories

# Security: Track trusted directories
set -g __pem_trusted_dirs_file "$HOME/.config/fish/trusted_envrc_dirs"
set -g __pem_cache_file "$HOME/.config/fish/env_cache"

# Cache: Store last checked directory and hash to avoid redundant checks
set -g __pem_last_dir ""
set -g __pem_last_hash ""

# Current loaded project env file
set -g __pem_loaded_env_file ""

# Initialize trusted directories file if it doesn't exist
if not test -f $__pem_trusted_dirs_file
    touch $__pem_trusted_dirs_file
end

# Function to check if a directory is trusted
function __is_dir_trusted
    set -l dir $argv[1]
    if grep -Fxq "$dir" $__pem_trusted_dirs_file 2>/dev/null
        return 0
    else
        return 1
    end
end

# Function to add directory to trusted list
function __trust_dir
    set -l dir $argv[1]
    if not __is_dir_trusted "$dir"
        echo "$dir" >> $__pem_trusted_dirs_file
        echo "✓ Directory trusted: $dir"
    end
end

# Function to calculate file hash for cache invalidation
function __file_hash
    set -l file $argv[1]
    if test -f "$file"
        # Use md5 on macOS, md5sum on Linux
        if command -q md5
            md5 -q "$file"
        else if command -q md5sum
            md5sum "$file" | cut -d' ' -f1
        else
            # Fallback: use file modification time
            stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null
        end
    end
end

# Function to unload previously loaded environment variables
function __unload_project_env
    if test -n "$__pem_loaded_env_file"
        # Read the loaded file and unset all exported variables
        # This is a simple implementation - stores loaded vars in a list
        if set -q __pem_loaded_vars
            for var in $__pem_loaded_vars
                set -e $var
            end
            set -e __pem_loaded_vars
        end
        set -g __pem_loaded_env_file ""
    end
end

# Function to load environment variables from a file
function __load_env_file
    set -l env_file $argv[1]
    set -l file_dir (dirname "$env_file")

    # Store list of variables we're setting for later cleanup
    set -g __pem_loaded_vars

    # Read file line by line
    while read -l line
        # Skip empty lines and comments
        if test -z "$line"; or string match -qr '^\s*#' "$line"
            continue
        end

        # Match export VAR=value or VAR=value patterns
        if string match -qr '^export\s+([A-Za-z_][A-Za-z0-9_]*)=(.*)$' "$line"
            set -l var (string replace -r '^export\s+([A-Za-z_][A-Za-z0-9_]*)=.*$' '$1' "$line")
            set -l val (string replace -r '^export\s+[A-Za-z_][A-Za-z0-9_]*=(.*)$' '$1' "$line")
        else if string match -qr '^([A-Za-z_][A-Za-z0-9_]*)=(.*)$' "$line"
            set -l var (string replace -r '^([A-Za-z_][A-Za-z0-9_]*)=.*$' '$1' "$line")
            set -l val (string replace -r '^[A-Za-z_][A-Za-z0-9_]*=(.*)$' '$1' "$line")
        else
            continue
        end

        # Remove surrounding quotes from value if present
        set val (string trim -c '\'"' "$val")

        # Expand variables in value (e.g., $HOME, ${VAR})
        set val (string replace -ra '\$\{([^}]+)\}' '$$1' "$val")
        set val (string replace -ra '\$([A-Za-z_][A-Za-z0-9_]*)' '$$1' "$val")

        # Evaluate the value to expand variables
        set val (eval echo "$val")

        # Set the variable globally
        set -gx $var "$val"

        # Track this variable for later cleanup
        set -a __pem_loaded_vars $var
    end < "$env_file"

    set -g __pem_loaded_env_file "$env_file"
end

# Function to find and load project environment files
function __load_project_env --on-variable PWD
    set -l current_dir (pwd)

    # Performance optimization: Check if we're in the same directory
    if test "$current_dir" = "$__pem_last_dir"
        return
    end

    # Look for environment files in priority order
    set -l env_files .envrc .env .project-env
    set -l found_file ""

    for env_file in $env_files
        set -l full_path "$current_dir/$env_file"
        if test -f "$full_path"
            set found_file "$full_path"
            break
        end
    end

    # Calculate hash of found file for cache check
    set -l current_hash ""
    if test -n "$found_file"
        set current_hash (__file_hash "$found_file")
    end

    # If we found the same file with same hash, skip reload
    if test "$found_file" = "$__pem_loaded_env_file" -a "$current_hash" = "$__pem_last_hash"
        set -g __pem_last_dir "$current_dir"
        return
    end

    # Unload previous environment if we're leaving a project or switching projects
    if test -n "$__pem_loaded_env_file" -a "$found_file" != "$__pem_loaded_env_file"
        __unload_project_env
    end

    # If we found an environment file
    if test -n "$found_file"
        # Security check: Is this directory trusted?
        if not __is_dir_trusted "$current_dir"
            # Ask user for permission
            set_color yellow
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "⚠️  Project environment file detected: $found_file"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            set_color normal

            # Show file contents
            echo "Contents:"
            set_color cyan
            cat "$found_file"
            set_color normal
            echo ""

            # Prompt user
            set_color yellow
            read -l -P "Load this environment? (y/n/always): " response
            set_color normal

            switch $response
                case y Y yes YES
                    __load_env_file "$found_file"
                    set -g __pem_last_hash "$current_hash"
                    echo "✓ Environment loaded for this session"
                case a A always ALWAYS
                    __trust_dir "$current_dir"
                    __load_env_file "$found_file"
                    set -g __pem_last_hash "$current_hash"
                    echo "✓ Environment loaded and directory trusted"
                case '*'
                    echo "✗ Environment not loaded"
            end
        else
            # Directory is trusted, load automatically
            __load_env_file "$found_file"
            set -g __pem_last_hash "$current_hash"
            set_color green
            echo "✓ Project environment loaded from: "(basename "$found_file")
            set_color normal
        end
    else
        # No environment file found, unload if we had one loaded
        if test -n "$__pem_loaded_env_file"
            __unload_project_env
            set_color yellow
            echo "✓ Left project environment"
            set_color normal
        end
    end

    # Update cache
    set -g __pem_last_dir "$current_dir"

    # Auto-activate Python virtual environment if present
    __activate_python_venv

    # Auto-switch Node version if .nvmrc exists (don't break NVM)
    __activate_node_version
end

# Function to auto-activate Python virtual environment
function __activate_python_venv
    set -l current_dir (pwd)

    # Look for common venv directories
    set -l venv_dirs venv .venv env .env virtualenv

    for venv_dir in $venv_dirs
        set -l venv_path "$current_dir/$venv_dir"
        set -l activate_script "$venv_path/bin/activate.fish"

        if test -f "$activate_script"
            # Check if we're not already in this venv
            if not string match -q "*$venv_path*" "$VIRTUAL_ENV"
                source "$activate_script"
                set_color green
                echo "✓ Python venv activated: $venv_dir"
                set_color normal
            end
            return
        end
    end
end

# Function to auto-switch Node version using NVM
function __activate_node_version
    set -l current_dir (pwd)
    set -l nvmrc_file "$current_dir/.nvmrc"

    # Only if .nvmrc exists and nvm is available
    if test -f "$nvmrc_file"; and type -q nvm
        set -l required_version (cat "$nvmrc_file" | string trim)

        # Check if we're already on the correct version
        if type -q node
            set -l current_version (node --version 2>/dev/null | string replace 'v' '')
            if not string match -q "*$required_version*" "$current_version"
                set_color cyan
                echo "→ Switching to Node version: $required_version"
                set_color normal
                nvm use $required_version 2>/dev/null
            end
        else
            # Node not available, use nvm
            set_color cyan
            echo "→ Activating Node version: $required_version"
            set_color normal
            nvm use $required_version 2>/dev/null
        end
    end
end

# User-facing function to save current project environment
function save_project_env
    set -l env_file (pwd)/.project-env

    # Ask what variables to save
    set_color yellow
    echo "Current environment variables:"
    set_color cyan
    set -x | grep -v '^__' | head -20
    set_color normal

    read -l -P "Enter variable names to save (space-separated): " vars

    if test -z "$vars"
        echo "No variables specified"
        return 1
    end

    # Write to .project-env file
    echo "# Project environment variables" > "$env_file"
    echo "# Generated on "(date) >> "$env_file"
    echo "" >> "$env_file"

    for var in $vars
        if set -q $var
            set -l val $$var
            echo "export $var=\"$val\"" >> "$env_file"
        end
    end

    set_color green
    echo "✓ Project environment saved to: $env_file"
    set_color normal

    # Offer to trust this directory
    read -l -P "Trust this directory for auto-loading? (y/n): " response
    if test "$response" = "y" -o "$response" = "Y"
        __trust_dir (pwd)
    end
end

# User-facing function to untrust a directory
function untrust_project_env
    set -l dir (pwd)

    if __is_dir_trusted "$dir"
        # Remove from trusted list
        grep -Fxv "$dir" $__pem_trusted_dirs_file > "$__pem_trusted_dirs_file.tmp"
        mv "$__pem_trusted_dirs_file.tmp" $__pem_trusted_dirs_file
        set_color green
        echo "✓ Directory untrusted: $dir"
        set_color normal
    else
        set_color yellow
        echo "Directory is not trusted: $dir"
        set_color normal
    end
end

# User-facing function to list trusted directories
function list_trusted_envrc
    set_color cyan
    echo "Trusted directories for auto-loading environments:"
    set_color normal

    if test -f $__pem_trusted_dirs_file
        cat $__pem_trusted_dirs_file
    else
        echo "No trusted directories yet"
    end
end

# User-facing function to reload project environment
function reload_project_env
    set -g __pem_last_dir ""
    set -g __pem_last_hash ""
    __load_project_env
end

# User-facing function to show currently loaded environment
function show_project_env
    if test -n "$__pem_loaded_env_file"
        set_color cyan
        echo "Currently loaded environment: $__pem_loaded_env_file"
        set_color normal
        echo ""
        echo "Loaded variables:"
        if set -q __pem_loaded_vars
            for var in $__pem_loaded_vars
                if set -q $var
                    echo "  $var = "$$var
                end
            end
        end
    else
        set_color yellow
        echo "No project environment currently loaded"
        set_color normal
    end
end
