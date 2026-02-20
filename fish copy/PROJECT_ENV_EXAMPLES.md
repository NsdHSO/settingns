# Project Environment Manager - Examples

## Quick Start Guide

### 1. Basic Usage - First Time

```bash
# Create a test project
mkdir -p ~/test-project
cd ~/test-project

# Create a simple .env file
cat > .env << 'EOF'
export PROJECT_NAME=test-project
export ENVIRONMENT=development
export DEBUG=true
EOF

# Leave and return to trigger the system
cd ..
cd test-project

# You'll see:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚠️  Project environment file detected: /Users/.../test-project/.env
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Contents:
# export PROJECT_NAME=test-project
# export ENVIRONMENT=development
# export DEBUG=true
#
# Load this environment? (y/n/always): always
# ✓ Environment loaded and directory trusted

# Check the variables
echo $PROJECT_NAME    # test-project
echo $ENVIRONMENT     # development
echo $DEBUG           # true
```

### 2. Using penv Command

```bash
# Show current environment
penv
# or
penv show

# Save current variables to .project-env
set -x MY_VAR "some value"
set -x API_KEY "secret123"
penv save
# Enter: MY_VAR API_KEY

# Reload environment (after editing .env file)
penv reload

# Trust current directory
penv trust

# List all trusted directories
penv list

# Untrust current directory
penv untrust
```

### 3. Python Project with Virtual Environment

```bash
# Create Python project
mkdir -p ~/projects/python-api
cd ~/projects/python-api

# Create virtual environment
python3 -m venv venv

# Create .env file
cat > .env << 'EOF'
export FLASK_APP=app.py
export FLASK_ENV=development
export DATABASE_URL=sqlite:///dev.db
export SECRET_KEY=dev-secret-key
EOF

# Leave and return
cd ..
cd python-api

# System automatically:
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv

# Verify both
which python
# ~/projects/python-api/venv/bin/python

echo $FLASK_ENV
# development
```

### 4. Node.js Project with Version Management

```bash
# Create Node project
mkdir -p ~/projects/node-api
cd ~/projects/node-api

# Create .nvmrc
echo "18.17.0" > .nvmrc

# Create .env
cat > .env << 'EOF'
export NODE_ENV=development
export PORT=3000
export DB_HOST=localhost
export DB_NAME=myapp
EOF

# Leave and return
cd ..
cd node-api

# System automatically:
# ✓ Project environment loaded from: .env
# → Switching to Node version: 18.17.0

# Verify
node --version  # v18.17.0
echo $PORT      # 3000
```

### 5. Full Stack Project

```bash
# Create full stack project
mkdir -p ~/projects/fullstack-app
cd ~/projects/fullstack-app

# Setup Python backend
python3 -m venv venv

# Setup Node version
echo "18.17.0" > .nvmrc

# Create comprehensive .env
cat > .env << 'EOF'
# Application
export APP_NAME=fullstack-app
export NODE_ENV=development
export DEBUG=true

# Server
export API_PORT=8000
export WEB_PORT=3000

# Database
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=fullstack_db
export DB_USER=developer
export DB_PASSWORD=dev123

# Redis
export REDIS_HOST=localhost
export REDIS_PORT=6379

# API Keys (development)
export STRIPE_API_KEY=sk_test_...
export SENDGRID_API_KEY=SG....

# Paths
export DATA_DIR=$HOME/projects/fullstack-app/data
export LOGS_DIR=$HOME/projects/fullstack-app/logs
EOF

# Leave and return
cd ..
cd fullstack-app

# System automatically:
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv
# → Switching to Node version: 18.17.0

# Everything is ready!
```

### 6. Using .envrc (direnv style)

```bash
# Create project
mkdir -p ~/projects/backend-api
cd ~/projects/backend-api

# Create .envrc (loaded first if exists)
cat > .envrc << 'EOF'
# Development environment
export ENV=development
export LOG_LEVEL=debug

# Database
export DATABASE_URL=postgresql://localhost/backend_dev

# Feature flags
export ENABLE_BETA_FEATURES=true
export ENABLE_CACHING=false

# Build configuration
export BUILD_MODE=debug
export OPTIMIZATION_LEVEL=0
EOF

# Trust and load
cd ..
cd backend-api
# Choose: always

# Verify
echo $LOG_LEVEL           # debug
echo $DATABASE_URL        # postgresql://localhost/backend_dev
```

### 7. Managing Multiple Environments

```bash
# Project with environment-specific configs
mkdir -p ~/projects/multi-env-app
cd ~/projects/multi-env-app

# Create .env (development)
cat > .env << 'EOF'
export ENV=development
export DATABASE_URL=postgresql://localhost/dev_db
export API_URL=http://localhost:8000
export DEBUG=true
EOF

# Create .env.production (for reference)
cat > .env.production << 'EOF'
export ENV=production
export DATABASE_URL=postgresql://prod-server/prod_db
export API_URL=https://api.example.com
export DEBUG=false
EOF

# By default, loads .env
cd ..
cd multi-env-app
# ✓ Project environment loaded from: .env

# To use production config, swap files:
# mv .env .env.development
# mv .env.production .env
# penv reload
```

### 8. Workspace with Multiple Projects

```bash
# Create workspace
mkdir -p ~/workspace
cd ~/workspace

# Create workspace-level .env
cat > .env << 'EOF'
export WORKSPACE=~/workspace
export SHARED_DATA=$WORKSPACE/shared-data
export SHARED_LOGS=$WORKSPACE/logs
export WORKSPACE_ENV=development
EOF

# Create project 1
mkdir -p project1
cd project1
cat > .env << 'EOF'
export PROJECT_NAME=project1
export PORT=3001
export DATABASE_URL=postgresql://localhost/project1_db
EOF
cd ..

# Create project 2
mkdir -p project2
cd project2
cat > .env << 'EOF'
export PROJECT_NAME=project2
export PORT=3002
export DATABASE_URL=postgresql://localhost/project2_db
EOF
cd ..

# Usage:
cd project1
# ✓ Project environment loaded from: .env
# (project1 vars loaded, workspace vars unloaded)
echo $PROJECT_NAME  # project1
echo $PORT          # 3001

cd ../project2
# ✓ Left project environment
# ✓ Project environment loaded from: .env
# (project2 vars loaded, project1 vars unloaded)
echo $PROJECT_NAME  # project2
echo $PORT          # 3002
```

### 9. Saving Current Environment

```bash
# Setup your environment manually
cd ~/projects/myapp

set -x DATABASE_URL postgresql://localhost/myapp
set -x REDIS_URL redis://localhost:6379
set -x API_KEY abc123xyz
set -x SECRET_KEY super-secret

# Save to .project-env
penv save
# Enter variable names to save (space-separated): DATABASE_URL REDIS_URL API_KEY SECRET_KEY
# ✓ Project environment saved to: .project-env
# Trust this directory for auto-loading? (y/n): y
# ✓ Directory trusted: ~/projects/myapp

# Next time you cd here, it auto-loads!
cd ..
cd myapp
# ✓ Project environment loaded from: .project-env
```

### 10. Security Example - Untrusted Directory

```bash
# Download a project from unknown source
git clone https://github.com/unknown/sketchy-project
cd sketchy-project

# If .env exists:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚠️  Project environment file detected: .../sketchy-project/.env
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Contents:
# export MALICIOUS_SCRIPT=/tmp/malware.sh
# export AUTO_RUN=true
#
# Load this environment? (y/n/always): n
# ✗ Environment not loaded

# Safe! Variables not loaded.
```

## Real-World Scenarios

### Scenario 1: Daily Development Workflow

```bash
# Morning - Start work on API project
cd ~/projects/company-api
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv
# → Switching to Node version: 18.17.0

# All environment ready
flask run --port $API_PORT

# Switch to frontend
cd ~/projects/company-web
# ✓ Left project environment
# ✓ Project environment loaded from: .env
# → Switching to Node version: 18.17.0

npm run dev

# Switch to mobile app
cd ~/projects/company-mobile
# ✓ Left project environment
# ✓ Project environment loaded from: .env

# Each project has its own isolated environment!
```

### Scenario 2: Client Projects

```bash
# Client A project
cd ~/clients/client-a/backend
# ✓ Project environment loaded from: .env
echo $CLIENT_NAME       # client-a
echo $DATABASE_URL      # postgresql://localhost/client_a_db
echo $API_KEY           # client_a_api_key

# Switch to Client B
cd ~/clients/client-b/backend
# ✓ Left project environment
# ✓ Project environment loaded from: .env
echo $CLIENT_NAME       # client-b
echo $DATABASE_URL      # postgresql://localhost/client_b_db
echo $API_KEY           # client_b_api_key

# No mixing of client data!
```

### Scenario 3: Teaching/Learning

```bash
# Tutorial 1 - Express API
cd ~/tutorials/express-tutorial
# ✓ Project environment loaded from: .env
echo $PORT              # 3000
echo $NODE_ENV          # development

# Tutorial 2 - Django App
cd ~/tutorials/django-tutorial
# ✓ Left project environment
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv
echo $PORT              # 8000
echo $DJANGO_ENV        # development

# Each tutorial isolated!
```

## Common Patterns

### Pattern 1: Database per Project

```bash
# .env
export DATABASE_URL=postgresql://localhost/${PROJECT_NAME}_db
export DB_NAME=${PROJECT_NAME}_db
export DB_USER=${PROJECT_NAME}_user
```

### Pattern 2: Port Management

```bash
# .env
export API_PORT=8000
export WEB_PORT=3000
export WEBSOCKET_PORT=3001
export METRICS_PORT=9090
```

### Pattern 3: Feature Flags

```bash
# .env
export ENABLE_ANALYTICS=false
export ENABLE_BETA_FEATURES=true
export USE_MOCK_DATA=true
export SKIP_AUTH=true  # development only
```

### Pattern 4: Path Configuration

```bash
# .env
export PROJECT_ROOT=$HOME/projects/myapp
export DATA_DIR=$PROJECT_ROOT/data
export LOGS_DIR=$PROJECT_ROOT/logs
export UPLOAD_DIR=$PROJECT_ROOT/uploads
export TEMP_DIR=$PROJECT_ROOT/tmp
```

## Tips & Tricks

### Tip 1: Check Before Committing

```bash
# Make sure to add .env to .gitignore
echo ".env" >> .gitignore
echo ".envrc" >> .gitignore
echo ".project-env" >> .gitignore

# Create example file for team
cat > .env.example << 'EOF'
export DATABASE_URL=postgresql://localhost/myapp
export API_KEY=your-key-here
export SECRET_KEY=your-secret-here
EOF

git add .env.example
```

### Tip 2: Quick Check

```bash
# Always verify what's loaded
penv show

# Or check specific variable
echo $DATABASE_URL
```

### Tip 3: Template for New Projects

```bash
# Create template
mkdir -p ~/.templates/new-project
cat > ~/.templates/new-project/.env << 'EOF'
export PROJECT_NAME=my-project
export ENVIRONMENT=development
export DEBUG=true
export PORT=3000
export DATABASE_URL=postgresql://localhost/my_project_db
EOF

# Use template
cp ~/.templates/new-project/.env ~/projects/new-app/
cd ~/projects/new-app
# Edit .env with project-specific values
```

### Tip 4: Global Variables

```bash
# Keep some variables global (in config.fish)
# Use project vars for project-specific overrides

# config.fish
set -gx DEFAULT_PORT 8000

# project .env
export PORT=3000  # Overrides default for this project
```

## Troubleshooting Examples

### Problem: Variables Not Loading

```bash
# Check if file exists
ls -la .env .envrc .project-env

# Check file contents
cat .env

# Force reload
penv reload

# Check trust status
penv list | grep (pwd)
```

### Problem: Wrong Variables Loaded

```bash
# Show what's currently loaded
penv show

# Check which file is being used
ls -la .envrc .env .project-env
# Priority: .envrc > .env > .project-env

# Reload
penv reload
```

### Problem: Variables Persist After Leaving

```bash
# This shouldn't happen, but if it does:
cd ..
cd -
penv reload

# Or manually check
penv show
# Should show: "No project environment currently loaded"
```

## Summary

The Project Environment Manager makes it easy to:

- ✅ Automatically load project environments
- ✅ Keep projects isolated
- ✅ Auto-activate Python venvs
- ✅ Auto-switch Node versions
- ✅ Maintain security with trust system
- ✅ Save and restore configurations

Try it out with the examples above!
