---
name: ta-review
description: Use when the user wants Technical Analysis review of a design or approach during planning. Trigger phrases include "TA review", "technical analysis", "review technical approach", or when validating architecture decisions before implementation.
---

# Technical Analysis Review

Review technical approach during planning phase.

## When This Runs

User is in planning/design phase and wants technical validation before implementing.

## Your Process

1. **Get design/plan to review:**
   - Ask user for the design, architecture, or technical approach

2. **Spawn TA review agent:**
   - Use Task tool, subagent_type: "general-purpose"
   - Provide design/plan
   - Reference: `/Users/davidsamuel.nechifor/.claude/plan/ta/technical-analysis-template.md`
   - Ask agent to analyze:
     - Technical feasibility
     - Architecture decisions
     - Technology choices
     - Design patterns
     - Performance considerations
     - Security considerations

3. **Report TA findings:**
   - Decision: APPROVED / APPROVED WITH CHANGES / NEEDS REVISION / REJECTED
   - Technical concerns identified
   - Required changes (if any)
   - Recommendations
