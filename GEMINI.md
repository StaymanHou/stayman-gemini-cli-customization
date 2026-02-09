# Gemini CLI Customization Project

This repository serves as a centralized, global configuration for the Gemini CLI. It is designed to be symlinked into `~/.gemini/` to provide consistent specialized skills and workflow-oriented commands across various development environments.

## Project Overview

*   **Purpose:** To extend and standardize the Gemini CLI agent's capabilities through custom commands and skills.
*   **Main Technologies:** Gemini CLI, TOML (for commands), Markdown (for skills), and Shell scripting.
*   **Architecture:**
    *   `commands/`: A hierarchical structure of `.toml` files defining custom CLI commands (e.g., `/workflow:task:plan`).
    *   `skills/`: A directory of specialized agent instructions (e.g., `skill-manager`), each with its own `SKILL.md`.

## Key Components

### 1. Commands (`commands/`)
Commands are defined in `.toml` files and are categorized by directory structure.
*   **Structure:** Each command file must contain a `description` and a `prompt`.
*   **Variables:** Use `{{args}}` within the prompt to pass user-provided arguments.
*   **Workflow Integration:** Many commands are designed to be sequential (e.g., `plan` -> `act` -> `close`). They often instruct the agent to create artifacts in specific project-level directories like `product/` or `project_kanban/`.

### 2. Skills (`skills/`)
Skills provide deep, procedural expertise for specific domains.
*   **Entry Point:** `skills/<skill-name>/SKILL.md`.
*   **Metadata:** Must include YAML frontmatter with `name` and `description`.
*   **Activation:** Triggered by the user or the agent via `activate_skill`.

## Development Conventions

### Adding a New Command
1.  Navigate to the appropriate subdirectory in `commands/` (e.g., `workflow/feature/`).
2.  Create a `<command-name>.toml` file.
3.  Define the `description` (for help text) and the `prompt` (the instructions sent to the model).

### Adding a New Skill
1.  Create a new directory in `skills/` using `kebab-case`.
2.  Create a `SKILL.md` file within that directory.
3.  Include the required YAML frontmatter:
    ```yaml
    ---
    name: <skill-name>
    description: <Clear activation trigger description>
    ---
    ```
4.  Provide detailed procedural instructions and best practices in the body of the markdown.

### Deployment
To apply changes globally, ensure this repository's `commands/` and `skills/` folders are symlinked to `~/.gemini/commands` and `~/.gemini/skills` respectively.

## Common Workflows

*   **Task Management:** Use `/workflow:task:plan` to initiate a discovery and planning phase, followed by `/workflow:task:act` for implementation.
*   **Feature Specification:** Use `/workflow:feature:spec` to elicit requirements and generate a feature specification file.
*   **Skill Management:** Activate `skill-manager` for assistance in creating or updating the skills within this project.
