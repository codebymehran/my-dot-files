#!/bin/bash

# ============================================================================
# projectrename.sh
# Rename a project — local folder + GitHub repo
# Usage: projectrename <old-name> <new-name>
# Run from anywhere
# ============================================================================

set -e

CODE_DIR="$HOME/Code"

# -----------------------------
# Validate
# -----------------------------

if [ -z "$1" ] || [ -z "$2" ]; then
  echo ""
  echo "❌ Usage: projectrename <old-name> <new-name>"
  echo ""
  exit 1
fi

OLD_NAME="$1"
NEW_NAME="$2"
OLD_DIR="$CODE_DIR/$OLD_NAME"
NEW_DIR="$CODE_DIR/$NEW_NAME"

if [ ! -d "$OLD_DIR" ]; then
  echo "❌ Project not found at $OLD_DIR"
  exit 1
fi

if [ -d "$NEW_DIR" ]; then
  echo "❌ A project named '$NEW_NAME' already exists at $NEW_DIR"
  exit 1
fi

# -----------------------------
# Confirm
# -----------------------------

echo ""
echo "🔁 Renaming project:"
echo "   $OLD_DIR"
echo "   → $NEW_DIR"
echo ""

# Check if GitHub remote exists
cd "$OLD_DIR"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
HAS_REMOTE=false
GITHUB_USER=""
OLD_REPO_NAME=""

if [ -n "$REMOTE_URL" ]; then
  # Support both SSH and HTTPS remotes
  if echo "$REMOTE_URL" | grep -q "github.com"; then
    HAS_REMOTE=true
    GITHUB_USER=$(echo "$REMOTE_URL" | sed 's|.*github.com[:/]\([^/]*\)/.*|\1|')
    OLD_REPO_NAME=$(echo "$REMOTE_URL" | sed 's|.*/||; s|\.git$||')
    echo "🐙 GitHub repo detected: $GITHUB_USER/$OLD_REPO_NAME"
    echo "   Will rename to: $GITHUB_USER/$NEW_NAME"
    echo ""
  fi
fi

read -r -p "Are you sure? [y/N] " confirm
confirm="${confirm:-n}"
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo ""
  echo "⏭️  Cancelled — nothing was changed"
  echo ""
  exit 0
fi

# -----------------------------
# Rename local folder
# -----------------------------

echo ""
mv "$OLD_DIR" "$NEW_DIR"
echo "  ✅ Folder renamed → $NEW_DIR"

# -----------------------------
# Rename GitHub repo
# -----------------------------

if [ "$HAS_REMOTE" = true ]; then
  echo ""
  echo "🐙 Renaming GitHub repo..."

  if ! command -v gh &>/dev/null; then
    echo "  ⚠️  gh not found — skipping GitHub rename"
    echo "     Rename manually at: https://github.com/$GITHUB_USER/$OLD_REPO_NAME/settings"
  else
    if gh repo rename "$NEW_NAME" --repo "$GITHUB_USER/$OLD_REPO_NAME" --yes 2>/dev/null; then
      echo "  ✅ GitHub repo renamed → $GITHUB_USER/$NEW_NAME"

      # Update remote URL in the newly renamed local folder
      cd "$NEW_DIR"
      NEW_REMOTE_URL=$(echo "$REMOTE_URL" | sed "s|$OLD_REPO_NAME|$NEW_NAME|g")
      git remote set-url origin "$NEW_REMOTE_URL"
      echo "  ✅ Remote URL updated → $NEW_REMOTE_URL"
    else
      echo "  ⚠️  GitHub rename failed — rename manually at:"
      echo "     https://github.com/$GITHUB_USER/$OLD_REPO_NAME/settings"
    fi
  fi
fi

# -----------------------------
# Done
# -----------------------------

echo ""
echo "✅ Done!"
echo ""
echo "💡 Tips:"
echo "   • cd into the project: z $NEW_NAME"
echo "   • zoxide will learn the new name after you visit it once"
if [ "$HAS_REMOTE" = true ]; then
echo "   • GitHub automatically redirects the old repo URL — no broken links"
fi
echo ""
