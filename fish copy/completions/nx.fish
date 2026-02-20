# Enhanced completions for nx (in addition to nxg)

# Complete nx generate shortcuts
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "component" -d "Generate component"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "service" -d "Generate service"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "module" -d "Generate module"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "directive" -d "Generate directive"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "pipe" -d "Generate pipe"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "guard" -d "Generate guard"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "interceptor" -d "Generate interceptor"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "interface" -d "Generate interface"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "class" -d "Generate class"
complete -c nx -n "__fish_seen_subcommand_from g generate" -a "enum" -d "Generate enum"

# Complete nx subcommands
complete -c nx -f -n "__fish_is_first_arg" -a "g generate" -d "Generate code"
complete -c nx -f -n "__fish_is_first_arg" -a "build" -d "Build project"
complete -c nx -f -n "__fish_is_first_arg" -a "serve" -d "Serve project"
complete -c nx -f -n "__fish_is_first_arg" -a "test" -d "Run tests"
complete -c nx -f -n "__fish_is_first_arg" -a "lint" -d "Lint project"
complete -c nx -f -n "__fish_is_first_arg" -a "run" -d "Run target"
complete -c nx -f -n "__fish_is_first_arg" -a "affected" -d "Run for affected projects"

function __fish_is_first_arg
    set -l tokens (commandline -opc)
    test (count $tokens) -eq 1
end
