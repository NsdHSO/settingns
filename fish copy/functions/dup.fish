function dup --description 'Docker compose up with detached mode'
    if not command -v docker-compose &>/dev/null
        echo "Error: docker-compose is not installed"
        return 1
    end

    docker-compose up -d $argv
end
