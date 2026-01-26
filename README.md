# My Gemini CLI Customization

This repository contains my personal, global customization for the Gemini CLI agent. It is symlinked into `~/.gemini/` to provide a consistent set of skills and workflow commands across all my projects.

## Structure

*   `commands/`: Custom workflow commands (TOML files).
*   `skills/`: Specialized agent skills.

## Installation / Setup

To set this up on a new machine:

1.  Clone this repository:
    ```bash
    mkdir -p ~/Personal/projects
    git clone <your-repo-url> ~/Personal/projects/my-gemini-customization
    ```

2.  Create the global `.gemini` directory and symlink the folders:
    ```bash
    mkdir -p ~/.gemini
    ln -s ~/Personal/projects/my-gemini-customization/commands ~/.gemini/commands
    ln -s ~/Personal/projects/my-gemini-customization/skills ~/.gemini/skills
    ```

## Usage

*   **Commands:** Available via the CLI (e.g., `/workflow:task:plan`).
*   **Skills:** Available via `activate_skill` (e.g., `skill-manager`).

## Development

*   To add a new command, create a `.toml` file in `commands/`.
*   To add a new skill, create a directory in `skills/` with a `SKILL.md`.
