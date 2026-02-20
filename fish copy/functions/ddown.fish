function ddown --description 'Docker compose down'
    if not command -v docker-compose &>/dev/null
        echo "Error: docker-compose is not installed"
        return 1
    end

    docker-compose down $argv
end
