# Display current language versions
# Shows Node, Java, and other language version managers

function versions --description "Show current language versions (Node, Java, etc.)"
    set_color --bold cyan
    echo "Current Language Versions:"
    set_color normal
    echo ""

    # Node.js / NVM
    if set -q nvm_current_version
        set_color green
        echo -n "  Node: "
        set_color normal
        echo -n "$nvm_current_version"

        if command -sq node
            set -l node_path (command -s node)
            echo " ($node_path)"
        else
            echo ""
        end

        if command -sq npm
            set -l npm_version (npm --version 2>/dev/null)
            set_color green
            echo -n "  npm:  "
            set_color normal
            echo $npm_version
        end
    else if test -f "$HOME/.cache/nvm_current_version"
        set -l cached (cat "$HOME/.cache/nvm_current_version")
        set_color yellow
        echo -n "  Node: "
        set_color normal
        echo "$cached (cached, not loaded yet)"
    else
        set_color yellow
        echo "  Node: system or not loaded"
        set_color normal
    end

    echo ""

    # Java / SDKMAN
    if set -q JAVA_HOME
        set_color green
        echo -n "  Java: "
        set_color normal

        if test -f "$JAVA_HOME/release"
            set -l java_version (grep 'JAVA_VERSION=' "$JAVA_HOME/release" | cut -d'"' -f2)
            echo "$java_version ($JAVA_HOME)"
        else if command -sq java
            set -l java_version (java -version 2>&1 | head -n1 | awk -F'"' '{print $2}')
            echo "$java_version ($JAVA_HOME)"
        else
            echo "Unknown ($JAVA_HOME)"
        end
    else
        set_color yellow
        echo "  Java: not set"
        set_color normal
    end

    # Maven
    if command -sq mvn
        set -l maven_version (mvn --version 2>/dev/null | head -n1 | awk '{print $3}')
        set_color green
        echo -n "  Maven: "
        set_color normal
        echo $maven_version
    end

    # Gradle
    if command -sq gradle
        set -l gradle_version (gradle --version 2>/dev/null | grep '^Gradle' | awk '{print $2}')
        set_color green
        echo -n "  Gradle: "
        set_color normal
        echo $gradle_version
    end

    echo ""

    # Rust (if installed)
    if command -sq rustc
        set -l rust_version (rustc --version | awk '{print $2}')
        set_color green
        echo -n "  Rust: "
        set_color normal
        echo $rust_version
    end

    # Python (if installed)
    if command -sq python3
        set -l python_version (python3 --version | awk '{print $2}')
        set_color green
        echo -n "  Python: "
        set_color normal
        echo $python_version
    end

    # Go (if installed)
    if command -sq go
        set -l go_version (go version | awk '{print $3}' | sed 's/go//')
        set_color green
        echo -n "  Go: "
        set_color normal
        echo $go_version
    end

    set_color normal
end
