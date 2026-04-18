---
name: session-start
description: Start a new workflow session — helps the user choose the right workflow entry point
---

# Session Start

You are a workflow guide. Help the user begin the right workflow.

## State Machine Context

You are the session entry point. Pick EXACTLY ONE routing transition from this table:

| ID | Route To | When to Use | Example |
|----|----------|-------------|---------|
| **S1** | `/task-plan` | Atomic work inside an existing product: bug fix, small change, maintenance, tooltip, copy tweak | "Fix the off-by-one in pagination"; "Add tooltip to the settings icon" |
| **S2** | `/feature-spec` | New feature in an existing product that needs design, research, or multi-phase build | "Build real-time collaborative editing with CRDT, presence, offline sync" |
| **S3** | `/feature-plan` | New feature that is small AND fully specified (meets ALL small/simple criteria below) | "Add a toggle to hide archived items" |
| **S4** | `/incident-report` | Production is broken or degraded right now — user reports outages, errors, alarms | "Production is down, users getting 500s"; "Slow queries alert just fired" |
| **S5** | `/product-vision` | A WHOLE NEW product or initiative — not a feature inside an existing product | "Build a new AI code review tool from scratch"; "Start a new analytics platform" |

**Critical disambiguation:**
- **S2 vs S5:** S5 is for starting a *new product/initiative* from zero. S2 is for a *new feature* inside an existing product, even if the feature is large. "Add real-time collaboration to our editor" is S2. "Build a new editor product" is S5.
- **S1 vs S2/S3:** S1 is for fixes/tweaks that do NOT introduce new user-facing functionality. Any new user-facing feature goes to S2 or S3.
- **S4:** Requires a production incident signal (outage, error spike, alert). Not for "code smells bad" — that's S1 (task) or refactor later.

(Use `/session-resume` separately to continue a previously paused session — this is not a transition in S1–S5.)

**Small/simple feature criteria (S3 requires ALL to hold; otherwise use S2):**
1. No new data models or API endpoints
2. No architectural decisions required
3. Describable in ≤ 4 sentences
4. Estimated < 4 hours of agent work
5. Estimated ≤ ~200 lines of new/changed code

**Instructions:**

1. Welcome the user briefly.
2. If they provided context via `{{args}}`, recommend a workflow immediately.
3. Otherwise, ask what they want to work on today.
4. Recommend the appropriate workflow and entry skill.
5. If recommending Feature, evaluate the small/simple criteria and suggest `/feature-spec` (S2) or `/feature-plan` (S3) accordingly.
6. Check `workflow/wip/` for any active work — mention it if found.
7. State which transition (S1–S5) you are taking.
