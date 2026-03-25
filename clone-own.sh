#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clone Own Repo and Setup Dev Environment
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🏠
# @raycast.argument1 { "type": "text", "placeholder": "Git repository URL" }

# Documentation:
# @raycast.description Clones your own repo into ~/Code, installs dependencies, opens in existing VS Code window

set -e

TARGET_DIR=~/Code

if [ -z "$1" ]; then
  echo "❌ Usage: cloneown <url>"
  exit 1
fi

REPO_NAME=$(basename "$1" .git)
TARGET="$TARGET_DIR/$REPO_NAME"

if [ -d "$TARGET" ]; then
  echo "❌ '$TARGET' already exists — choose a different name or delete it first"
  exit 1
fi

echo "📁 Cloning into ~/Code..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

echo "🔄 Cloning the repository..."
git clone "$1"

echo "📂 Entering $REPO_NAME..."
cd "$REPO_NAME"

echo "🔍 Project structure:"
ls -la

if [ -f "package.json" ]; then
  echo "📦 Installing dependencies..."
  if ! npm install; then
    echo "⚠️ npm install failed, retrying with --force..."
    npm install --force
  fi
else
  echo "ℹ️  No package.json found — skipping npm install"
fi

echo "🚀 Opening in existing VS Code window..."
code -r .

echo "✅ Done! Project is at ~/Code/$REPO_NAME"
