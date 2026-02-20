#!/usr/bin/env fish
# ==============================================================================
# Abbreviation Help
# ==============================================================================
# Show comprehensive help for the abbreviation system
# Usage: abbr_help
# ==============================================================================

function abbr_help --description "Show comprehensive help for abbreviations"
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║         Fish Shell Abbreviation System - Help               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    set_color --bold yellow
    echo "📚 WHAT ARE ABBREVIATIONS?"
    set_color normal
    echo "  Abbreviations expand when you press SPACE or ENTER, showing"
    echo "  the full command before execution. Unlike aliases, you can"
    echo "  edit the expanded command before running it."
    echo ""

    set_color --bold yellow
    echo "🛠️  MANAGEMENT COMMANDS:"
    set_color normal
    echo "  abbr_list           - List all abbreviations"
    echo "  abbr_list git       - Filter abbreviations (e.g., git-related)"
    echo "  abbr_search <term>  - Search abbreviations by name/expansion"
    echo "  abbr_add <n> <exp>  - Add custom abbreviation permanently"
    echo "  abbr_rm <name>      - Remove custom abbreviation"
    echo "  abbr_tips           - Show random helpful tip"
    echo "  abbr_help           - Show this help"
    echo ""

    set_color --bold yellow
    echo "🎯 CATEGORIES:"
    set_color normal
    echo ""

    set_color green
    echo "  Git (g*):"
    set_color normal
    echo "    g      → git              gco    → git checkout"
    echo "    gst    → git status       gpl    → git pull"
    echo "    gps    → git push         gad    → git add"
    echo "    gcm    → git commit -m    glg    → git log --oneline --graph"
    echo ""

    set_color cyan
    echo "  Docker (d*):"
    set_color normal
    echo "    d      → docker           dc     → docker-compose"
    echo "    dcu    → docker-compose up       dcd    → docker-compose down"
    echo "    dps    → docker ps        dex    → docker exec -it"
    echo ""

    set_color blue
    echo "  Kubernetes (k*):"
    set_color normal
    echo "    k      → kubectl          kgp    → kubectl get pods"
    echo "    kl     → kubectl logs     kex    → kubectl exec -it"
    echo "    kap    → kubectl apply -f"
    echo ""

    set_color yellow
    echo "  Package Managers:"
    set_color normal
    echo "    ni     → npm install      yi     → yarn install"
    echo "    pi     → pnpm install     nr/yr/pr → run commands"
    echo ""

    set_color magenta
    echo "  Navigation:"
    set_color normal
    echo "    ..     → cd ..            ...    → cd ../.."
    echo "    ....   → cd ../../..      .....  → cd ../../../.."
    echo ""

    set_color --bold yellow
    echo "🔄 CONTEXT-AWARE ABBREVIATIONS:"
    set_color normal
    echo "  In Git repos:   b → git branch, s → git status"
    echo "  In Node.js:     t → npm test, d → npm run dev"
    echo "  In Rust:        r → cargo run, t → cargo test"
    echo "  In Python:      t → pytest, r → python3 -m"
    echo ""

    set_color --bold yellow
    echo "💡 EXAMPLES:"
    set_color normal
    echo "  Add custom abbreviation:"
    echo "    abbr_add gpp 'git pull && git push'"
    echo ""
    echo "  Search for checkout-related abbreviations:"
    echo "    abbr_search checkout"
    echo ""
    echo "  Remove an abbreviation:"
    echo "    abbr_rm gpp"
    echo ""

    set_color --bold yellow
    echo "📂 FILES:"
    set_color normal
    echo "  Config:  ~/.config/fish/conf.d/04-abbreviations.fish"
    echo "  Custom:  ~/.config/fish/personalized/abbreviations.fish"
    echo ""

    set_color --bold green
    echo "✨ TIP: Type an abbreviation and press SPACE to see it expand!"
    set_color normal
end
