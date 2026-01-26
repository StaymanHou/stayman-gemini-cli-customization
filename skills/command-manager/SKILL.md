---
name: command-manager
description: Expertise in creating and managing Gemini CLI custom commands (`.gemini/commands/`). Use this skill when the user wants to "create a command", "save a prompt", or "shortcut". It ensures all commands follow the correct TOML structure, directory placement (global vs. local), and argument handling best practices.
---

# Command Manager

You are an expert at configuring the Gemini CLI environment. Your goal is to help users create efficient, reusable custom commands using TOML.

## Procedure for Creating Commands

1.  **Analyze Intent:** Determine if the command should be **Project-Specific** (local) or **Global** (user).
    *   *Default:* Project-specific (`<project-root>/.gemini/commands/`).
    *   *Global:* User-level (`~/.gemini/commands/`) - Only if explicitly requested.

2.  **Determine Structure:**
    *   **Simple Command:** A file at the root of the commands directory (e.g., `audit.toml` -> `/audit`).
    *   **Namespaced Command:** A file in a subdirectory (e.g., `git/audit.toml` -> `/git:audit`).

3.  **Draft TOML Content:**
    *   **Description:** REQUIRED. A clear one-line summary.
    *   **Prompt:** The instruction for the LLM.
    *   **Argument Handling:**
        *   Use `{{args}}` for raw injection (e.g., `Review this code: {{args}}`).
        *   Use `!{command {{args}}}` for shell commands (arguments are auto-escaped).
        *   If `{{args}}` is omitted, arguments are appended to the end automatically.

4.  **Create File:**
    *   Use `write_file` to save the `.toml` file.
    *   Ensure the path matches the desired command name.

## Templates

### 1. Basic Prompt Command
Use for repeating text-based instructions.

```toml
description = "Brief description of what this command does."
prompt = """
Your detailed instructions here.

Context: {{args}}
"""
```

### 2. Shell-Integrated Command
Use for running local tools and analyzing output.

```toml
description = "Analyze the output of a local tool."
prompt = """
Please analyze the following output:

!{ tool-name {{args}} }
"""
```

### 3. File-Context Command
Use for operating on specific files provided as arguments.

```toml
description = "Review a specific file."
prompt = """
Review the following file for best practices:

@{ {{args}} }
"""
```

## Validation Rules
*   **Extension:** Must be `.toml`.
*   **Format:** Valid TOML syntax.
*   **Safety:** When using `!{...}`, ensures `{{args}}` is used for user input to prevent injection, or strictly validate input if constructed manually.
