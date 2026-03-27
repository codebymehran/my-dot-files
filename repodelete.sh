#!/bin/bash

# ============================================================================
# repodelete.sh
# Deletes a project locally from ~/Code AND removes it from GitHub
# Usage: repodelete <project-name>
# ============================================================================

set -e

if [ -z "$1" ]; then
  echo "❌ Usage: repodelete <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
TARGET="$HOME/Code/$PROJECT_NAME"

# -----------------------------
# Confirm
# -----------------------------

echo ""
echo "⚠️  This will permanently delete:"
echo "   📁 Local:  $TARGET"
echo "   ☁️  GitHub: $PROJECT_NAME"
echo ""
read -p "Type the project name to confirm: " CONFIRM

if [ "$CONFIRM" != "$PROJECT_NAME" ]; then
  echo "❌ Name didn't match — aborted"
  exit 1
fi

# -----------------------------
# Delete GitHub repo
# -----------------------------

echo ""
echo "☁️  Deleting GitHub repo..."
if gh repo delete "$PROJECT_NAME" --yes 2>/dev/null; then
  echo "  ✅ GitHub repo deleted"
else
  echo "  ⚠️  GitHub repo not found or already deleted — skipping"
fi

# -----------------------------
# Delete local folder
# -----------------------------

echo ""
echo "📁 Deleting local folder..."
if [ -d "$TARGET" ]; then
  rm -rf "$TARGET"
  echo "  ✅ Local folder deleted"
else
  echo "  ⚠️  Local folder not found — skipping"
fi

# -----------------------------
# Done
# -----------------------------

echo ""
echo "✅ $PROJECT_NAME has been fully removed"
echo ""
