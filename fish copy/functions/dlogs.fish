function dlogs --description 'Stream Docker container logs'
    if not command -v docker &>/dev/null
        echo "Error: docker is not installed"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: dlogs <container-name-or-id> [options]"
        echo "Example: dlogs myapp -f --tail 100"
        return 1
    end

    set container $argv[1]
    set options $argv[2..-1]

    # If no options provided, use -f (follow) by default
    if test (count $options) -eq 0
        docker logs -f $container
    else
        docker logs $options $container
    end
end
