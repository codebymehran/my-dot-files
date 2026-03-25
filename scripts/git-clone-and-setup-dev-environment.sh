#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Git Clone and Setup Dev Environment
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Git repository URL" }

# Documentation:
# @raycast.description Clones a repo into ~/Code/explore, installs dependencies, opens in existing VS Code window
# @raycast.author bhanu1776
# @raycast.authorURL https://raycast.com/bhanu1776

set -e

TARGET_DIR=~/Code/explore

if [ -z "$1" ]; then
  echo "❌ Error: No Git repository URL provided."
  exit 1
fi

echo "📁 Creating ~/Code/explore if it doesn't exist..."
mkdir -p "$TARGET_DIR"

echo "📂 Changing to explore directory..."
cd "$TARGET_DIR"

echo "🔄 Cloning the repository..."
git clone "$1"

REPO_NAME=$(basename "$1" .git)

echo "📂 Entering $REPO_NAME..."
cd "$REPO_NAME"

echo "🔍 Exploring project structure..."
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

echo "✅ Done! Project is at ~/Code/explore/$REPO_NAME"
echo "🧹 When finished: trash $REPO_NAME"
