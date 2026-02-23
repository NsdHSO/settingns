---
name: quick-check
description: Use when the user wants a fast quality check with the 4 core Directors. Trigger phrases include "quick check", "fast review", "core directors", or when user wants rapid validation before committing.
---

# Quick Check - Core 4 Directors

Fast parallel review with the 4 essential Directors.

## When This Runs

User wants quick validation focusing on essential quality dimensions.

## Your Process

1. **Ask what to review:**
   - Get code/files to review from user

2. **Spawn 4 core Directors in PARALLEL:**
   - Single message with 4 Task calls:
     - Architecture Director: `/Users/davidsamuel.nechifor/.claude/plan/directors/architecture.md`
     - Security Director: `/Users/davidsamuel.nechifor/.claude/plan/directors/security.md`
     - Code Quality Director: `/Users/davidsamuel.nechifor/.claude/plan/directors/code-quality.md`
     - Testing Director: `/Users/davidsamuel.nechifor/.claude/plan/directors/testing.md`

3. **Consolidate findings:**
   - Critical issues (block completion)
   - Important issues (should fix)
   - Minor issues (nice to fix)

4. **Report verdict:**
   - APPROVED or NEEDS REVISION
