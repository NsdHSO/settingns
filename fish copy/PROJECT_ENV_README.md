# Project Environment Manager

An auto-loading environment system for project-specific settings in Fish Shell.

## Overview

The Project Environment Manager automatically detects and loads environment variables when you navigate into project directories. It provides:

- **Auto-loading**: Automatically loads `.envrc`, `.env`, or `.project-env` files
- **Security**: Prompts before loading unknown environment files
- **Performance**: Caches checks to avoid redundant operations
- **Python venv**: Auto-activates Python virtual environments
- **Node version**: Auto-switches Node versions based on `.nvmrc`
- **Clean unloading**: Unloads environment when leaving project directories

## How It Works

### Automatic Loading

When you `cd` into a directory, the system:

1. **Searches** for environment files in priority order:
   - `.envrc` (direnv compatible)
   - `.env` (standard env file)
   - `.project-env` (custom format)

2. **Security Check**:
   - If directory is **trusted**: Loads automatically
   - If directory is **new**: Shows file contents and asks permission
     - `y` - Load for this session only
     - `always` - Load and trust directory permanently
     - `n` - Don't load

3. **Loads Variables**: Exports all variables in the file

4. **Auto-Activation**:
   - Activates Python venv if `venv/`, `.venv/`, or similar exists
   - Switches Node version if `.nvmrc` exists (using NVM)

### Performance Optimization

- **Directory caching**: Remembers last directory to avoid redundant checks
- **File hashing**: Detects file changes using MD5 hash
- **Skip reload**: If same directory and file unchanged, skips reload

### Security Model

The system uses a **trust list** approach:

1. **First visit**: Shows file contents and requires approval
2. **Trusted directories**: Stored in `~/.config/fish/trusted_envrc_dirs`
3. **Always ask**: For new/untrusted directories
4. **Manual control**: Use `penv trust/untrust` commands

### Integration with Existing Tools

**Does NOT break**:
- SDKMAN integration (Java/Maven)
- NVM integration (Node version manager)
- Existing environment variables
- Other Fish configurations

**Enhances**:
- Works alongside direnv (if you use it)
- Compatible with Python virtualenv/venv
- Compatible with NVM's .nvmrc files

## File Formats

### .envrc / .env / .project-env

Standard format:
```bash
# Comments are supported
export API_KEY=your_api_key_here
export DATABASE_URL=postgresql://localhost/mydb
export NODE_ENV=development

# Variable expansion works
export PROJECT_ROOT=/home/user/projects
export DATA_DIR=$PROJECT_ROOT/data

# Quotes are optional
API_VERSION="v2"
DEBUG=true
```

## Commands

### Main Command: `penv`

```bash
penv                # Show current environment
penv save           # Save variables to .project-env
penv reload         # Force reload environment
penv show           # Show loaded environment
penv trust          # Trust current directory
penv untrust        # Untrust current directory
penv list           # List all trusted directories
penv help           # Show help
```

### Individual Functions

```bash
save_project_env           # Interactive save
reload_project_env         # Force reload
show_project_env          # Show current state
list_trusted_envrc        # List trusted dirs
untrust_project_env       # Untrust current dir
```

## Usage Examples

### Example 1: Create Project Environment

```bash
# Navigate to your project
cd ~/projects/myapp

# Set some project-specific variables
set -x DATABASE_URL postgresql://localhost/mydb
set -x API_KEY abc123
set -x DEBUG true

# Save them to .project-env
penv save
# Enter: DATABASE_URL API_KEY DEBUG

# File created: .project-env
# Next time you cd here, it auto-loads!
```

### Example 2: Use .env File

Create `.env` in your project:
```bash
export NODE_ENV=development
export PORT=3000
export DATABASE_URL=postgresql://localhost/mydb
```

```bash
# First visit
cd ~/projects/webapp

# System shows:
# ⚠️  Project environment file detected: /home/user/projects/webapp/.env
# Contents:
# export NODE_ENV=development
# export PORT=3000
# ...
# Load this environment? (y/n/always): always

# ✓ Environment loaded and directory trusted

# Verify
echo $NODE_ENV
# development
```

### Example 3: Python Project

```bash
cd ~/projects/python-app

# If venv/ exists, it auto-activates:
# ✓ Python venv activated: venv

# If .env exists and trusted:
# ✓ Project environment loaded from: .env

# Verify both are active
which python
# /home/user/projects/python-app/venv/bin/python

echo $DATABASE_URL
# postgresql://localhost/mydb
```

### Example 4: Node.js Project

Create `.nvmrc`:
```
16.14.0
```

Create `.env`:
```bash
export NODE_ENV=development
export PORT=3000
```

```bash
cd ~/projects/node-app

# System loads:
# ✓ Project environment loaded from: .env
# → Switching to Node version: 16.14.0
# ✓ Now using node v16.14.0

node --version
# v16.14.0

echo $PORT
# 3000
```

### Example 5: Managing Trust

```bash
# List trusted directories
penv list
# /home/user/projects/webapp
# /home/user/projects/api
# /home/user/projects/python-app

# Untrust current directory
cd ~/projects/webapp
penv untrust
# ✓ Directory untrusted: /home/user/projects/webapp

# Next cd will prompt again
cd ..
cd webapp
# ⚠️  Project environment file detected...
```

## File Locations

- **Main system**: `/Users/davidsamuel.nechifor/.config/fish/conf.d/project_env.fish`
- **Command utility**: `/Users/davidsamuel.nechifor/.config/fish/functions/penv.fish`
- **Trusted directories**: `~/.config/fish/trusted_envrc_dirs`
- **Cache**: `~/.config/fish/env_cache`

## Behavior on Directory Change

```
cd ~/projects/myapp
    ↓
Check if .envrc/.env/.project-env exists
    ↓
Calculate file hash (cache check)
    ↓
If same file + same hash → SKIP
    ↓
If different/new → Continue
    ↓
Check if directory trusted
    ↓
No → Show contents + Ask permission
Yes → Load automatically
    ↓
Unload previous environment (if any)
    ↓
Load new environment variables
    ↓
Auto-activate Python venv (if exists)
    ↓
Auto-switch Node version (if .nvmrc exists)
```

## Leaving Projects

When you leave a project directory:

```bash
cd ~/projects/myapp
# ✓ Project environment loaded from: .env

cd ~
# ✓ Left project environment
# (All loaded variables are unset)
```

## Security Features

1. **Content preview**: Shows file contents before loading
2. **User consent**: Requires explicit permission
3. **Trust tracking**: Remembers trusted directories
4. **Manual override**: `penv trust/untrust` commands
5. **No auto-trust**: Never trusts without user confirmation

## Performance Features

1. **Directory cache**: Skips checks if in same directory
2. **File hash cache**: Detects file changes efficiently
3. **Lazy loading**: Only loads when directory changes
4. **Smart unload**: Only unloads when necessary

## Compatibility

### Works with:
- ✅ SDKMAN (Java/Maven version management)
- ✅ NVM (Node version management)
- ✅ Python venv/virtualenv
- ✅ direnv (can coexist)
- ✅ Docker environments
- ✅ Any Fish shell configuration

### Does NOT interfere with:
- ✅ Global environment variables
- ✅ Shell initialization scripts
- ✅ Other Fish plugins
- ✅ System PATH

## Troubleshooting

### Environment not loading?

```bash
# Check if file exists
ls -la .env .envrc .project-env

# Force reload
penv reload

# Check what's loaded
penv show
```

### Variables not unloading?

```bash
# Current loaded environment
penv show

# Manually unload (if needed)
cd ..
cd -  # Return to trigger reload
```

### Directory not trusted?

```bash
# Trust it manually
penv trust

# Or remove and re-trust
penv untrust
cd ..
cd -
# (Choose 'always' when prompted)
```

### Python venv not activating?

Make sure your venv is in a standard location:
- `venv/`
- `.venv/`
- `env/`
- `.env/` (directory, not file)
- `virtualenv/`

### Node version not switching?

Make sure:
- NVM is installed and working
- `.nvmrc` file exists with version number
- Version is installed: `nvm install <version>`

## Advanced Usage

### Custom environment files

You can use any supported filename:

```bash
# .envrc (direnv style)
export VAR1=value1

# .env (standard)
VAR2=value2

# .project-env (custom)
export VAR3=value3
```

### Variable expansion

All formats support variable expansion:

```bash
export HOME_DIR=/home/user
export PROJECT_DIR=$HOME_DIR/projects
export DATA_DIR=${PROJECT_DIR}/data
```

### Conditional loading

You can script around it:

```bash
# In your project script
if test -f .env
    penv reload
end
```

## Integration Example

Complete project setup:

```bash
# 1. Create project
mkdir ~/projects/fullstack-app
cd ~/projects/fullstack-app

# 2. Create Python venv
python -m venv venv

# 3. Create Node version file
echo "16.14.0" > .nvmrc

# 4. Create environment file
cat > .env << EOF
export NODE_ENV=development
export PORT=3000
export DATABASE_URL=postgresql://localhost/mydb
export REDIS_URL=redis://localhost:6379
export SECRET_KEY=dev-secret-key
EOF

# 5. Leave and return
cd ..
cd fullstack-app

# System automatically:
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv
# → Switching to Node version: 16.14.0

# 6. Verify everything
which python
echo $NODE_ENV
node --version

# All set! 🚀
```

## Summary

The Project Environment Manager provides:

1. **Automatic** environment loading on directory change
2. **Secure** with user permission and trust system
3. **Fast** with caching and optimization
4. **Compatible** with existing tools (NVM, SDKMAN, venv)
5. **Clean** unloading when leaving projects
6. **Simple** interface via `penv` command

No more manual `source .env` or remembering to activate venvs!
