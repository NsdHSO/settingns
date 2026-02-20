#!/usr/bin/env fish
# ==============================================================================
# Dynamic Abbreviation System
# ==============================================================================
# Smart command abbreviations that expand dynamically
# Created: 2026-02-19
# ==============================================================================

# ------------------------------------------------------------------------------
# Core Git Abbreviations
# ------------------------------------------------------------------------------
abbr -a g git
abbr -a gco "git checkout"
abbr -a gcb "git checkout -b"
abbr -a gpl "git pull"
abbr -a gps "git push"
abbr -a gst "git status"
abbr -a gdf "git diff"
abbr -a gad "git add"
abbr -a gcm "git commit -m"
abbr -a gca "git commit --amend"
abbr -a glg "git log --oneline --graph --decorate"
abbr -a gbr "git branch"
abbr -a gbd "git branch -d"
abbr -a gmg "git merge"
abbr -a grb "git rebase"
abbr -a gsh "git stash"
abbr -a gsp "git stash pop"
abbr -a gft "git fetch"
abbr -a gcl "git clone"
abbr -a grs "git reset"
abbr -a grh "git reset --hard"

# ------------------------------------------------------------------------------
# Docker Abbreviations
# ------------------------------------------------------------------------------
abbr -a d docker
abbr -a dc "docker-compose"
abbr -a dcu "docker-compose up"
abbr -a dcd "docker-compose down"
abbr -a dcl "docker-compose logs"
abbr -a dps "docker ps"
abbr -a dpsa "docker ps -a"
abbr -a di "docker images"
abbr -a drm "docker rm"
abbr -a drmi "docker rmi"
abbr -a dex "docker exec -it"
abbr -a dlg "docker logs -f"
abbr -a dbl "docker build"
abbr -a dpl "docker pull"
abbr -a dph "docker push"

# ------------------------------------------------------------------------------
# Kubernetes Abbreviations
# ------------------------------------------------------------------------------
abbr -a k kubectl
abbr -a kg "kubectl get"
abbr -a kgp "kubectl get pods"
abbr -a kgs "kubectl get services"
abbr -a kgd "kubectl get deployments"
abbr -a kd "kubectl describe"
abbr -a kdel "kubectl delete"
abbr -a kl "kubectl logs"
abbr -a klf "kubectl logs -f"
abbr -a kex "kubectl exec -it"
abbr -a kap "kubectl apply -f"
abbr -a kctx "kubectl config use-context"
abbr -a kns "kubectl config set-context --current --namespace"

# ------------------------------------------------------------------------------
# Package Managers
# ------------------------------------------------------------------------------
abbr -a n npm
abbr -a ni "npm install"
abbr -a nid "npm install --save-dev"
abbr -a nr "npm run"
abbr -a ns "npm start"
abbr -a nt "npm test"
abbr -a nb "npm run build"

abbr -a y yarn
abbr -a yi "yarn install"
abbr -a ya "yarn add"
abbr -a yad "yarn add --dev"
abbr -a yr "yarn run"
abbr -a ys "yarn start"
abbr -a yt "yarn test"
abbr -a yb "yarn build"

abbr -a p pnpm
abbr -a pi "pnpm install"
abbr -a pa "pnpm add"
abbr -a pad "pnpm add -D"
abbr -a pr "pnpm run"
abbr -a ps "pnpm start"
abbr -a pt "pnpm test"
abbr -a pb "pnpm build"

# ------------------------------------------------------------------------------
# System Abbreviations
# ------------------------------------------------------------------------------
abbr -a c clear
abbr -a h history
abbr -a x exit
abbr -a mkd "mkdir -p"
abbr -a rmd "rm -rf"
abbr -a cpr "cp -r"

# ------------------------------------------------------------------------------
# Editor Abbreviations
# ------------------------------------------------------------------------------
abbr -a v nvim
abbr -a vi nvim
abbr -a e "nvim"
abbr -a code "code ."

# ------------------------------------------------------------------------------
# Navigation Abbreviations
# ------------------------------------------------------------------------------
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a ..... "cd ../../../.."

# ------------------------------------------------------------------------------
# List Abbreviations
# ------------------------------------------------------------------------------
abbr -a l "ls -lh"
abbr -a ll "ls -lah"
abbr -a lt "ls -lth"
abbr -a ltr "ls -ltrh"

# ------------------------------------------------------------------------------
# Cargo/Rust Abbreviations
# ------------------------------------------------------------------------------
abbr -a cr "cargo run"
abbr -a cb "cargo build"
abbr -a ct "cargo test"
abbr -a cc "cargo check"
abbr -a cw "cargo watch"
abbr -a cf "cargo fmt"
abbr -a cl "cargo clippy"

# ------------------------------------------------------------------------------
# Python Abbreviations
# ------------------------------------------------------------------------------
abbr -a py python3
abbr -a pip pip3
abbr -a venv "python3 -m venv venv"
abbr -a vact "source venv/bin/activate.fish"

# ------------------------------------------------------------------------------
# Load custom abbreviations if file exists
# ------------------------------------------------------------------------------
if test -f ~/.config/fish/personalized/abbreviations.fish
    source ~/.config/fish/personalized/abbreviations.fish
end
