# Fish Shell Dynamic Abbreviation System

## Overview
The dynamic abbreviation system provides smart, context-aware command shortcuts that expand when you type them. Unlike aliases, abbreviations show you the full command before execution, allowing you to edit it if needed.

## Installation
The system is automatically loaded via `/Users/davidsamuel.nechifor/.config/fish/conf.d/04-abbreviations.fish`

## Core Abbreviations

### Git Commands
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `g` | `git` | Base git command |
| `gst` | `git status` | Show working tree status |
| `gco` | `git checkout` | Switch branches |
| `gcb` | `git checkout -b` | Create and switch to new branch |
| `gpl` | `git pull` | Fetch and merge changes |
| `gps` | `git push` | Push commits to remote |
| `gad` | `git add` | Stage changes |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend` | Amend last commit |
| `glg` | `git log --oneline --graph --decorate` | Pretty log graph |
| `gdf` | `git diff` | Show changes |
| `gbr` | `git branch` | List/manage branches |
| `gbd` | `git branch -d` | Delete branch |
| `gmg` | `git merge` | Merge branches |
| `grb` | `git rebase` | Rebase commits |
| `gsh` | `git stash` | Stash changes |
| `gsp` | `git stash pop` | Apply stashed changes |
| `gft` | `git fetch` | Download objects from remote |
| `gcl` | `git clone` | Clone repository |
| `grs` | `git reset` | Reset current HEAD |
| `grh` | `git reset --hard` | Hard reset |

### Docker Commands
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `d` | `docker` | Base docker command |
| `dc` | `docker-compose` | Docker compose |
| `dcu` | `docker-compose up` | Start services |
| `dcd` | `docker-compose down` | Stop services |
| `dcl` | `docker-compose logs` | View logs |
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `di` | `docker images` | List images |
| `drm` | `docker rm` | Remove container |
| `drmi` | `docker rmi` | Remove image |
| `dex` | `docker exec -it` | Execute command in container |
| `dlg` | `docker logs -f` | Follow container logs |
| `dbl` | `docker build` | Build image |
| `dpl` | `docker pull` | Pull image |
| `dph` | `docker push` | Push image |

### Kubernetes Commands
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `k` | `kubectl` | Base kubectl command |
| `kg` | `kubectl get` | Get resources |
| `kgp` | `kubectl get pods` | List pods |
| `kgs` | `kubectl get services` | List services |
| `kgd` | `kubectl get deployments` | List deployments |
| `kd` | `kubectl describe` | Describe resource |
| `kdel` | `kubectl delete` | Delete resource |
| `kl` | `kubectl logs` | View logs |
| `klf` | `kubectl logs -f` | Follow logs |
| `kex` | `kubectl exec -it` | Execute in pod |
| `kap` | `kubectl apply -f` | Apply configuration |
| `kctx` | `kubectl config use-context` | Switch context |
| `kns` | `kubectl config set-context --current --namespace` | Set namespace |

### Package Manager Commands

#### NPM
| Abbreviation | Expands To |
|--------------|------------|
| `n` | `npm` |
| `ni` | `npm install` |
| `nid` | `npm install --save-dev` |
| `nr` | `npm run` |
| `ns` | `npm start` |
| `nt` | `npm test` |
| `nb` | `npm run build` |

#### Yarn
| Abbreviation | Expands To |
|--------------|------------|
| `y` | `yarn` |
| `yi` | `yarn install` |
| `ya` | `yarn add` |
| `yad` | `yarn add --dev` |
| `yr` | `yarn run` |
| `ys` | `yarn start` |
| `yt` | `yarn test` |
| `yb` | `yarn build` |

#### PNPM
| Abbreviation | Expands To |
|--------------|------------|
| `p` | `pnpm` |
| `pi` | `pnpm install` |
| `pa` | `pnpm add` |
| `pad` | `pnpm add -D` |
| `pr` | `pnpm run` |
| `ps` | `pnpm start` |
| `pt` | `pnpm test` |
| `pb` | `pnpm build` |

### System Commands
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `c` | `clear` | Clear screen |
| `h` | `history` | Command history |
| `x` | `exit` | Exit shell |
| `mkd` | `mkdir -p` | Create directory recursively |
| `rmd` | `rm -rf` | Remove directory recursively |
| `cpr` | `cp -r` | Copy recursively |

### Editor Commands
| Abbreviation | Expands To |
|--------------|------------|
| `v` | `nvim` |
| `vi` | `nvim` |
| `e` | `nvim` |
| `code` | `code .` |

### Navigation
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `....` | `cd ../../..` | Up three directories |
| `.....` | `cd ../../../..` | Up four directories |

### List Commands
| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `l` | `ls -lh` | List with human-readable sizes |
| `ll` | `ls -lah` | List all with details |
| `lt` | `ls -lth` | List sorted by time |
| `ltr` | `ls -ltrh` | List sorted by time (reverse) |

### Cargo/Rust
| Abbreviation | Expands To |
|--------------|------------|
| `cr` | `cargo run` |
| `cb` | `cargo build` |
| `ct` | `cargo test` |
| `cc` | `cargo check` |
| `cw` | `cargo watch` |
| `cf` | `cargo fmt` |
| `cl` | `cargo clippy` |

### Python
| Abbreviation | Expands To |
|--------------|------------|
| `py` | `python3` |
| `pip` | `pip3` |
| `venv` | `python3 -m venv venv` |
| `vact` | `source venv/bin/activate.fish` |

## Context-Aware Abbreviations

The system automatically activates context-specific abbreviations based on your current directory:

### In Git Repositories
| Abbreviation | Expands To |
|--------------|------------|
| `b` | `git branch` |
| `s` | `git status` |
| `l` | `git log --oneline` |
| `co` | `git checkout` |

### In Node.js Projects (with package.json)
| Abbreviation | Expands To |
|--------------|------------|
| `t` | `npm test` |
| `d` | `npm run dev` |
| `bs` | `npm run build && npm start` |

### In Rust Projects (with Cargo.toml)
| Abbreviation | Expands To |
|--------------|------------|
| `r` | `cargo run` |
| `t` | `cargo test` |
| `b` | `cargo build` |

### In Python Projects
| Abbreviation | Expands To |
|--------------|------------|
| `t` | `pytest` |
| `r` | `python3 -m` |

## Management Functions

### `abbr_add <name> <expansion>`
Add a custom abbreviation and save it permanently.

**Example:**
```fish
abbr_add gpp "git pull && git push"
abbr_add deploy "npm run build && npm run deploy"
```

### `abbr_list [filter]`
List all abbreviations, optionally filtered by a search term.

**Examples:**
```fish
abbr_list              # Show all abbreviations grouped by category
abbr_list git          # Show only git-related abbreviations
abbr_list docker       # Show only docker abbreviations
```

### `abbr_search <term>`
Search for abbreviations by name or expansion.

**Example:**
```fish
abbr_search checkout   # Find all abbreviations containing "checkout"
abbr_search test       # Find all test-related abbreviations
```

### `abbr_rm <name>`
Remove a custom abbreviation permanently.

**Example:**
```fish
abbr_rm gpp           # Remove the gpp abbreviation
```

### `abbr_tips`
Display a random helpful tip about abbreviations.

**Example:**
```fish
abbr_tips
# Output: 💡 Type 'gst' instead of 'git status' - it expands automatically!
```

### `abbr_help`
Show comprehensive help documentation.

**Example:**
```fish
abbr_help
```

### `abbr_stats`
Show statistics about your abbreviations.

**Example:**
```fish
abbr_stats
# Shows total count and breakdown by category
```

## Custom Abbreviations

Your personal abbreviations are stored in:
`~/.config/fish/personalized/abbreviations.fish`

This file is automatically created when you add your first custom abbreviation using `abbr_add`.

## How Abbreviations Work

1. **Type the abbreviation**: e.g., `gst`
2. **Press SPACE**: The abbreviation expands to `git status`
3. **Edit if needed**: You can modify the expanded command
4. **Press ENTER**: Execute the command

Unlike aliases, abbreviations let you see and edit the full command before execution.

## Conflict Avoidance

The abbreviation system is designed to NOT conflict with your existing aliases in `/Users/davidsamuel.nechifor/.config/fish/personalized/alias.fish`.

Detected existing aliases that might overlap:
- `gio` → `git` (alias exists, abbreviation uses `g` instead)
- `gis` → `git status` (alias exists, abbreviation uses `gst` instead)
- `gip` → `git push` (alias exists, abbreviation uses `gps` instead)

The abbreviation system uses different naming patterns to avoid conflicts.

## Tips and Tricks

1. **Discoverability**: Use `abbr_list` to explore available abbreviations
2. **Learning**: Run `abbr_tips` periodically to learn new shortcuts
3. **Customization**: Create abbreviations for your most common command sequences
4. **Context Awareness**: Navigate into project directories to activate context-specific abbreviations
5. **Quick Stats**: Run `abbr_stats` to see your abbreviation usage breakdown

## Files and Locations

- **Main Config**: `/Users/davidsamuel.nechifor/.config/fish/conf.d/04-abbreviations.fish`
- **Custom Abbreviations**: `/Users/davidsamuel.nechifor/.config/fish/personalized/abbreviations.fish`
- **Functions**: `/Users/davidsamuel.nechifor/.config/fish/functions/abbr_*.fish`

## Examples

### Adding Custom Abbreviations
```fish
# Add a deployment shortcut
abbr_add deploy "npm run build && npm run deploy"

# Add a git workflow
abbr_add gpp "git pull && git push"

# Add a workspace opener
abbr_add work "cd ~/Work && code ."
```

### Using Context-Aware Abbreviations
```fish
# In a git repository
cd ~/my-git-repo
b              # Expands to: git branch
s              # Expands to: git status

# In a Node.js project
cd ~/my-node-app
t              # Expands to: npm test
d              # Expands to: npm run dev
```

### Searching and Managing
```fish
# Find all checkout-related abbreviations
abbr_search checkout

# List only docker abbreviations
abbr_list docker

# Remove an abbreviation you no longer need
abbr_rm oldabbr
```

## Troubleshooting

**Problem**: Abbreviation not expanding
- **Solution**: Make sure you press SPACE after typing the abbreviation

**Problem**: Context-aware abbreviation not working
- **Solution**: The system detects context on directory change. Try `cd .` to refresh

**Problem**: Custom abbreviation not persisting
- **Solution**: Use `abbr_add` instead of `abbr -a` to save permanently

**Problem**: Conflict with existing alias
- **Solution**: Choose a different abbreviation name or remove the alias

## Performance

- Abbreviations are loaded at shell startup
- Context detection happens on directory change
- No performance impact during normal shell usage
- Custom abbreviations file is sourced automatically

---

Created: 2026-02-19
System Version: Component 13 - Dynamic Abbreviation System
