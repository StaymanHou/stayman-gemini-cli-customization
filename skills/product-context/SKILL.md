---
name: product-context
description: "Product workflow: generate the project's GEMINI.md context file and transition to feature workflow"
---

# Product Context

You are an expert Technical Writer and Software Architect generating the project context file.

## State Machine Context

You are in the **product** workflow at the **context** state.
This is the **terminal state** of the product workflow.

**Valid transitions from here:**
- **P10 → EXIT → feature:plan:** Always. Start the first milestone from the roadmap.

## Procedure

### 1. Gather Inputs
Read each product artifact from `docs/product/`:
- `vision.md` — purpose, audience, metrics
- `roadmap.md` — phases, milestones
- `research.md` — tech stack, trade-offs
- `arch.md` — system design, data flow
- `wbs.md` — work packages, dependencies

### 2. Generate Project GEMINI.md
Create or update `GEMINI.md` in the project root with the following structure. **Note: Docker setup and usage are MANDATORY and must be the first instruction.**

```markdown
# <Project Name>

## Project Overview
<Summary from vision>

## Tech Stack
<Key technologies from architecture>

## Project Structure
<Generated directory tree of key directories>

## Getting Started
### 1. Docker Environment (MANDATORY)
Setting up the Docker development environment is the **required first step**.
- **Prerequisite:** Ensure the Docker daemon is running (Hard-Blocker).
- **Port Conflicts:** NEVER stop existing containers or local services to resolve port conflicts. Instead, remap this project's host ports (e.g., via `.env`) to avoid collisions. Assume concurrent development of other projects.
- **Setup:** `docker compose up -d --build`
- **Verification:** `docker compose ps` to ensure all services are healthy.

### 2. Local Configuration
<Any .env setup or local-only steps needed before Docker can run>

## Development Workflow
**CRITICAL: All development commands (tests, linting, migrations, etc.) MUST be executed inside the Docker container(s).**

### Standard Commands
- **Enter Container:** `docker compose exec <service> bash`
- **Run Tests:** `docker compose exec <service> <test-cmd>`
- **Linting:** `docker compose exec <service> <lint-cmd>`
- **Logs:** `docker compose logs -f <service>`

## Current Phase
<Active roadmap phase and its goals>

## Key Decisions
<Important architectural and product decisions with rationale>

## Product Docs
See `docs/product/` for vision, roadmap, research, arch, and WBS.
```

### 3. Finalize Product Artifacts
The product docs in `docs/product/` are **long-lived** — do NOT move them to `workflow/archive/`. They remain in place as the canonical source for vision, roadmap, research, arch, and WBS.

Write `docs/product/context.md` recording the context-generation step:

```markdown
# Product Context (Generated)

**Workflow:** product
**State:** context (complete)
**Generated:** <YYYY-MM-DD>

GEMINI.md was generated from the artifacts in this directory.
```

Update the state line in each of `vision.md`, `roadmap.md`, `research.md`, `arch.md`, `wbs.md` to `(complete)` if not already set.

### 4. Transition to Feature Workflow
- Identify the first milestone from `docs/product/roadmap.md`
- Tell the user: "Product planning is complete. Start the first feature from the roadmap by running `/feature-spec` (or `/feature-plan` if it's small/simple)."
- Evaluate the first milestone against the small/simple criteria to recommend the right entry point

**Additional Instructions:** {{args}}
