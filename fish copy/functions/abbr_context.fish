#!/usr/bin/env fish
# ==============================================================================
# Context-Aware Abbreviation Setup
# ==============================================================================
# Sets up context-aware abbreviations that change based on environment
# Usage: Automatically loaded
# ==============================================================================

function abbr_context --description "Setup context-aware abbreviations"
    # Check if in a git repository
    if git rev-parse --git-dir >/dev/null 2>&1
        # In git repo - add git-specific context abbreviations
        if not abbr --show | grep -q "abbr -a -- b git branch"
            abbr -a b "git branch"
            abbr -a s "git status"
            abbr -a l "git log --oneline"
            abbr -a co "git checkout"
        end
    else
        # Not in git repo - remove git context abbreviations if they exist
        if abbr --show | grep -q "abbr -a -- b git branch"
            abbr -e b 2>/dev/null
            abbr -e s 2>/dev/null
            abbr -e l 2>/dev/null
            abbr -e co 2>/dev/null
        end
    end

    # Check if in a node project
    if test -f package.json
        # In node project - add npm/yarn context abbreviations
        if not abbr --show | grep -q "abbr -a -- t npm test"
            abbr -a t "npm test"
            abbr -a d "npm run dev"
            abbr -a bs "npm run build && npm start"
        end
    else
        # Not in node project - remove node context abbreviations
        if abbr --show | grep -q "abbr -a -- t npm test"
            abbr -e t 2>/dev/null
            abbr -e d 2>/dev/null
            abbr -e bs 2>/dev/null
        end
    end

    # Check if in a Cargo project
    if test -f Cargo.toml
        # In Rust project - add cargo context abbreviations
        if not abbr --show | grep -q "abbr -a -- r cargo run"
            abbr -a r "cargo run"
            abbr -a t "cargo test"
            abbr -a b "cargo build"
        end
    end

    # Check if in a Python project
    if test -f requirements.txt -o -f setup.py -o -f pyproject.toml
        # In Python project - add Python context abbreviations
        if not abbr --show | grep -q "abbr -a -- t pytest"
            abbr -a t "pytest"
            abbr -a r "python3 -m"
        end
    end
end

# Hook into directory change
function __abbr_context_on_pwd --on-variable PWD
    abbr_context
end

# Initialize on shell startup
abbr_context
