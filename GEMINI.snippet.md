## Workflow System

This machine has a state-machine-driven workflow system installed (specialized skills). Projects that use it keep transient state in `workflow/` and strategic product docs in `docs/product/`.

**Four workflows driven by intent-matched skills:**

- **Product** — `product-vision` (new initiative) → roadmap → research → arch → wbs → context
- **Feature** — `feature-spec` (complex) or `feature-plan` (small/simple) → build/verify loop → ship → finalize
- **Task** — `task-plan` → act → close (atomic changes, bug fixes)
- **Incident** — `incident-report` → triage → investigate → mitigate → resolve

Use `session-start` to get routed to the appropriate workflow entry point. Cross-session continuity is handled via `session-pause` and `session-resume`.

**Per-project layout:**
```
docs/product/          # vision.md, roadmap.md, research.md, arch.md, wbs.md, context.md
workflow/wip/          # active feature/task/incident items
workflow/backlog.md    # SURFACE discoveries
workflow/archive/      # completed items
```

## Pre-risky-action checklist (GLOBAL)

**Before running any destructive-capable CLI** — scaffolders (`create-*`, `npm create *`), initializers (`*-init`, `yo *`), codegen tools that write to the working directory, or anything with an `--overwrite` / `--force` flag — run through this checklist:

1. **Git safety net.** If the directory is **not** a git repo, initialize one and commit the current state **before** running the tool: `git init && git add -A && git commit -m "pre-scaffold baseline"`. If it **is** a repo, confirm the working tree is clean (no uncommitted changes that could be destroyed) or `git stash` first.
2. **Read the flags.** If the tool has an `--overwrite`, `--force`, or similar flag and you haven't used it before, run `<tool> --help` first. Flag names lie — `--overwrite=ignore` in some tools means "silently replace existing files," not "skip them." One extra tool call is cheap.
3. **Treat all template/scaffold generators as destructive** until proven otherwise. Non-empty target directories are the danger zone.

## Telegram notify-human (GLOBAL)

**ALWAYS activate the `notify-human` skill before requesting human input** — any substantive question, decision point, review request, verification checklist, or any moment the user might have walked away from the terminal. This is non-negotiable across all projects and contexts.

- Requires `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` environment variables. If unset, the skill no-ops silently.
- **Do NOT notify for:** trivial yes/no confirmations during routine steps, or tool permission prompts.
