> **Reference doc.** This describes the product workflow state machine. The workflow is driven by individual skills (task-plan, task-act, etc.); this document is the human-readable overview.


# Product Workflow Orchestrator

You manage the **product workflow** — a 6-state machine for strategic decomposition of new products/initiatives.

## State Machine

```
vision → roadmap → research ⇄ arch → wbs → context → EXIT (→ feature:plan)
                 ↑    ↓         ↑   ↓
                 └────┘         └───┘
```

Back-loops exist between research↔roadmap, research↔arch, and wbs↔arch.

### States and Skills
| State | Skill | Purpose |
|-------|-------|---------|
| vision | `/product-vision` | Define purpose, audience, success metrics |
| roadmap | `/product-roadmap` | Phase milestones with exit criteria |
| research | `/product-research` | Technical solution evaluation |
| arch | `/product-arch` | System design for current phase |
| wbs | `/product-wbs` | Work breakdown into packages |
| context | `/product-context` | Generate CLAUDE.md, transition to features |

### Full Transition Table

| ID | From → To | Condition | Type |
|----|-----------|-----------|------|
| P1 | ENTRY → vision | Always | entry |
| P2 | vision → roadmap | Vision doc created | forward |
| P3 | roadmap → research | Roadmap has phases | forward |
| P4 | research → roadmap | Research invalidates assumptions | back-loop |
| P5 | research → arch | Research complete, roadmap holds | forward |
| P6 | arch → research | Architecture reveals unknowns | back-loop |
| P7 | arch → wbs | Architecture defined | forward |
| P8 | wbs → arch | WBS reveals architectural gaps | back-loop |
| P9 | wbs → context | WBS complete | forward |
| P10 | context → EXIT→feature:plan | Always | exit |
| P11 | SURFACE-IN → wbs | Lower-level discovers new work | surface-in |
| P12 | SURFACE-IN → arch | Lower-level discovers arch gap | surface-in |

## Your Role

1. **Linear progression with back-loops.** The happy path is vision→roadmap→research→arch→wbs→context. Back-loops happen when later stages reveal problems in earlier ones.
2. **Enforce back-loop guards.** Every back-loop must document *what changed and why* before re-entering the earlier state. This prevents infinite loops.
3. **Handle SURFACE-IN (P11, P12).** When lower-level workflows surface discoveries, route to wbs (new work) or arch (architectural gap).
4. **Terminal transition (P10).** Context always exits to feature:plan. Help the user identify the first milestone and evaluate small/simple criteria for the right feature entry point.
5. **Invoke `/notify-human`** before any human decision point.
6. **Support pause/resume** via `/session-pause` and `/session-resume`.
