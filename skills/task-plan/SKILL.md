---
name: task-plan
description: "Task workflow: analyze request, discover context, and create an implementation plan in workflow/wip/"
---

# Task Plan

You are an expert software engineer starting a new task.

**User Request:** {{args}}

## State Machine Context

You are in the **task** workflow at the **plan** state.

**Valid transitions from here — pick EXACTLY ONE:**

- **T2 → act (DEFAULT):** The request is a clear, bounded task and the implementation is straightforward → tell user to run `/task-act`.
- **T3 → ESCALATE to feature:spec:** ONLY if the request requires new data models, new API endpoints, architectural decisions, or multiple phases → tell user to run `/feature-spec`.
- **T4 → REDIRECT to feature:research:** ONLY if there are concrete unknowns (unfamiliar library, undocumented API, unclear performance target) that must be answered before a plan can even be written → tell user to run the research, then return.

When in doubt, choose **T2**. T3 and T4 are exceptions reserved for scope or knowledge gaps.

## Procedure

### 1. Backlog Check
Before planning, scan `workflow/backlog.md` (if it exists) for:
- `high` priority items matching this task area
- Items whose target is `task` level
- Conflicts with what's about to be planned

Mention any relevant backlog items to the user.

### 2. Context Discovery
- Read `.claude/CLAUDE.md` for project-specific rules
- Search for relevant files, existing patterns, documentation
- Understand the scope and constraints

### 3. Scope Assessment
Evaluate whether this is truly a task or should be escalated:
- If it requires new data models, API endpoints, or architectural decisions → recommend ESCALATE (T3)
- If there are unknowns that need research first → recommend REDIRECT (T4)
- Otherwise → proceed with planning

### 4. Plan Creation
Create a markdown file in `workflow/wip/<task-slug>.md` with this structure:

```markdown
# Task: <title>

**Workflow:** task
**State:** plan
**Created:** <YYYY-MM-DD>

## Requirements
- Clear goals and constraints

## Context
- Links to relevant files discovered above

## Implementation Plan
- [ ] Step 1
- [ ] Step 2
- [ ] ...

## Verification
- How to verify the changes (tests, commands)
```

### 5. Stop and Hand Off
After creating the plan:
- Present a high-level summary
- **STOP** — do NOT start implementing
- Tell the user to run `/task-act` to begin implementation
