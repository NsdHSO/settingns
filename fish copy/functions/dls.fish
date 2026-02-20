function dls --description 'List Docker containers with formatting'
    if not command -v docker &>/dev/null
        echo "Error: docker is not installed"
        return 1
    end

    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
end
