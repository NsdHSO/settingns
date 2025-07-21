function ws --description 'Open WebStorm for the current directory or specified path'
    if set -q argv[1]
        open -a "WebStorm" $argv[1]
    else
        open -a "WebStorm" .
    end
end
