#!/usr/bin/env fish
# ==============================================================================
# Abbreviation Tips
# ==============================================================================
# Show random helpful abbreviation tips
# Usage: abbr_tips
# ==============================================================================

function abbr_tips --description "Show helpful abbreviation tips"
    set -l tips \
        "💡 Type 'gst' instead of 'git status' - it expands automatically!" \
        "💡 Use 'gco -b feature' for 'git checkout -b feature'" \
        "💡 Docker made easy: 'dcu' expands to 'docker-compose up'" \
        "💡 Kubernetes shortcuts: 'kgp' = 'kubectl get pods'" \
        "💡 Navigate faster: '..' goes up one directory, '...' goes up two!" \
        "💡 Add your own: abbr_add myabbr 'my expansion'" \
        "💡 List all abbreviations: abbr_list" \
        "💡 Filter abbreviations: abbr_list git" \
        "💡 Remove abbreviation: abbr_rm myabbr" \
        "💡 'glg' shows a beautiful git log graph" \
        "💡 'gca' amends your last commit quickly" \
        "💡 'kex podname sh' = 'kubectl exec -it podname sh'" \
        "💡 Package managers: 'ni' (npm), 'yi' (yarn), 'pi' (pnpm)" \
        "💡 'v filename' opens files in neovim instantly" \
        "💡 'mkd path/to/dir' creates nested directories" \
        "💡 Context-aware 'b' in git repos = 'git branch'"

    # Pick a random tip
    set -l random_tip $tips[(random 1 (count $tips))]
    echo $random_tip
end
