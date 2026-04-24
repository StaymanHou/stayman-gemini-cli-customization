# Gemini CLI Customization Project

This repository serves as a centralized, global configuration for the Gemini CLI. It provides consistent specialized skills, state-machine workflows, and safety standards across all development environments.

## Project Overview

*   **Purpose:** To extend and standardize the Gemini CLI agent's capabilities through custom skills and orchestrated state-machine workflows.
*   **Main Technologies:** Gemini CLI Skills (Markdown + YAML), state-machine transitions (YAML), and automated setup (Bash).
*   **Architecture:**
    *   `skills/`: A directory of 30+ specialized agent skills (e.g., `task-plan`, `feature-spec`).
    *   `workflow/`: Contains `transitions.yaml`, the state-machine source of truth for all workflows.
    *   `GEMINI.snippet.md`: A template for global context, including workflow descriptions and safety checklists.

## Key Components

### 1. Skills (`skills/`)
Skills provide deep, procedural expertise for specific phases of a workflow (e.g., planning, building, verifying).
*   **Entry Point:** `skills/<skill-name>/SKILL.md`.
*   **Activation:** Triggered by the user's intent matching the `description` in the YAML frontmatter.
*   **Standardization:** All skills must reference the state machine context and use `notify-human` before requesting user input.

### 2. Workflow Transitions (`workflow/transitions.yaml`)
Defines the valid paths between skills for Task, Feature, Product, and Incident workflows. Skills use these IDs (e.g., `T2`, `F7`) to guide the user to the next logical step.

## Development Conventions

### Adding a New Skill
1.  Create a new directory in `skills/` using `kebab-case`.
2.  Create a `SKILL.md` file within that directory.
3.  Include required YAML frontmatter:
    ```yaml
    ---
    name: <skill-name>
    description: <Clear activation trigger description>
    ---
    ```
4.  Provide detailed procedural instructions and link to the appropriate transition in `workflow/transitions.yaml`.
5.  Run `./install.sh` to symlink the new skill.

### Environment & Infrastructure
*   **Port Conflicts:** NEVER stop existing local services to resolve port conflicts. Remap host ports via `.env` or overrides to avoid collisions.
*   **Docker Hard-Blocker:** If Docker is required but unreachable, STOP and ask the user to start it. Never fall back to host OS commands for project-standard tools.

## Deployment & Sync

The `./install.sh` script is the primary deployment tool:
1.  **Skill Symlinks:** Creates per-skill symlinks from `skills/*` to `~/.gemini/skills/`.
2.  **Global Context Sync:** Injects the content of `GEMINI.snippet.md` into `~/.gemini/GEMINI.md` within a managed block (`<!-- BEGIN gemini-workflow-system -->`).

## Common Workflows

*   **Session Entry:** "Start a new task" or "Plan a feature" triggers `session-start` for routing.
*   **Task/Feature Flow:** "Ready to implement" or "Run automated tests" triggers the appropriate follow-up skill.
*   **Skill Management:** Activate `skill-manager` for assistance in creating or updating skills.
