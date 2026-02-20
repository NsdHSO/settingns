# Fish Abbreviations - Quick Start Guide

## What Are Abbreviations?

Abbreviations are smart shortcuts that expand when you type them. Unlike aliases, they show you the full command before running, so you can edit it if needed.

## Try It Now

1. Type: `gst` then press SPACE
   - It expands to: `git status`

2. Type: `dcu` then press SPACE
   - It expands to: `docker-compose up`

3. Type: `kgp` then press SPACE
   - It expands to: `kubectl get pods`

## Most Useful Abbreviations

### Git (Top 10)
```
gst   → git status
gco   → git checkout
gpl   → git pull
gps   → git push
gad   → git add
gcm   → git commit -m
glg   → git log --oneline --graph
gdf   → git diff
gbr   → git branch
gsh   → git stash
```

### Docker (Top 5)
```
dcu   → docker-compose up
dcd   → docker-compose down
dps   → docker ps
dex   → docker exec -it
dlg   → docker logs -f
```

### Navigation (Super Handy!)
```
..    → cd ..
...   → cd ../..
....  → cd ../../..
```

### Package Managers
```
ni    → npm install
nr    → npm run
nt    → npm test
```

## Add Your Own

```fish
# Syntax: abbr_add <name> <expansion>

abbr_add gpp "git pull && git push"
abbr_add deploy "npm run build && npm run deploy"
abbr_add work "cd ~/Work && code ."
```

## Discover More

```fish
abbr_list              # See all abbreviations
abbr_list git          # Filter by category
abbr_search checkout   # Search for specific ones
abbr_cheatsheet        # Quick reference card
abbr_help              # Full documentation
```

## Context-Aware Magic

The system detects your environment and adds smart shortcuts:

**In Git repos:**
- `b` → `git branch`
- `s` → `git status`

**In Node.js projects:**
- `t` → `npm test`
- `d` → `npm run dev`

**In Rust projects:**
- `r` → `cargo run`
- `t` → `cargo test`

## Tips

1. Press SPACE to expand abbreviations
2. You can edit the expanded command before running
3. Use `abbr_add` to create custom abbreviations
4. Run `abbr_tips` for random helpful tips
5. Type `abbr_cheatsheet` for a quick reference

## Need Help?

```fish
abbr_help       # Full documentation
abbr_stats      # See your abbreviation statistics
abbr_tips       # Get a random tip
```

Happy abbreviating! 🚀
