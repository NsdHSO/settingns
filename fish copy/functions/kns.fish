function kns --description 'Switch Kubernetes namespace'
    if not command -v kubectl &>/dev/null
        echo "Error: kubectl is not installed"
        return 1
    end

    if test (count $argv) -eq 0
        # List available namespaces
        kubectl get namespaces
    else
        # Switch to specified namespace
        kubectl config set-context --current --namespace=$argv[1]
        echo "Switched to namespace: $argv[1]"
    end
end
