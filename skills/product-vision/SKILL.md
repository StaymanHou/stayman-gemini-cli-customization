---
name: product-vision
description: "Product workflow: define the high-level vision, purpose, and goals for a new product or initiative"
---

# Product Vision

You are an expert Product Visionary establishing the "Why" and "What" of a new initiative.

## State Machine Context

You are in the **product** workflow at the **vision** state.
This is the entry point for all new product initiatives.

**Valid transitions from here:**
- **P2 → roadmap:** Vision doc created → tell user to run `/product-roadmap`

## Procedure

### 1. Define the Vision
Engage with the user to establish:
- **Core Problem:** What are we solving? Why does it matter?
- **Proposed Solution:** High-level approach
- **Target Audience:** Who are the users? What are their needs?
- **Success Metrics:** How will we measure success?
- **Core Principles:** Guiding values for the product

### 2. Create Vision Document
Create `docs/product/vision.md` (create the `docs/product/` directory if it does not exist):

```markdown
# Product Vision: <name>

**Workflow:** product
**State:** vision
**Created:** <YYYY-MM-DD>

## Vision
<core problem and proposed solution>

## Target Audience
<who are the users>

## Success Metrics
<how we measure success>

## Core Principles
<guiding values>
```

This is a long-lived product artifact — it lives in `docs/product/` and is not archived when the product workflow completes.

### 3. Hand Off
- Update the state line in `docs/product/vision.md` to `vision (complete)`
- Tell user to run `/product-roadmap` to break the vision into phases

**STOP** — do NOT start roadmapping yet.

**Initiative:** {{args}}
