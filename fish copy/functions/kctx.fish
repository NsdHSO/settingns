function kctx --description 'Switch Kubernetes context'
    if not command -v kubectl &>/dev/null
        echo "Error: kubectl is not installed"
        return 1
    end

    if test (count $argv) -eq 0
        # List available contexts
        kubectl config get-contexts
    else
        # Switch to specified context
        kubectl config use-context $argv[1]
    end
end
