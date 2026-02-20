function dclogs --description 'Docker compose logs with follow'
    if not command -v docker-compose &>/dev/null
        echo "Error: docker-compose is not installed"
        return 1
    end

    if test (count $argv) -eq 0
        docker-compose logs -f
    else
        docker-compose logs -f $argv
    end
end
