#!/usr/bin/env bash
# install.sh — Idempotent setup script for Gemini CLI workflow customizations
# Creates per-skill symlinks from source repo to ~/.gemini/skills/.

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.gemini"

echo "Installing Gemini CLI workflow customizations..."
echo "  Source: $SOURCE_DIR"
echo "  Target: $TARGET_DIR"
echo

# --- Handle legacy whole-dir skills symlink ---
if [ -L "$TARGET_DIR/skills" ]; then
  echo "  [migrate] Removing legacy whole-dir symlink at $TARGET_DIR/skills"
  rm "$TARGET_DIR/skills"
fi

# --- Handle legacy commands symlink (commands no longer used) ---
if [ -L "$TARGET_DIR/commands" ]; then
  legacy_target="$(readlink "$TARGET_DIR/commands")"
  case "$legacy_target" in
    "$SOURCE_DIR/commands"|"$SOURCE_DIR/commands/")
      echo "  [migrate] Removing legacy commands symlink (commands have been retired)"
      rm "$TARGET_DIR/commands"
      ;;
  esac
fi

# --- Symlink Skills (per-skill) ---
mkdir -p "$TARGET_DIR/skills"

for skill_dir in "$SOURCE_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  link="$TARGET_DIR/skills/$skill_name"
  target="${skill_dir%/}"

  if [ -L "$link" ]; then
    current_target="$(readlink "$link")"
    if [ "$current_target" = "$target" ] || [ "$current_target" = "$skill_dir" ]; then
      echo "  [ok] skills/$skill_name (already linked)"
      continue
    else
      echo "  [update] skills/$skill_name (repointing symlink)"
      rm "$link"
    fi
  elif [ -e "$link" ]; then
    echo "  [skip] skills/$skill_name (exists but is not a symlink — manual resolution needed)"
    continue
  fi

  ln -s "$target" "$link"
  echo "  [new] skills/$skill_name"
done

# --- Inject workflow snippet into ~/.gemini/GEMINI.md ---
SNIPPET_FILE="$SOURCE_DIR/GEMINI.snippet.md"
GLOBAL_GEMINI_MD="$TARGET_DIR/GEMINI.md"
BEGIN_MARKER="<!-- BEGIN gemini-workflow-system -->"
END_MARKER="<!-- END gemini-workflow-system -->"

if [ ! -f "$SNIPPET_FILE" ]; then
  echo "  [warn] GEMINI.snippet.md not found at $SNIPPET_FILE — skipping injection"
else
  # Build the block (markers + snippet content)
  block_tmp="$(mktemp)"
  {
    printf '%s\n' "$BEGIN_MARKER"
    printf '<!-- Managed by install.sh in %s. Edits between these markers will be overwritten on re-run. -->\n' "$SOURCE_DIR"
    cat "$SNIPPET_FILE"
    printf '%s\n' "$END_MARKER"
  } > "$block_tmp"

  if [ ! -f "$GLOBAL_GEMINI_MD" ]; then
    # Create file with just the block
    cat "$block_tmp" > "$GLOBAL_GEMINI_MD"
    echo "  [new] GEMINI.md (created with workflow block)"
  elif grep -qF "$BEGIN_MARKER" "$GLOBAL_GEMINI_MD"; then
    # Replace existing block between markers
    backup="${GLOBAL_GEMINI_MD}.bak"
    cp "$GLOBAL_GEMINI_MD" "$backup"
    updated_tmp="$(mktemp)"
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" -v blockfile="$block_tmp" '
      BEGIN { in_block = 0 }
      $0 == begin {
        # Print our fresh block
        while ((getline line < blockfile) > 0) print line
        close(blockfile)
        in_block = 1
        next
      }
      $0 == end {
        in_block = 0
        next
      }
      !in_block { print }
    ' "$GLOBAL_GEMINI_MD" > "$updated_tmp"
    mv "$updated_tmp" "$GLOBAL_GEMINI_MD"

    # Only keep backup on first run (when it differs); otherwise remove to reduce clutter
    if cmp -s "$backup" "$GLOBAL_GEMINI_MD"; then
      rm "$backup"
      echo "  [ok] GEMINI.md (workflow block already up to date)"
    else
      echo "  [update] GEMINI.md (workflow block refreshed, backup: $backup)"
    fi
  else
    # Append block with separator; back up first
    backup="${GLOBAL_GEMINI_MD}.bak"
    cp "$GLOBAL_GEMINI_MD" "$backup"
    {
      cat "$GLOBAL_GEMINI_MD"
      # Ensure a blank line separator
      if [ -n "$(tail -c1 "$GLOBAL_GEMINI_MD")" ]; then
        printf '\n'
      fi
      printf '\n'
      cat "$block_tmp"
    } > "${GLOBAL_GEMINI_MD}.new"
    mv "${GLOBAL_GEMINI_MD}.new" "$GLOBAL_GEMINI_MD"
    echo "  [append] GEMINI.md (workflow block appended, backup: $backup)"
  fi

  rm -f "$block_tmp"
fi

echo
echo "Done. Symlinks and GEMINI.md block are in place."
echo
echo "Next steps:"
echo "  1. Ensure \$TELEGRAM_BOT_TOKEN and \$TELEGRAM_CHAT_ID are exported in your shell profile"
echo "     (e.g., ~/.zshrc or ~/.bashrc) so notify-human works globally."
