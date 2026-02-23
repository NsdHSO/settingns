---
name: itIsYours
description: Use when the user wants to run a complete multi-role review with TA, Owner, and Directors. Trigger phrases include "run full review", "complete review", "itIsYours", or when user wants comprehensive quality check during planning or verification phases.
---

# Complete Multi-Role Review

Run comprehensive review with TA, Owner, and parallel Directors.

## When This Runs

User requests complete review of design (planning) or implementation (verification).

## Your Process

1. **Determine review phase:**
   - Ask user: "What should I review? (planning/design or implemented code)"

2. **If planning/design phase:**
   - Read the design/requirements from user
   - Spawn TA review agent:
     - Use Task tool, subagent_type: "general-purpose"
     - Provide design/plan to review
     - Reference template: `/Users/davidsamuel.nechifor/.claude/plan/ta/technical-analysis-template.md`
     - Ask agent to analyze technical feasibility, architecture, technology choices
   - Spawn Owner review agent:
     - Use Task tool, subagent_type: "general-purpose"
     - Provide requirements/goals
     - Reference template: `/Users/davidsamuel.nechifor/.claude/plan/owner/requirements-review-template.md`
     - Ask agent to validate requirements, scope, success criteria, user needs
   - Report both findings with decisions (APPROVED/NEEDS REVISION/REJECTED)

3. **If implemented code phase:**
   - Identify work type (frontend/backend/database/full-stack/infrastructure)
   - Select 4-8 relevant Directors:
     - Always: Architecture, Security, Code Quality, Testing
     - Frontend: +Frontend, Accessibility, Performance
     - Backend: +Backend, API Design, Error Handling
     - Database: +Database, Data Design
     - Infrastructure: +Infrastructure, DevOps, Deployment, Scalability
   - Spawn ALL Directors in PARALLEL (single message with multiple Task calls)
   - Each Director references: `/Users/davidsamuel.nechifor/.claude/plan/directors/<role>.md`
   - Consolidate findings by severity (CRITICAL/IMPORTANT/MINOR)
   - Report overall status: APPROVED/NEEDS REVISION/REJECTED

## Output Format

Present results with:
- Each role's verdict
- Critical issues first (blocking)
- Specific file:line references
- Overall status
