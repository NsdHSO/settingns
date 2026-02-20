# Completions for gc (git commit with conventional commits)

# Complete commit types for first argument
complete -c gc -n "__fish_gc_is_first_token" -a "f feat" -d "New feature"
complete -c gc -n "__fish_gc_is_first_token" -a "fi fix" -d "Bug fix"
complete -c gc -n "__fish_gc_is_first_token" -a "d docs" -d "Documentation"
complete -c gc -n "__fish_gc_is_first_token" -a "s style" -d "Code style"
complete -c gc -n "__fish_gc_is_first_token" -a "t test" -d "Tests"
complete -c gc -n "__fish_gc_is_first_token" -a "c chore" -d "Chore"
complete -c gc -n "__fish_gc_is_first_token" -a "p perf" -d "Performance"
complete -c gc -n "__fish_gc_is_first_token" -a "r ref refactor" -d "Refactor"
complete -c gc -n "__fish_gc_is_first_token" -a "revert" -d "Revert"

# Helper function to check if we're at the first token
function __fish_gc_is_first_token
    set -l tokens (commandline -opc)
    test (count $tokens) -eq 1
end
