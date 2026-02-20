# Test Project Environment Manager

Quick test script to verify the Project Environment Manager is working correctly.

## Quick Test

Run these commands in your Fish shell:

```bash
# Step 1: Create test directory
mkdir -p /tmp/penv-test
cd /tmp/penv-test

# Step 2: Create a test .env file
cat > .env << 'EOF'
export PROJECT_NAME=penv-test
export TEST_PORT=9999
export DEBUG_MODE=true
export DATABASE_URL=postgresql://localhost/test_db
EOF

# Step 3: Leave and return to trigger loading
cd ..
cd penv-test

# You should see:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚠️  Project environment file detected: /tmp/penv-test/.env
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Contents:
# export PROJECT_NAME=penv-test
# export TEST_PORT=9999
# export DEBUG_MODE=true
# export DATABASE_URL=postgresql://localhost/test_db
#
# Load this environment? (y/n/always):

# Type 'always' and press Enter

# Step 4: Verify variables are loaded
echo "Project: $PROJECT_NAME"
echo "Port: $TEST_PORT"
echo "Debug: $DEBUG_MODE"
echo "Database: $DATABASE_URL"

# Expected output:
# Project: penv-test
# Port: 9999
# Debug: true
# Database: postgresql://localhost/test_db

# Step 5: Test penv command
penv show

# Expected output should show the loaded environment

# Step 6: Test leaving project
cd ..
echo "Project: $PROJECT_NAME"

# Expected output: Empty (variables should be unloaded)

# Step 7: Test auto-reload
cd penv-test
echo "Project: $PROJECT_NAME"

# Expected output:
# ✓ Project environment loaded from: .env
# Project: penv-test

# Step 8: Test penv list
penv list

# Expected output should include: /tmp/penv-test

# Step 9: Test untrust
penv untrust

# Expected output:
# ✓ Directory untrusted: /tmp/penv-test

# Step 10: Cleanup
cd ..
rm -rf penv-test
```

## Detailed Testing

### Test 1: Basic Loading

```bash
mkdir -p ~/test-penv/basic
cd ~/test-penv/basic
echo 'export BASIC_TEST=success' > .env
cd .. && cd basic

# Expected: Prompt appears
# Action: Type 'y' and press Enter
# Expected: ✓ Environment loaded for this session

echo $BASIC_TEST
# Expected: success
```

### Test 2: Trust System

```bash
cd ~/test-penv/basic
penv trust
# Expected: ✓ Directory trusted: /Users/.../test-penv/basic

cd .. && cd basic
# Expected: ✓ Project environment loaded from: .env (no prompt)

penv list
# Expected: List includes ~/test-penv/basic
```

### Test 3: File Priority

```bash
cd ~/test-penv
mkdir priority-test
cd priority-test

# Create all three file types
echo 'export SOURCE=project-env' > .project-env
echo 'export SOURCE=env' > .env
echo 'export SOURCE=envrc' > .envrc

cd .. && cd priority-test
# Action: Type 'always'

echo $SOURCE
# Expected: envrc (highest priority)

# Remove .envrc and test again
rm .envrc
penv reload
echo $SOURCE
# Expected: env (second priority)

# Remove .env and test again
rm .env
penv reload
echo $SOURCE
# Expected: project-env (lowest priority)
```

### Test 4: Variable Expansion

```bash
cd ~/test-penv
mkdir expansion-test
cd expansion-test

cat > .env << 'EOF'
export BASE_DIR=$HOME/projects
export DATA_DIR=$BASE_DIR/data
export LOG_DIR=${DATA_DIR}/logs
EOF

cd .. && cd expansion-test
# Action: Type 'always'

echo "Base: $BASE_DIR"
echo "Data: $DATA_DIR"
echo "Logs: $LOG_DIR"

# Expected:
# Base: /Users/.../projects
# Data: /Users/.../projects/data
# Logs: /Users/.../projects/data/logs
```

### Test 5: Python venv Auto-Activation

```bash
cd ~/test-penv
mkdir python-test
cd python-test

# Create virtual environment
python3 -m venv venv

# Create .env
echo 'export PYTHON_PROJECT=true' > .env

cd .. && cd python-test
# Action: Type 'always'

# Expected output:
# ✓ Project environment loaded from: .env
# ✓ Python venv activated: venv

which python
# Expected: .../test-penv/python-test/venv/bin/python

echo $PYTHON_PROJECT
# Expected: true
```

### Test 6: Node Version Auto-Switch

```bash
cd ~/test-penv
mkdir node-test
cd node-test

# Create .nvmrc (adjust version to one you have installed)
echo "18.17.0" > .nvmrc

# Create .env
echo 'export NODE_PROJECT=true' > .env

cd .. && cd node-test
# Action: Type 'always'

# Expected output:
# ✓ Project environment loaded from: .env
# → Switching to Node version: 18.17.0

node --version
# Expected: v18.17.0

echo $NODE_PROJECT
# Expected: true
```

### Test 7: Save Functionality

```bash
cd ~/test-penv
mkdir save-test
cd save-test

# Set some variables
set -x MY_VAR "test value"
set -x MY_PORT 8080
set -x MY_DEBUG true

# Save them
penv save
# Enter: MY_VAR MY_PORT MY_DEBUG
# Action: Type 'y' to trust

# Verify file created
cat .project-env

# Expected:
# # Project environment variables
# # Generated on ...
#
# export MY_VAR="test value"
# export MY_PORT="8080"
# export MY_DEBUG="true"

# Test reload
cd .. && cd save-test
echo $MY_VAR
# Expected: test value
```

### Test 8: Unload on Exit

```bash
cd ~/test-penv/basic
echo $BASIC_TEST
# Expected: success

cd ~
echo $BASIC_TEST
# Expected: Empty (variable should be gone)

penv show
# Expected: No project environment currently loaded
```

### Test 9: Multiple Projects

```bash
cd ~/test-penv
mkdir project-a project-b

cd project-a
echo 'export PROJECT=A' > .env
echo 'export PORT=3000' > .env

cd ../project-b
echo 'export PROJECT=B' > .env
echo 'export PORT=4000' > .env

# Trust both
cd ../project-a
cd .. && cd project-a  # Trigger load, trust
cd ../project-b
cd .. && cd project-b  # Trigger load, trust

# Test isolation
cd ../project-a
echo "Project: $PROJECT, Port: $PORT"
# Expected: Project: A, Port: 3000

cd ../project-b
echo "Project: $PROJECT, Port: $PORT"
# Expected: Project: B, Port: 4000
```

### Test 10: Security - Reject Unknown

```bash
cd ~/test-penv
mkdir unsafe-test
cd unsafe-test

cat > .env << 'EOF'
export SUSPICIOUS_VAR=/tmp/malware.sh
export AUTO_RUN=true
export REMOTE_URL=https://evil.com/data
EOF

cd .. && cd unsafe-test

# Expected: Shows suspicious contents
# Action: Type 'n' to reject

echo $SUSPICIOUS_VAR
# Expected: Empty (not loaded)
```

## Verification Checklist

After running all tests, verify:

- [ ] Environment files are detected (.env, .envrc, .project-env)
- [ ] Security prompt appears for unknown directories
- [ ] File contents are shown before loading
- [ ] Variables are loaded correctly
- [ ] Variables are unloaded when leaving project
- [ ] Trust system works (auto-load after trusting)
- [ ] File priority is correct (.envrc > .env > .project-env)
- [ ] Variable expansion works ($VAR, ${VAR})
- [ ] Python venv auto-activates
- [ ] Node version auto-switches (if NVM installed)
- [ ] `penv` command works
- [ ] `penv save` creates .project-env file
- [ ] `penv show` displays loaded environment
- [ ] `penv list` shows trusted directories
- [ ] `penv trust/untrust` manages trust list
- [ ] Cache works (no reload on same directory)
- [ ] Multiple projects are isolated

## Cleanup

```bash
# Remove test directory
cd ~
rm -rf ~/test-penv

# Remove from trust list if needed
penv list
# For each /Users/.../test-penv/* directory:
cd <directory>
penv untrust
```

## Troubleshooting

### Test fails at security prompt

**Problem:** Prompt doesn't appear

**Solutions:**
```bash
# Check if conf.d file is loaded
functions | grep __load_project_env
# Should show function

# Reload Fish config
source ~/.config/fish/config.fish

# Try again
cd /tmp/penv-test
cd .. && cd penv-test
```

### Variables not loading

**Problem:** Variables are empty after loading

**Solutions:**
```bash
# Check if file exists
ls -la .env .envrc .project-env

# Check file contents
cat .env

# Force reload
penv reload

# Check what's loaded
penv show
```

### Python venv not activating

**Problem:** venv not auto-activated

**Solutions:**
```bash
# Check if venv exists
ls -la venv/bin/activate.fish

# Check if in standard location
# Supported: venv/, .venv/, env/, virtualenv/

# Manual activation to verify it works
source venv/bin/activate.fish
```

### Node version not switching

**Problem:** Node version doesn't change

**Solutions:**
```bash
# Check if .nvmrc exists
cat .nvmrc

# Check if NVM is installed
type nvm
# Should show: nvm is a function

# Manual switch to verify
nvm use (cat .nvmrc)
```

### penv command not found

**Problem:** `penv: command not found`

**Solutions:**
```bash
# Check if function exists
functions | grep penv
# Should show: penv

# Check if all_functions.fish includes penv
grep penv ~/.config/fish/functions/all_functions.fish

# Reload
source ~/.config/fish/functions/all_functions.fish
```

## Expected Results Summary

All tests should:
1. ✅ Show security prompt on first visit
2. ✅ Load variables correctly
3. ✅ Unload variables when leaving
4. ✅ Auto-load when directory is trusted
5. ✅ Auto-activate Python venv (if present)
6. ✅ Auto-switch Node version (if .nvmrc present)
7. ✅ Isolate environments between projects
8. ✅ Respond to penv commands

## Success Criteria

The Project Environment Manager is working correctly if:

- ✅ All 10 tests pass
- ✅ All checklist items verified
- ✅ No error messages during normal operation
- ✅ Variables load and unload correctly
- ✅ Security prompts appear as expected
- ✅ Trust system works reliably
- ✅ Performance is acceptable (no noticeable delay on cd)

## Performance Test

```bash
# Test performance
cd /tmp
mkdir perf-test
cd perf-test
echo 'export TEST=value' > .env

# Time the loading
time (cd .. && cd perf-test)

# Expected: < 100ms total (including prompt if not trusted)
# Expected: < 50ms if trusted and cached
```

If performance is poor:
- Check file size (should be < 1KB for typical .env)
- Check trust file size (should be reasonable)
- Check for other Fish hooks that might slow down cd

---

**Test Version:** 1.0
**Last Updated:** 2026-02-19

Happy testing! 🚀
