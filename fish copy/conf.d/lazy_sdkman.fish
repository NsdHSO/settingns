# Lazy-loaded SDKMAN setup for Fish shell
# Optimizes Java/Maven version management for faster startup

# Cache file for current Java/Maven versions
set -g sdk_version_cache "$HOME/.cache/sdk_versions"
set -g sdk_lazy_load_enabled 1

# Create cache directory if it doesn't exist
if not test -d (dirname $sdk_version_cache)
    mkdir -p (dirname $sdk_version_cache)
end

# Initialize SDKMAN paths without full initialization
# This sets up the basic environment without the overhead
function __sdk_init_paths
    if test -d "$HOME/.sdkman/candidates/java/current"
        set -gx JAVA_HOME "$HOME/.sdkman/candidates/java/current"
        set -gx PATH "$JAVA_HOME/bin" $PATH
    end

    if test -d "$HOME/.sdkman/candidates/maven/current"
        set -gx PATH "$HOME/.sdkman/candidates/maven/current/bin" $PATH
    end

    if test -d "$HOME/.sdkman/candidates/gradle/current"
        set -gx PATH "$HOME/.sdkman/candidates/gradle/current/bin" $PATH
    end
end

# Initialize paths on shell startup (fast)
__sdk_init_paths

# Function to cache current SDK versions
function __sdk_cache_versions
    if test -f "$JAVA_HOME/release"
        # Extract Java version from release file
        set -l java_version (grep 'JAVA_VERSION=' "$JAVA_HOME/release" | cut -d'"' -f2)
        echo "JAVA_VERSION=$java_version" > $sdk_version_cache
    end

    if command -sq mvn
        set -l maven_version (mvn --version 2>/dev/null | head -n1 | awk '{print $3}')
        echo "MAVEN_VERSION=$maven_version" >> $sdk_version_cache
    end
end

# Function to read cached versions (for prompt)
function __sdk_get_cached_version --argument-names tool
    if test -f $sdk_version_cache
        grep "^$tool"_VERSION= $sdk_version_cache 2>/dev/null | cut -d'=' -f2
    end
end

# Function to check and auto-switch based on .sdkmanrc
function __sdk_auto_switch --on-variable PWD
    # Look for .sdkmanrc file
    set -l sdkmanrc_path (__sdk_find_up $PWD .sdkmanrc)

    if test -n "$sdkmanrc_path"
        # Parse .sdkmanrc and switch versions
        while read -l line
            if string match -q -r '^java=' -- $line
                set -l version (string split '=' -- $line)[2]
                sdk use java $version
            else if string match -q -r '^maven=' -- $line
                set -l version (string split '=' -- $line)[2]
                sdk use maven $version
            end
        end < $sdkmanrc_path

        # Update cache after switching
        __sdk_cache_versions
    end
end

# Helper function to find .sdkmanrc in current or parent directories
function __sdk_find_up --argument-names path file
    if test -e "$path/$file"
        echo "$path/$file"
        return 0
    else if test "$path" = "/"
        return 1
    else
        set -l parent_path (dirname $path)
        __sdk_find_up $parent_path $file
    end
end

# Enhanced sdk function with version switching and caching
function sdk --wraps=sdk
    # Call the original sdk function (delegated to bash)
    bash -lc "source \"$HOME/.sdkman/bin/sdkman-init.sh\" && sdk $argv"

    # After any sdk command, update the cache
    if test $status -eq 0
        __sdk_init_paths
        __sdk_cache_versions
    end
end

# Function to get current Java version efficiently (for prompt)
function __sdk_prompt_java_version
    if set -q JAVA_HOME; and test -d "$JAVA_HOME"
        __sdk_get_cached_version JAVA
    else
        echo "none"
    end
end

# Function to get current Maven version efficiently (for prompt)
function __sdk_prompt_maven_version
    __sdk_get_cached_version MAVEN
end

# Initial cache creation (fast, runs in background)
if test -d "$HOME/.sdkman"
    # Cache versions in background (disabled for faster startup)
    # __sdk_cache_versions &
    # disown
end
