# Session Management - Real-World Examples

## Example 1: Daily Development Workflow

### Morning Routine
```fish
# Restore yesterday's work session
session_restore daily-work

# Output:
# Restoring session: daily-work
# Changed to directory: /Users/you/projects/main-app
# Previous git branch: feature/auth
# Session history loaded: 50 commands
# Session 'daily-work' restored successfully!
```

### End of Day
```fish
# Save current state
session_save daily-work

# Output:
# Session 'daily-work' saved successfully!
# Location: ~/.config/fish/sessions/daily-work.session
# Restore with: session_restore daily-work
```

## Example 2: Multiple Project Management

### Scenario: Switching between frontend and backend projects

```fish
# Working on frontend
cd ~/projects/frontend-app
set -gx NODE_ENV development
set -gx API_URL http://localhost:3000

# Save frontend state
session_save frontend-dev

# Switch to backend
cd ~/projects/backend-api
set -gx DATABASE_URL postgresql://localhost/dev
set -gx PORT 3000

# Save backend state
session_save backend-dev

# Later: Quick switch to frontend
session_restore frontend-dev
# You're back in frontend with all env vars!

# Quick switch to backend
session_restore backend-dev
# You're back in backend with all env vars!
```

## Example 3: Team Onboarding

### Create Team Setup Script

```fish
# Set up your perfect development environment
cd ~/projects/team-project
set -gx NODE_ENV development
set -gx DATABASE_URL postgresql://localhost/teamdb
set -gx REDIS_URL redis://localhost:6379

# Save the session
session_save team-project-setup

# Export for team members
session_export -n team-project-setup -f bash -o team-setup.sh

# Share team-setup.sh via git or Slack
# Team members run: bash team-setup.sh
```

### team-setup.sh looks like:
```bash
#!/usr/bin/env bash
# Exported from Fish session: team-project-setup
# Created: 2026-02-19 10:30:00

# Working Directory
cd '/Users/you/projects/team-project'

# Environment Variables
export NODE_ENV='development'
export DATABASE_URL='postgresql://localhost/teamdb'
export REDIS_URL='redis://localhost:6379'
```

## Example 4: Using Templates for New Projects

### Starting a New Node.js Project

```fish
# Create project directory
mkdir ~/projects/new-api
cd ~/projects/new-api

# Apply Node.js template
session_template -a nodejs

# Output:
# Applying template: nodejs
# Node.js Session Initialized
# v20.11.0
# 10.5.0
# Template 'nodejs' applied successfully!

# Now save as a session
session_save new-api-dev

# Continue working...
npm init -y
npm install express

# Save progress
session_save new-api-dev
```

## Example 5: Experiment and Rollback

### Before Making Breaking Changes

```fish
# Current stable state
cd ~/projects/main-app
session_save before-refactor

# Make experimental changes...
# Refactor database layer
# Update dependencies
# Modify configs

# Save experimental state
session_save after-refactor

# Compare what changed
session_diff before-refactor

# Output:
# Working Directory:
#   ✓ Same: /Users/you/projects/main-app
#
# Git Branch:
#   ✗ Different:
#     Saved:   main
#     Current: experimental-refactor
#
# Environment Variables:
#   ✗ DATABASE_URL
#     Saved:   postgresql://localhost/app
#     Current: postgresql://localhost/app_v2

# If experiment failed, rollback:
session_restore before-refactor

# If experiment succeeded, keep going:
session_save main-app-dev
```

## Example 6: Context-Specific Sessions

### Different Contexts for Same Project

```fish
# Development session
cd ~/projects/app
set -gx NODE_ENV development
set -gx DEBUG '*'
session_save app-dev

# Testing session
cd ~/projects/app
set -gx NODE_ENV test
set -gx DEBUG 'test:*'
session_save app-test

# Production debugging session
cd ~/projects/app
set -gx NODE_ENV production
set -gx DEBUG 'error:*'
session_save app-prod-debug

# Switch contexts easily:
session_restore app-test     # Run tests
session_restore app-dev      # Back to development
session_restore app-prod-debug  # Debug production issues
```

## Example 7: Auto-Save for Safety

### Enable Auto-Save for Current Project

```fish
# Working on critical project
cd ~/projects/critical-app

# Enable auto-save
session_autosave_enable
session_autosave_name critical-app-autosave

# Work normally...
# All changes automatically saved when you exit shell

# Later, if terminal crashes:
# Open new terminal
session_restore critical-app-autosave
# You're back where you left off!
```

## Example 8: Custom Template Creation

### Create Django Project Template

```fish
# Create custom template
session_template -c django

# Follow prompts:
# Description: Django development environment
# Default working directory: /Users/you/projects/django

# Edit the template
edit ~/.config/fish/sessions/templates/django.template

# Add to template:
set -gx DJANGO_SETTINGS_MODULE 'project.settings.development'
set -gx PYTHONPATH '.'
set -gx DEBUG 'True'

set -l startup_commands \
    'python --version' \
    'django-admin --version' \
    'echo "Django environment ready!"'

# Use template for new Django projects:
cd ~/projects/new-django-app
session_template -a django
```

## Example 9: Session List and Management

### Organize Your Sessions

```fish
# List all sessions
session_list

# Output:
# Available Sessions:
#
#   frontend-dev
#     Created: 2026-02-19 09:00:00
#     Location: /Users/you/projects/frontend
#
#   backend-api
#     Created: 2026-02-19 10:30:00
#     Location: /Users/you/projects/backend
#
# Total: 2 session(s)

# Detailed view
session_list -l

# Output table format:
# NAME              MODIFIED              SIZE      LOCATION
# ----              --------              ----      --------
# frontend-dev      2026-02-19 09:00      2K        /Users/you/projects/frontend
# backend-api       2026-02-19 10:30      3K        /Users/you/projects/backend

# Clean up old sessions
session_delete old-project-2023
```

## Example 10: Integration with Git Workflows

### Feature Branch Sessions

```fish
# Starting new feature
cd ~/projects/app
git checkout -b feature/new-auth

# Set up feature environment
set -gx FEATURE_FLAG_NEW_AUTH true
set -gx DEBUG 'auth:*'

# Save feature session
session_save feature-new-auth

# Switch to another feature
git checkout -b feature/dashboard
set -gx FEATURE_FLAG_DASHBOARD true
session_save feature-dashboard

# Switch between features easily:
session_restore feature-new-auth
# Automatically on correct branch with correct env vars!

session_restore feature-dashboard
# Switched to dashboard feature context!
```

## Example 11: Export for Documentation

### Create Project Setup Docs

```fish
# Perfect development setup
cd ~/projects/open-source-app
session_save perfect-setup

# Export to JSON for documentation
session_export -n perfect-setup -f json > docs/dev-env.json

# Export to bash for contributors
session_export -n perfect-setup -f bash -o scripts/setup-dev-env.sh

# Add to README.md:
# ## Development Setup
# Run: `bash scripts/setup-dev-env.sh`
```

## Example 12: Microservices Management

### Managing Multiple Services

```fish
# Service 1: API Gateway
cd ~/projects/services/api-gateway
set -gx SERVICE_PORT 8000
set -gx SERVICE_NAME api-gateway
session_save service-api-gateway

# Service 2: Auth Service
cd ~/projects/services/auth
set -gx SERVICE_PORT 8001
set -gx SERVICE_NAME auth-service
session_save service-auth

# Service 3: User Service
cd ~/projects/services/users
set -gx SERVICE_PORT 8002
set -gx SERVICE_NAME user-service
session_save service-users

# Quick service switching:
session_restore service-api-gateway  # Debug gateway
session_restore service-auth         # Work on auth
session_restore service-users        # Update users

# Create master service list
echo "Available Services:" > SERVICES.md
session_list -l >> SERVICES.md
```

## Example 13: Session Aliases for Speed

### Create Convenient Aliases

```fish
# Add to ~/.config/fish/personalized/alias.fish

# Project shortcuts
alias fe='session_restore frontend-dev'
alias be='session_restore backend-api'
alias db='session_restore database-admin'

# Template shortcuts
alias new-node='session_template -a nodejs'
alias new-python='session_template -a python'
alias new-rust='session_template -a rust'

# Session management shortcuts
alias sl='session_list -l'
alias ss='session_save'
alias sr='session_restore'

# Quick save current work
alias save-work='session_save (basename $PWD)'

# Usage:
fe          # Jump to frontend
be          # Jump to backend
new-node    # Start new Node.js project
save-work   # Quick save current directory
```

## Example 14: CI/CD Integration

### Testing Environment Setup

```fish
# Create CI environment
cd ~/projects/app
set -gx CI true
set -gx NODE_ENV test
set -gx DATABASE_URL postgresql://localhost/ci_test

session_save ci-test-env

# Export for CI pipeline
session_export -n ci-test-env -f bash -o .ci/setup-env.sh

# In CI config (.github/workflows/test.yml):
# - name: Setup Environment
#   run: source .ci/setup-env.sh
```

## Example 15: Learning and Tutorials

### Save Tutorial Progress

```fish
# Following a Rust tutorial
cd ~/learning/rust-book/chapter-5
session_save rust-ch5

# Work through chapter...

# Next day:
session_restore rust-ch5
# Right back where you left off!

# Moving to next chapter:
cd ~/learning/rust-book/chapter-6
session_save rust-ch6

# Review previous chapters:
session_list
# rust-ch1, rust-ch2, rust-ch3, rust-ch4, rust-ch5, rust-ch6

# Jump to any chapter:
session_restore rust-ch3
```

## Tips and Best Practices

### 1. Naming Conventions
```fish
# Use descriptive names with context
session_save frontend-feature-auth      # Good
session_save work                       # Too vague

# Include project and context
session_save myapp-dev
session_save myapp-test
session_save myapp-prod-debug
```

### 2. Regular Cleanup
```fish
# Monthly cleanup
session_list -l
session_delete old-project-2023-01
session_delete old-project-2023-02
```

### 3. Template Organization
```fish
# Create templates for common stacks
session_template -c mern-stack
session_template -c django-rest
session_template -c rails-api
```

### 4. Backup Important Sessions
```fish
# Backup to git repo
cd ~/dotfiles
mkdir -p fish-sessions
cp ~/.config/fish/sessions/*.session fish-sessions/
git add fish-sessions
git commit -m "Backup fish sessions"
```

### 5. Share Team Sessions
```fish
# Export standard dev environment
session_export -n team-standard -f bash -o ~/team-shared/dev-setup.sh

# Team members use:
# bash ~/team-shared/dev-setup.sh
```

## Advanced Patterns

### Session Chaining
```fish
# Create setup sequence
function setup_full_stack
    session_restore database-dev
    # Wait for DB to start
    session_restore backend-dev
    # Wait for backend to start
    session_restore frontend-dev
end
```

### Conditional Sessions
```fish
# Auto-restore based on directory
function auto_session
    set -l session_name (basename $PWD)
    if session_list | grep -q $session_name
        session_restore --no-cd $session_name
    end
end

# Add to config.fish:
# auto_session
```

These examples show the power and flexibility of the session management system for real-world development workflows!
