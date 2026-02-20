# Completions for gip (git push wrapper)

# Complete with git push options
complete -c gip -l force -s f -d "Force push"
complete -c gip -l force-with-lease -d "Force push with lease"
complete -c gip -l set-upstream -s u -d "Set upstream branch"
complete -c gip -l tags -d "Push tags"
complete -c gip -l all -d "Push all branches"
complete -c gip -l dry-run -d "Do a dry run"
complete -c gip -l delete -d "Delete remote branch"

# Complete with remote names
function __fish_gip_remotes
    git remote 2>/dev/null
end

complete -c gip -f -n "not __fish_seen_subcommand_from (__fish_gip_remotes)" -a "(__fish_gip_remotes)" -d "Remote"

# Complete with branch names after remote
function __fish_gip_branches
    git branch --format='%(refname:short)' 2>/dev/null
end

complete -c gip -f -n "__fish_seen_subcommand_from (__fish_gip_remotes)" -a "(__fish_gip_branches)" -d "Branch"
