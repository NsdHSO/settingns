# MUST
YOU will address me with MY KING ENGINEER
Never create commits or push to git.
Do not offer to commit or push. The user will handle all git operations manually.
ONLY IF I REQUEST like: PLS commit 
and you must to make this :
- **to commit every file separate 1 file per           
  commit and what I make there like commit message and     
  push it **


Never stage files in docs/* directory.

NEVER added this footer
for commit or another else	
Co-Authored-By: Claude Opus 4.6
   <noreply@anthropic.com>"

# Multi-Role Review Framework

## MUST - Planning Phase Reviews
Before finalizing any design during brainstorming:
- MUST run TA (Technical Analysis) review of technical approach
- MUST run Owner review of requirements alignment
- CANNOT proceed to writing-plans until both approve
- Document TA/Owner findings in docs/plans/teammates/<date>-<topic>-planning.md

## MUST - Verification Phase Reviews
Before claiming any work is complete:
- MUST spawn Directors as parallel Task agents for verification
- Select relevant Directors based on work type (frontend → Frontend Director, etc.)
- Each Director reviews independently using their /Users/davidsamuel.nechifor/.claude/plan/directors/<role>.md template
- CANNOT mark work complete until critical issues are resolved
- Document Director findings in docs/plans/teammates/<date>-<topic>-verification.md

## Review Documentation
- All review documents go in docs/plans/teammates/ directory
- NEVER commit docs/plans/teammates/* (must be in .gitignore)
- Keep review docs for reference but don't track in git

## Director Selection
Choose Directors relevant to the work:
- Always include: Architecture, Security, Code Quality, Testing
- Add domain-specific: Frontend/Backend/Database/Infrastructure as needed
- Add process-specific: Documentation, Standards, Accessibility as needed

# Agent Output Location

ALL agents must write their plans and outputs to:
**docs/plans/teammates/**

This includes:
- Review agents (TA, Owner, Directors, etc.)
- Planning agents
- Any autonomous agent outputs
- Implementation plans
- Analysis reports

Format: `docs/plans/teammates/<date>-<topic>-<agent-name>.md`

MUST add to .gitignore:
```
docs/plans/teammates/
```

# Collaborative Implementation Team (80 Agents)

## Automatic Triggering
After review agents complete (directors-agent, ta-agent, owner-agent, full-review-agent):
- PostToolUse hook reads review output from docs/plans/teammates/
- If CRITICAL or IMPORTANT issues found → automatically spawn Team Lead Orchestrator-1
- Team Lead coordinates 60 Engineers + 8 TAs + 10 Review Owners to implement fixes

## Manual Triggering
Invoke: "Team Leads, implement findings from [review-file].md"
- Team Lead reads specified review file
- Same collaborative workflow as automatic triggering

## Team Structure (80 Agents Total)
- **2 Team Lead Orchestrators** (team-lead-orchestrator-1, team-lead-orchestrator-2)
- **8 TA Specialists** (ta-specialist-1 through ta-specialist-8)
  - TA-1: Architecture & Design Patterns
  - TA-2: Testing & Test Design
  - TA-3: Performance & Optimization
  - TA-4: Code Patterns & Best Practices
  - TA-5: Security & Vulnerabilities
  - TA-6: Database & Data Modeling
  - TA-7: API Design & Integration
  - TA-8: DevOps & Infrastructure
- **60 Engineers** (engineer-1 through engineer-60)
  - Massive parallel implementation capacity
  - Can swarm on complex tasks (4-10 Engineers per complex task)
- **10 Review Owners** (review-owner-1 through review-owner-10)
  - Comprehensive continuous validation + final verification

## Team Output Organization
All team outputs organized by role:
- Team Leads: docs/plans/teammates/team-leads/
- TAs: docs/plans/teammates/ta/
- Engineers: docs/plans/teammates/engineers/
- Review Owners: docs/plans/teammates/review-owners/

## .gitignore Requirements
MUST add to project .gitignore:
```
docs/plans/teammates/team-leads/
docs/plans/teammates/ta/
docs/plans/teammates/engineers/
docs/plans/teammates/review-owners/
```

## Team Workflow
1. **Planning:** Team Lead reads review findings → 8 TAs analyze approach in parallel → plan refined
2. **Implementation:** 60 Engineers work in parallel → 8 TAs monitor → 10 Review Owners validate continuously
3. **Verification:** 10 Review Owners final validation → revision loop if needed → approval
4. **Completion:** Team Lead synthesizes results → outputs orchestration report

## Scalability Benefits
With 80 agents:
- Can handle 60+ parallel tasks simultaneously
- 8 TAs provide comprehensive technical coverage
- 10 Review Owners ensure thorough validation
- 2 Team Leads for redundancy and load balancing
