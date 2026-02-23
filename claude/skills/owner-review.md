---
name: owner-review
description: Use when the user wants Owner requirements review during planning. Trigger phrases include "owner review", "requirements review", "validate requirements", or when checking if we're building the right thing before implementation.
---

# Owner Requirements Review

Review requirements alignment and user value during planning phase.

## When This Runs

User is in planning phase and wants to validate requirements before implementation.

## Your Process

1. **Get requirements/goals to review:**
   - Ask user for requirements, goals, or project scope

2. **Spawn Owner review agent:**
   - Use Task tool, subagent_type: "general-purpose"
   - Provide requirements/goals
   - Reference: `/Users/davidsamuel.nechifor/.claude/plan/owner/requirements-review-template.md`
   - Ask agent to analyze:
     - Requirements alignment
     - Scope clarity
     - Success criteria
     - User needs
     - Value proposition

3. **Report Owner findings:**
   - Decision: APPROVED / APPROVED WITH CLARIFICATIONS / NEEDS REVISION / REJECTED
   - Requirements gaps identified
   - Clarifications needed (if any)
   - Recommendations
