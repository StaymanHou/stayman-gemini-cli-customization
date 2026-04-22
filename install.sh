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

echo
echo "Done. Symlinks are in place."
echo
echo "Next steps:"
echo "  1. Ensure \$TELEGRAM_BOT_TOKEN and \$TELEGRAM_CHAT_ID are exported in your shell profile"
echo "     (e.g., ~/.zshrc or ~/.bashrc) so notify-human works globally."
echo "  2. Review ~/.gemini/GEMINI.md for the global notify-human enforcement rule."
