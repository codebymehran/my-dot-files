#!/bin/bash

# ============================================================================
# repodelete.sh (macOS-ready, bulletproof)
# Safe repo deletion with:
# - Trash instead of rm
# - Auto-detect current repo
# - Fuzzy search
# - Interactive picker
# ============================================================================
set -euo pipefail

CODE_DIR="$HOME/Code"
DRY_RUN="${2:-}"

# -----------------------------
# Helpers
# -----------------------------

choose_project() {
  echo "📂 Select a project:"

  # Read folder names into an array (Bash 3.2 compatible)
  PROJECTS=()
  while IFS= read -r line; do
    PROJECTS+=("$line")
  done < <(ls -1 "$CODE_DIR")

  # Interactive select
  PS3="Enter number: "
  select PROJECT_NAME in "${PROJECTS[@]}"; do
    if [ -n "$PROJECT_NAME" ]; then
      echo "  → Selected: $PROJECT_NAME"
      break
    else
      echo "Invalid selection"
    fi
  done
}

fuzzy_match() {
  local input="$1"
  match=$(ls -1 "$CODE_DIR" | grep -i "$input" | head -n 1 || true)
  echo "$match"
}

move_to_trash() {
  local path="$1"

  if command -v trash >/dev/null 2>&1; then
    trash "$path"
  else
    mv "$path" "$HOME/.Trash/"
  fi
}

# -----------------------------
# Determine project
# -----------------------------

PROJECT_NAME="${1:-}"

if [ -z "$PROJECT_NAME" ]; then
  choose_project
elif [ "$PROJECT_NAME" == "." ]; then
  PROJECT_NAME=$(basename "$(pwd)")
  echo "📍 Auto-detected current repo: $PROJECT_NAME"
elif [ ! -d "$CODE_DIR/$PROJECT_NAME" ]; then
  echo "🔎 Trying fuzzy match..."
  MATCH=$(fuzzy_match "$PROJECT_NAME")

  if [ -n "$MATCH" ]; then
    echo "  → Did you mean: $MATCH ?"
    read -p "Use this? (Y/n): " confirm
    if [[ "$confirm" != "n" && "$confirm" != "N" ]]; then
      PROJECT_NAME="$MATCH"
    else
      choose_project
    fi
  else
    echo "❌ No match found"
    choose_project
  fi
fi

TARGET="$CODE_DIR/$PROJECT_NAME"

# -----------------------------
# Safety check
# -----------------------------

if [[ "$TARGET" != "$CODE_DIR/"* ]]; then
  echo "❌ Refusing to delete outside ~/Code"
  exit 1
fi

# -----------------------------
# Detect GitHub repo
# -----------------------------

REPO=""

if [ -d "$TARGET/.git" ]; then
  echo "🔍 Detecting GitHub repo..."
  set +e
  REPO=$(cd "$TARGET" && gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)
  set -e
fi

if [ -z "$REPO" ]; then
  USERNAME=$(gh api user -q .login)
  REPO="$USERNAME/$PROJECT_NAME"
fi

# -----------------------------
# Confirm
# -----------------------------

echo ""
echo "⚠️  This will move to Trash and delete GitHub repo:"
echo "   📁 Local → Trash: $TARGET"
echo "   ☁️  GitHub: $REPO"
echo ""

read -p "Type DELETE to confirm: " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
  echo "❌ Cancelled"
  exit 1
fi

# -----------------------------
# Dry run
# -----------------------------

if [ "$DRY_RUN" == "--dry-run" ]; then
  echo ""
  echo "🧪 DRY RUN"
  echo "Would delete:"
  echo "  - GitHub: $REPO"
  echo "  - Local → Trash: $TARGET"
  exit 0
fi

# -----------------------------
# Delete GitHub repo
# -----------------------------

echo ""
echo "☁️  Deleting GitHub repo..."

set +e
gh repo delete "$REPO" --yes
GH_STATUS=$?
set -e

if [ $GH_STATUS -eq 0 ]; then
  echo "  ✅ GitHub repo deleted"
else
  echo "  ⚠️  Failed (may not exist or no permission)"
fi

# -----------------------------
# Move local to Trash
# -----------------------------

echo ""
echo "🗑️  Moving to Trash..."

if [ -d "$TARGET" ]; then
  move_to_trash "$TARGET"
  echo "  ✅ Moved to Trash"
else
  echo "  ⚠️  Local folder not found"
fi

# -----------------------------
# Done
# -----------------------------

echo ""
echo "✅ $PROJECT_NAME cleanup complete"
echo ""
