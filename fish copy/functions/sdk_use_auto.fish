# Automatically detect and use Java/Maven versions from .sdkmanrc
# This manually triggers the version detection that would normally happen on cd

function sdk_use_auto --description "Auto-detect and use SDK versions from .sdkmanrc in current directory"
    # Look for .sdkmanrc file in current directory or parents
    set -l sdkmanrc_path (__sdk_find_up $PWD .sdkmanrc)

    if test -n "$sdkmanrc_path"
        echo "Found .sdkmanrc: $sdkmanrc_path"
        echo ""

        set -l switched 0

        while read -l line
            # Skip empty lines and comments
            if test -z "$line"; or string match -q '#*' -- $line
                continue
            end

            if string match -q -r '^java=' -- $line
                set -l version (string split '=' -- $line)[2]
                echo "Switching to Java $version..."
                sdk use java $version
                set switched 1
            else if string match -q -r '^maven=' -- $line
                set -l version (string split '=' -- $line)[2]
                echo "Switching to Maven $version..."
                sdk use maven $version
                set switched 1
            else if string match -q -r '^gradle=' -- $line
                set -l version (string split '=' -- $line)[2]
                echo "Switching to Gradle $version..."
                sdk use gradle $version
                set switched 1
            end
        end < $sdkmanrc_path

        if test $switched -eq 1
            # Update paths and cache
            __sdk_init_paths
            __sdk_cache_versions
            echo ""
            set_color green
            echo "SDK versions switched successfully"
            set_color normal
        else
            set_color yellow
            echo "No recognized SDK configurations in .sdkmanrc"
            set_color normal
        end
    else
        set_color yellow
        echo "No .sdkmanrc file found in current directory or parents"
        set_color normal
        return 1
    end
end
