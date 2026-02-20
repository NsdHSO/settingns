#!/usr/bin/env fish
# ==============================================================================
# Abbreviation Cheatsheet
# ==============================================================================
# Quick reference for most common abbreviations
# Usage: abbr_cheatsheet
# ==============================================================================

function abbr_cheatsheet --description "Display quick reference cheatsheet"
    set_color --bold cyan
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║              Abbreviations Quick Reference                     ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    # Git
    set_color --bold green
    echo "GIT:"
    set_color normal
    echo "  gst → git status      gco → git checkout    gpl → git pull"
    echo "  gps → git push        gad → git add         gcm → git commit -m"
    echo "  glg → git log graph   gbr → git branch      gdf → git diff"
    echo ""

    # Docker
    set_color --bold cyan
    echo "DOCKER:"
    set_color normal
    echo "  dcu → docker-compose up    dcd → docker-compose down"
    echo "  dps → docker ps            dex → docker exec -it"
    echo "  dlg → docker logs -f       dcl → docker-compose logs"
    echo ""

    # Kubernetes
    set_color --bold blue
    echo "KUBERNETES:"
    set_color normal
    echo "  kgp → kubectl get pods     kl → kubectl logs"
    echo "  kex → kubectl exec -it     kap → kubectl apply -f"
    echo "  kd → kubectl describe      kdel → kubectl delete"
    echo ""

    # Package Managers
    set_color --bold yellow
    echo "PACKAGE MANAGERS:"
    set_color normal
    echo "  ni/yi/pi → install         nr/yr/pr → run"
    echo "  nt/yt/pt → test            nb/yb/pb → build"
    echo ""

    # Navigation
    set_color --bold magenta
    echo "NAVIGATION:"
    set_color normal
    echo "  .. → cd ..    ... → cd ../..    .... → cd ../../.."
    echo ""

    # Management
    set_color --bold white
    echo "MANAGEMENT:"
    set_color normal
    echo "  abbr_list      - List all abbreviations"
    echo "  abbr_add       - Add custom abbreviation"
    echo "  abbr_search    - Search abbreviations"
    echo "  abbr_help      - Full help documentation"
    echo ""

    set_color yellow
    echo "💡 Press SPACE after typing an abbreviation to expand it!"
    set_color normal
end
