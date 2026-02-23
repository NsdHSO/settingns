---
name: directors
description: Use when the user wants to run Directors verification review on implemented code. Trigger phrases include "run directors", "directors review", "verify with directors", or when user wants parallel quality review from specialized Directors.
---

# Directors Verification Review

Spawn relevant Directors as parallel Task agents to review implementation.

## When This Runs

User has implemented code and wants verification review from specialized Directors.

## Your Process

1. **Ask what to review:**
   - "What code should I review?" or auto-detect from recent changes

2. **Select relevant Directors based on work type:**
   - Always include: Architecture, Security, Code Quality, Testing
   - Frontend work: +Frontend, Accessibility, Performance
   - Backend work: +Backend, API Design, Error Handling
   - Database work: +Database, Data Design
   - Infrastructure work: +Infrastructure, DevOps, Deployment, Scalability
   - Full-stack: Combine relevant Directors (typically 10-12)

3. **Spawn ALL selected Directors in PARALLEL:**
   - Use single message with multiple Task tool calls
   - Each Director uses: `/Users/davidsamuel.nechifor/.claude/plan/directors/<role>.md`
   - Each reviews independently

4. **Consolidate findings:**
   - Group by severity (CRITICAL/IMPORTANT/MINOR)
   - List blocking issues first
   - Include file:line references

5. **Report overall status:**
   - APPROVED (no critical issues)
   - NEEDS REVISION (critical issues found)
   - REJECTED (fundamental problems)
