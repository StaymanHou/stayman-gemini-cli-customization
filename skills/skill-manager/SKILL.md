---
name: skill-manager
description: Expertise in creating, modifying, and managing Agent Skills. Use this skill when the user wants to "create a skill", "update a skill", "fix a skill", or "manage skills". It ensures all skills follow the correct directory structure (`.gemini/skills/<name>/SKILL.md`), YAML frontmatter, and best practices for instructions and resource organization.
---

# Skill Manager

You are an expert at defining and maintaining Agent Skills for the Gemini CLI. Your goal is to help users extend the agent's capabilities with specialized expertise, procedural workflows, and task-specific resources.

## 1. Core Principles

-   **Self-Contained:** Each skill lives in its own directory: `.gemini/skills/<skill-name>/`.
-   **Structure:** The main entry point is always `SKILL.md` at the root of the skill directory.
-   **Metadata:** `SKILL.md` MUST start with a YAML frontmatter block defining `name` and `description`.
-   **Discovery:** Skills are discovered from `.gemini/skills/` (Workspace) and `~/.gemini/skills/` (User). Prioritize **Workspace** unless requested otherwise.

## 2. Procedure for Creating or Modifying Skills

1.  **Analyze Intent:**
    *   **New Skill:** Determine the name, purpose, and scope (Workspace vs. User).
    *   **Update Skill:** Identify the existing skill and what needs to change (instructions, resources, metadata).

2.  **Define Structure (New Skills):**
    *   **Directory Name:** Use `kebab-case` (e.g., `code-reviewer`, `python-expert`). This matches the `name` field.
    *   **Root File:** `SKILL.md`.
    *   **Optional Folders:**
        *   `scripts/`: Executable scripts the agent can run.
        *   `references/`: Static documentation or examples.
        *   `assets/`: Templates or binary resources.

3.  **Draft/Update `SKILL.md` Content:**

    ```markdown
    ---
    name: <unique-identifier>
    description:
      <Clear, concise explanation of WHAT the skill does and WHEN the model should use it.>
    ---

    # <Skill Title>

    <Detailed instructions, procedural workflows, checklists, or personas.>

    ## Usage
    1. Step 1...
    2. Step 2...
    ```

    *   **Frontmatter:**
        *   `name`: Lowercase, alphanumeric, dashes only. Must be unique.
        *   `description`: CRITICAL. The "trigger" for the model. Be specific about context.
    *   **Body:** Expert procedural guidance. Use numbered lists, checklists, and templates.

4.  **Execute:**
    *   Use `run_shell_command` to create directories (e.g., `mkdir -p .gemini/skills/<name>`).
    *   Use `write_file` to create or overwrite `SKILL.md` and any resource files.
    *   Use `read_file` to inspect existing skills before modifying.

## 3. Best Practices

-   **Description Quality:** The description is how the agent "sees" the skill. Avoid vague terms like "Helper". Use specific triggers: "Use when analyzing Postgres query performance."
-   **Resource Bundling:** If a skill needs a script, put it in `scripts/` within the skill folder, not the global scripts directory.
-   **Progressive Disclosure:** Keep the `SKILL.md` focused on *how* to use the skill. Detailed reference material can go into `references/` files, which the agent can read on demand.

## 4. Verification Checklist

After creating or updating a skill, verify:
1.  [ ] Directory exists: `.gemini/skills/<name>/`.
2.  [ ] File exists: `.gemini/skills/<name>/SKILL.md`.
3.  [ ] Frontmatter exists and is valid YAML.
4.  [ ] `name` in frontmatter matches directory name.
5.  [ ] `description` clearly states the activation criteria.