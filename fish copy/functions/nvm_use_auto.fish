# Automatically detect and use Node version from .nvmrc
# This manually triggers the version detection that would normally happen on cd

function nvm_use_auto --description "Auto-detect and use Node version from .nvmrc in current directory"
    # Ensure NVM is loaded
    if not set -q __nvm_loaded
        __nvm_lazy_load
    end

    # Look for .nvmrc file in current directory or parents
    set -l nvmrc_path (fish -c '_nvm_find_up $PWD .nvmrc' 2>/dev/null)

    if test -n "$nvmrc_path"
        set -l required_version (cat $nvmrc_path)

        echo "Found .nvmrc: $nvmrc_path"
        echo "Required version: $required_version"

        nvm use $required_version

        if test $status -eq 0
            # Update cache
            echo $required_version > "$HOME/.cache/nvm_current_version"
        end
    else
        set_color yellow
        echo "No .nvmrc file found in current directory or parents"
        set_color normal
        return 1
    end
end
