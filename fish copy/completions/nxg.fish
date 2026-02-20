# Completions for nxg (NX Generator wrapper)

# Complete component types for first argument
complete -c nxg -n "__fish_is_first_token" -a "interface" -d "Generate interface"
complete -c nxg -n "__fish_is_first_token" -a "service" -d "Generate service"
complete -c nxg -n "__fish_is_first_token" -a "s" -d "Generate service (short)"
complete -c nxg -n "__fish_is_first_token" -a "component" -d "Generate component"
complete -c nxg -n "__fish_is_first_token" -a "c" -d "Generate component (short)"
complete -c nxg -n "__fish_is_first_token" -a "module" -d "Generate module"
complete -c nxg -n "__fish_is_first_token" -a "directive" -d "Generate directive"
complete -c nxg -n "__fish_is_first_token" -a "pipe" -d "Generate pipe"
complete -c nxg -n "__fish_is_first_token" -a "guard" -d "Generate guard"
complete -c nxg -n "__fish_is_first_token" -a "interceptor" -d "Generate interceptor"
complete -c nxg -n "__fish_is_first_token" -a "class" -d "Generate class"
complete -c nxg -n "__fish_is_first_token" -a "enum" -d "Generate enum"

# Helper function to check if we're at the first token
function __fish_is_first_token
    set -l tokens (commandline -opc)
    test (count $tokens) -eq 1
end
