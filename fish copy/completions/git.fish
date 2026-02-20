# Enhanced git completions for custom workflow

# Add completions for common branches
function __fish_git_local_branches
    git branch --format='%(refname:short)' 2>/dev/null
end

function __fish_git_remote_branches
    git branch -r --format='%(refname:short)' 2>/dev/null | string replace 'origin/' ''
end

function __fish_git_all_branches
    __fish_git_local_branches
    __fish_git_remote_branches
end

# Complete branch names for checkout
complete -c git -n "__fish_seen_subcommand_from checkout co switch" -f -a "(__fish_git_all_branches)" -d "Branch"

# Complete branch names for merge
complete -c git -n "__fish_seen_subcommand_from merge" -f -a "(__fish_git_local_branches)" -d "Local branch"

# Complete branch names for delete
complete -c git -n "__fish_seen_subcommand_from branch" -n "__fish_contains_opt -d -D delete" -f -a "(__fish_git_local_branches)" -d "Branch to delete"

# Complete remote names
function __fish_git_remotes
    git remote 2>/dev/null
end

complete -c git -n "__fish_seen_subcommand_from push pull fetch" -f -a "(__fish_git_remotes)" -d "Remote"

# Complete modified files for add, restore, checkout
function __fish_git_modified_files
    git diff --name-only 2>/dev/null
end

function __fish_git_staged_files
    git diff --cached --name-only 2>/dev/null
end

complete -c git -n "__fish_seen_subcommand_from add" -f -a "(__fish_git_modified_files)" -d "Modified file"
complete -c git -n "__fish_seen_subcommand_from restore" -f -a "(__fish_git_modified_files)" -d "Modified file"
complete -c git -n "__fish_seen_subcommand_from reset" -n "__fish_contains_opt HEAD" -f -a "(__fish_git_staged_files)" -d "Staged file"
