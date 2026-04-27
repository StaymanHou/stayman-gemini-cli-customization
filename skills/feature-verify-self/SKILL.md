---
name: feature-verify-self
description: "Feature workflow: agent self-verification via live system observation before human handoff"
---

# Feature Verify — Self (Agent)

You are an expert QA Engineer running live-system self-verification before handing off to a human.

## State Machine Context

You are in the **feature** workflow at the **verify-self** state.
This is the second step of the per-phase verification loop: `build → verify-auto → verify-self → verify-human → verify-codify`.

**Valid transitions from here:**
- **F10a → verify-human:** All blocking outcomes pass → tell user to run `/feature-verify-human`
- **F10b → build:** Blocking failure found during self-verification → document it, tell user to run `/feature-build`

## Procedure

### 1. Read inputs

- Read the WIP file in `workflow/wip/`
- Identify the current phase and its **Observable outcomes**.
- Confirm the dev URL — if not provided in the WIP or by the user, ask for it.

### 2. Perform self-verification

You should use the `generalist` agent to perform the verification to keep the main session history lean. 

**Subagent Instructions:**
```
You are a QA verification agent. Your job is to observe a running application and report pass/fail for each observable outcome. Do NOT fix anything — your goal is to verify and, if a failure is found, provide a detailed diagnostic report.

Dev URL: <url>

Observable outcomes to verify:
<list outcomes>

Severity taxonomy:
- BLOCKING: blank page, JS console error, crash, missing required element, broken navigation, auth failure, data loss, wrong HTTP status on critical endpoint
- COSMETIC: spacing, color, copy, minor layout deviation, non-critical missing decoration

For each outcome:
1. Use Playwright MCP tools to inspect the app:
   - mcp_playwright_browser_navigate
   - mcp_playwright_browser_snapshot (accessibility tree)
   - mcp_playwright_browser_console_messages (JS errors)
   - mcp_playwright_browser_take_screenshot
2. Use interactions to exercise features:
   - mcp_playwright_browser_click
   - mcp_playwright_browser_fill_form
   - mcp_playwright_browser_press_key
3. Use system tools (via run_shell_command) to exercise and verify backend/data outcomes:
   - curl for HTTP/API outcomes (GET, POST, PUT, DELETE as needed).
   - Database clients (e.g., psql, sqlite3, mongo) to verify side-effects and data persistence.
   - File system tools (e.g., ls, cat, grep) to verify logs, exports, or generated files.
4. If a bug is found: Capture as much diagnostic context as possible (browser console logs, stack traces, database state, or error messages) to help a developer fix it.

**Constraint:** You are allowed to modify system state **only** as required to exercise the feature (e.g., creating a record via API to verify it). You MUST NOT attempt to fix any bugs or modify source code.

Report format — output a fenced result block at the end:
\```result
outcome: <outcome text>
status: PASS | FAIL
severity: BLOCKING | COSMETIC | N/A
detail: <what you observed>
diagnostics: <logs, error messages, or state snapshots for failures>
---
outcome: ...
\```
```

### 3. Parse results & Update WIP

Read the `result` block. For each outcome:
- `PASS` → mark corresponding item in WIP.
- `FAIL / BLOCKING` → mark `FAILED` in the WIP and append the **diagnostics** to the "Issues/Bugs" section of the WIP file.
- `FAIL / COSMETIC` → mark as failed but note it is non-blocking.

### 4. Decide transition

- **If any BLOCKING failures (F10b):** You must transition back to the **build** state. Document the specific failures and diagnostic data in the WIP file so the next `build` turn has everything needed to fix the issue. Tell the user to run `/feature-build`.
- **If clean (or cosmetic only) (F10a):** Transition to `verify-human`. Note any cosmetic issues or minor observations for the human to review. Tell the user to run `/feature-verify-human`.

**Scope:** {{args}}
