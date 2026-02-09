# User Stories: Holistic Session Workflow Refactor

**Goal:** Improve the interaction between session management (`pause`/`resume`) and active workflows by implementing an "Explicit Handoff" mechanism.

## 1. Context-Aware Session Pause
**As a user**, when I am in the middle of a complex workflow (e.g., `feature:build`) and need to stop, I want the `/workflow:session:pause` command to identify the specific command I am currently running.

*   **Mechanism:** The `pause` command will attempt to detect the active workflow from the WIP plan's recent history or simply ask the user to confirm which command should be used to resume.
*   **Result:** The "Session Pause Note" in the WIP markdown file will explicitly store the resume command (e.g., `resume_command: "/workflow:feature:build"`).

## 2. Explicit Handoff on Resume
**As a user**, when I return to a project after a break and run `/workflow:session:resume`, I want to be told exactly how to get back into the specific workflow "mindset" I was in.

*   **Mechanism:** The `resume` command reads the `resume_command` metadata from the WIP file.
*   **Result:** The agent provides a summary of the work done and a clear call-to-action: *"To continue where you left off, please run `<resume_command>`."*

## 3. Workflow "Markers" on Demand
**As a user**, I want the workflows to remain lightweight. I do **not** want every command to write system state constantly.

*   **Mechanism:** Only the `pause` command is responsible for "stamping" the resume instruction into the WIP file. Other workflow commands (like `plan` or `act`) just focus on their specific tasks and the general status in the markdown.

## 4. Multi-WIP Awareness
**As a user**, if I have multiple active WIP files, I want the `resume` command to let me pick which one to resume and then provide the correct handoff command for that specific file.

*   **Result:** "I found two active tasks: 'Login Page' (Feature Build) and 'DB Migration' (Refactor). Which one would you like to resume?" -> "Run `/workflow:feature:build` to continue 'Login Page'."
