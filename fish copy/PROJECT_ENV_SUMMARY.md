# Project Environment Manager - Quick Reference

## What It Does

Automatically loads project-specific environment variables when you `cd` into directories.

## Features at a Glance

| Feature | Description |
|---------|-------------|
| **Auto-loading** | Detects `.envrc`, `.env`, or `.project-env` files |
| **Security** | Shows contents and asks permission before loading |
| **Performance** | Caches checks, only reloads when needed |
| **Python venv** | Auto-activates `venv/`, `.venv/`, etc. |
| **Node version** | Auto-switches based on `.nvmrc` (via NVM) |
| **Auto-unload** | Cleans up when leaving project |
| **Trust system** | Remember safe directories |

## Quick Start

```bash
# Create a test
mkdir ~/test-project
cd ~/test-project
echo 'export TEST_VAR=hello' > .env

# Leave and return to trigger
cd .. && cd test-project

# You'll see prompt:
# Load this environment? (y/n/always): always
# ✓ Environment loaded and directory trusted

echo $TEST_VAR  # hello
```

## Commands

```bash
penv              # Show current environment
penv save         # Save variables to .project-env
penv reload       # Force reload
penv show         # Show loaded environment
penv trust        # Trust current directory
penv untrust      # Untrust current directory
penv list         # List trusted directories
penv help         # Show help
```

## File Priority

1. `.envrc` (loaded first if exists)
2. `.env` (standard)
3. `.project-env` (custom)

## Environment File Format

```bash
# Comments are supported
export VAR_NAME=value
export DATABASE_URL=postgresql://localhost/db

# Quotes optional
API_KEY="secret123"
DEBUG=true

# Variable expansion works
export PROJECT_ROOT=/home/user/project
export DATA_DIR=$PROJECT_ROOT/data
```

## Security Model

```
┌─────────────────────────────────────┐
│ cd into directory                   │
└─────────────┬───────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ Find .envrc/.env/.project-env       │
└─────────────┬───────────────────────┘
              ↓
      ┌───────┴────────┐
      │  Is trusted?   │
      └───────┬────────┘
              │
      Yes     │     No
       │      │      │
       │      │      ↓
       │      │  ┌────────────────────┐
       │      │  │ Show file contents │
       │      │  │ Ask permission     │
       │      │  └────────┬───────────┘
       │      │           │
       │      │   ┌───────┼───────┐
       │      │   y    always     n
       │      │   │       │       │
       │      │   ↓       ↓       ↓
       │      │ [Load] [Trust  [Skip]
       │      │         +Load]
       ↓      ↓
┌─────────────────────────────────────┐
│ Load environment variables          │
└─────────────┬───────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ Auto-activate Python venv (if any)  │
└─────────────┬───────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ Auto-switch Node version (if .nvmrc)│
└─────────────────────────────────────┘
```

## Auto-Activation

### Python Virtual Environment

Automatically activates if these directories exist:
- `venv/`
- `.venv/`
- `env/`
- `virtualenv/`

### Node Version

Automatically switches if `.nvmrc` exists and contains version number.

## Performance

**Optimizations:**
- Directory cache: Skips reload if same directory
- File hash cache: Detects changes via MD5
- Lazy loading: Only on directory change

**Cache invalidation:**
- Directory change → Check needed
- File modification → Hash changes → Reload

## Integration

**Works with:**
- ✅ SDKMAN (Java/Maven)
- ✅ NVM (Node version manager)
- ✅ Python venv/virtualenv
- ✅ Existing Fish configuration
- ✅ Other environment variables

**Does not break:**
- ✅ Global PATH
- ✅ System environment
- ✅ Other Fish plugins

## File Locations

| Item | Location |
|------|----------|
| Main system | `~/.config/fish/conf.d/project_env.fish` |
| Command utility | `~/.config/fish/functions/penv.fish` |
| Trusted dirs | `~/.config/fish/trusted_envrc_dirs` |
| Cache | `~/.config/fish/env_cache` |

## Common Workflows

### New Project Setup

```bash
cd ~/projects/new-app

# Option 1: Create .env manually
cat > .env << 'EOF'
export PROJECT_NAME=new-app
export DATABASE_URL=postgresql://localhost/new_app_db
export PORT=3000
EOF

# Option 2: Set and save
set -x PROJECT_NAME new-app
set -x DATABASE_URL postgresql://localhost/new_app_db
penv save
```

### Multi-Project Workspace

```bash
cd ~/workspace/api
# ✓ Project environment loaded from: .env
echo $PORT  # 8000

cd ~/workspace/web
# ✓ Left project environment
# ✓ Project environment loaded from: .env
echo $PORT  # 3000

# Each project isolated!
```

### Trust Management

```bash
# List trusted
penv list

# Trust current
penv trust

# Untrust current
penv untrust

# Manual edit
vim ~/.config/fish/trusted_envrc_dirs
```

## Examples

### Python + Flask

```bash
cd ~/projects/flask-api

# Directory has:
# - venv/
# - .env

# System automatically:
# ✓ Python venv activated: venv
# ✓ Project environment loaded from: .env

# Ready to go!
flask run --port $PORT
```

### Node.js + Express

```bash
cd ~/projects/express-api

# Directory has:
# - .nvmrc (contains: 18.17.0)
# - .env

# System automatically:
# ✓ Project environment loaded from: .env
# → Switching to Node version: 18.17.0

# Ready!
npm run dev
```

### Full Stack

```bash
cd ~/projects/fullstack

# Directory has:
# - venv/
# - .nvmrc
# - .env

# System automatically:
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv
# → Switching to Node version: 18.17.0

# Everything ready!
```

## Troubleshooting

### Variables not loading?

```bash
# Check file exists
ls -la .env .envrc .project-env

# Force reload
penv reload

# Check trust
penv list | grep (pwd)
```

### Variables not unloading?

```bash
# Show current state
penv show

# Should show "No project environment" when outside projects

# Force reload
cd .. && cd -
```

### Wrong variables?

```bash
# Check which file is loaded
penv show

# Check file priority
ls -la .envrc .env .project-env
# .envrc takes priority over .env over .project-env
```

## Best Practices

### Security

- ✅ Review file contents before trusting
- ✅ Use `.env.example` for team sharing
- ✅ Never commit `.env` to git
- ✅ Audit `penv list` regularly
- ❌ Don't trust unknown projects blindly

### Organization

- ✅ Use consistent naming (PROJECT_NAME, DATABASE_URL, etc.)
- ✅ Document variables in comments
- ✅ Keep .env files simple (only key=value)
- ✅ Use .env.example for documentation
- ❌ Don't put logic in .env files

### .gitignore

```bash
# Always add to .gitignore
.env
.envrc
.project-env

# Keep example for team
.env.example
```

## Comparison

| Feature | This System | direnv | Manual `source .env` |
|---------|-------------|--------|---------------------|
| Auto-load | ✅ | ✅ | ❌ |
| Auto-unload | ✅ | ✅ | ❌ |
| Security prompts | ✅ | ⚠️ | ❌ |
| Python venv | ✅ | ⚠️ | ❌ |
| Node version | ✅ | ⚠️ | ❌ |
| Code execution | ❌ | ✅ | ⚠️ |
| External deps | ❌ | ✅ | ❌ |
| Complexity | Low | Medium | Very Low |

## Advanced

### Custom venv location

System checks these by default:
- `venv/`, `.venv/`, `env/`, `virtualenv/`

For custom locations, create symlink:
```bash
ln -s /path/to/custom/venv venv
```

### Multiple .env files

```bash
# Development (default)
.env

# Production (for reference, don't load)
.env.production

# Testing
.env.test

# Swap as needed
mv .env .env.development
mv .env.production .env
penv reload
```

### Conditional variables

```bash
# .env
export ENV=development

if test "$ENV" = "production"
    export DEBUG=false
else
    export DEBUG=true
end
```

Wait, that won't work in .env file. Use application logic instead:

```python
# app.py
import os
DEBUG = os.environ.get('ENV') != 'production'
```

## Summary Table

| Component | Purpose |
|-----------|---------|
| `project_env.fish` | Main auto-loading system |
| `penv.fish` | User command interface |
| `trusted_envrc_dirs` | Trust whitelist |
| `.env` / `.envrc` / `.project-env` | Project config files |

## Getting Help

```bash
penv help        # Show help
penv show        # Debug current state
penv list        # Show trusted dirs
```

## Documentation Files

- `PROJECT_ENV_README.md` - Complete guide
- `PROJECT_ENV_EXAMPLES.md` - Usage examples
- `PROJECT_ENV_SECURITY.md` - Security details
- `PROJECT_ENV_SUMMARY.md` - This file (quick reference)

---

**Version:** 1.0
**Created:** 2026-02-19
**Author:** Project Environment Manager for Fish Shell
