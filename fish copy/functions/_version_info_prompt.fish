# Optional prompt component to show language versions
# Add this to your fish_prompt or fish_right_prompt if desired

function _version_info_prompt --description "Show current language versions in prompt (optional)"
    set -l version_info ""

    # Node version (only if loaded)
    if set -q nvm_current_version
        set version_info "$version_info"
        set_color blue
        echo -n " node:"
        set_color normal
        echo -n $nvm_current_version
    end

    # Java version (show if JAVA_HOME is set)
    if set -q JAVA_HOME; and test -f "$HOME/.cache/sdk_versions"
        set -l java_ver (__sdk_get_cached_version JAVA)
        if test -n "$java_ver"
            set_color yellow
            echo -n " java:"
            set_color normal
            # Show only major version for brevity
            echo -n (string split '.' $java_ver)[1]
        end
    end

    set_color normal
end
