function nxg() {
    if [[ $# -lt 2 ]]; then
        echo "\033[31mUsage: nxg <type> <name>\033[0m"
        return 1
    fi
    local type=$1
    local name=$2
    case $type in
        interface)
            nx g interface $name
            ;;
        service|s)
            nx g @nx/angular:service --name=$name
            ;;
        component|c)
            mkdir -p $name && cd $name
            echo "\033[36mDirectory ✋🏿🧑🏿‍🦲🤚🏿🔫👮🏻: $name | 🚥 Changed into directory\033[0m"
            nx g @nx/angular:component --name=$name --standalone=true --nameAndDirectoryFormat=as-provided
            echo "\033[32mComponent ▄︻デ۪۞━一💥 : $name created\033[0m"
            ;;
        *)
            nx g @nx/angular:$type --name=$name --standalone=true
            ;;
    esac
}
