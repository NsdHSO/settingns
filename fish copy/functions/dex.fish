function dex --description 'Quick docker exec into container'
    if not command -v docker &>/dev/null
        echo "Error: docker is not installed"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: dex <container-name-or-id> [command]"
        echo "Default command: /bin/bash"
        return 1
    end

    set container $argv[1]
    set cmd /bin/bash

    if test (count $argv) -gt 1
        set cmd $argv[2..-1]
    end

    docker exec -it $container $cmd
end
