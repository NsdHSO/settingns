function nxg
    if test (count $argv) -lt 2
        set_color red
        echo "Usage: nxg <type> <name>"
        set_color normal
        return 1
    end
    set -l type $argv[1]
    set -l name $argv[2]
    mkdir -p $name && cd $name
    echo "Directory ✋🏿🧑🏿‍🦲🤚🏿🔫👮🏻: $name | 🚥 Changed into directory"
    switch $type
        case interface
            nx g interface $name
        case service s
            nx g @nx/angular:service --name=$name
        case component c
            set_color cyan
            set_color normal
            nx g @nx/angular:component --name=$name --standalone=true --nameAndDirectoryFormat=as-provided
            set_color green
            echo "Component ▄︻デ۪۞━一💥 : $name created"
            set_color normal
        case '*'
            nx g @nx/angular:$type --name=$name --standalone=true
    end
end
