# Gemini CLI Workflow Customizations

State-machine-driven workflow skills for the Gemini CLI. Ported from [my-claude-code-customization](https://github.com/StaymanHou/stayman-claude-code-customization).

## Structure

```
.
├── install.sh              # Idempotent per-skill symlink setup
├── GEMINI.md               # Repo-level instructions
├── skills/                 # 30+ Agent Skills (state machine phases)
├── workflow/
│   └── transitions.yaml    # 63 state transitions (source of truth)
├── docs/workflows/         # Human-readable workflow reference docs
└── tests/                  # End-to-end transition tests against gemini -p
    ├── run-tests.sh
    ├── lib/verify.sh
    ├── scenarios/          # YAML scenarios (task, feature, product, incident, session)
    ├── fixtures/           # Shared GEMINI.md and per-scenario WIP files
    └── results/            # Gitignored test output
```

## Workflow Groups

Five workflows, each a state machine invoked phase-by-phase via skills:

| Group | Skills | Purpose |
|-------|--------|---------|
| **task** | `task-plan` → `task-act` → `task-close` | Atomic work items: bug fixes, small changes |
| **feature** | `feature-spec` → `feature-research` → `feature-plan` → `feature-build` ↔ `feature-verify-auto`/`verify-human`/`verify-codify` → `feature-ship` → `feature-finalize` → `feature-refactor` | Multi-phase features with per-phase verification loop |
| **product** | `product-vision` → `product-roadmap` → `product-research` → `product-arch` → `product-wbs` → `product-context` | Strategic decomposition from vision to work packages |
| **incident** | `incident-report` → `incident-triage` → `incident-investigate` / `incident-mitigate` → `incident-resolve` | Production incident response |
| **session** | `session-start`, `session-pause`, `session-resume`, `session-reflect`, `session-store-learning` | Cross-workflow entry points and lifecycle operations |

See [`workflow/transitions.yaml`](workflow/transitions.yaml) for the authoritative transition list, and [`docs/workflows/`](docs/workflows/) for human-readable overviews.

## Installation

```bash
git clone git@github.com:StaymanHou/stayman-gemini-cli-customization.git ~/Personal/projects/my-gemini-customization
cd ~/Personal/projects/my-gemini-customization
./install.sh
```

`install.sh` creates a symlink from `~/.gemini/skills/<name>` to each skill in this repo. It auto-migrates the legacy whole-directory `~/.gemini/skills` symlink and removes the retired `~/.gemini/commands` symlink.

## Configuration

### Global notify-human enforcement

`~/.gemini/GEMINI.md` enforces the `notify-human` skill before any user-facing question. To enable notifications globally, export these in your shell profile (e.g., `~/.zshrc` or `~/.bashrc`):

```bash
export GEMINI_CLI_TELEGRAM_BOT_TOKEN=...
export GEMINI_CLI_TELEGRAM_CHAT_ID=...
```

If unset, the skill no-ops silently.

### Skills configuration

Ensure experimental skills are enabled in `~/.gemini/settings.json`:

```json
{
  "experimental": { "skills": true },
  "includeDirectories": ["~/.gemini/skills"]
}
```

## Usage

Skills are activated automatically by their description. In an interactive Gemini CLI session:

```
> I need to fix a null pointer bug in the login flow
# Gemini routes to session-start, which recommends task-plan

> Plan out a new real-time collaboration feature
# Gemini routes to feature-spec
```

## Testing

Run all 63 transition tests:

```bash
./tests/run-tests.sh
```

Options:

```bash
./tests/run-tests.sh --dry-run                    # Enumerate without running
./tests/run-tests.sh --group task                 # Single workflow group
./tests/run-tests.sh --id T2,F7,I2                # Specific transitions
./tests/run-tests.sh --model gemini-2.5-flash-lite  # Override model
./tests/run-tests.sh --timeout 120                # Per-invocation timeout (sec)
```

Each scenario invokes `gemini -p` in plan (read-only) mode with a shared testing system prompt requiring the model to emit `TRANSITION: <id> (<from> → <to>)`. Verification first looks for a structured match on the id, falls back to fuzzy matching on `contains_any`, and flags `not_contains` guards.

Results are written to `tests/results/run-<timestamp>.json` (gitignored).

## Development

### Adding a skill

1. Create `skills/<name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: <name>
   description: <activation trigger — this is what Gemini matches against user intent>
   ---
   ```
2. Write the skill body. Reference the state machine in `workflow/transitions.yaml` for transition IDs.
3. Run `./install.sh` to symlink the new skill.

### Adding a transition test

Append a scenario to `tests/scenarios/<group>.yaml`:

```yaml
- id: T2
  name: "task:plan → act when plan is clear"
  skill: task-plan
  args: "Add a loading spinner to the login button"
  fixtures:
    gemini_md: fixtures/GEMINI.md
  expect:
    transition_id: T2
    contains_any: ["/task-act"]
    not_contains: ["/feature-spec"]
  max_retries: 2
```
