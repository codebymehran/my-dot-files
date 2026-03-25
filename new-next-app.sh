#!/bin/bash

set -e

# ============================================================================
# new-next-app.sh
# Creates a new Next.js project with TypeScript, Tailwind, ESLint + shadcn/ui
# Usage: bash new-next-app.sh <project-name>
# ============================================================================

# -----------------------------
# Validate input
# -----------------------------

if [ -z "$1" ]; then
  echo "❌ Usage: bash new-next-app.sh <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
TARGET="$HOME/Code/$PROJECT_NAME"

if [ -d "$TARGET" ]; then
  echo "❌ '$TARGET' already exists — choose a different name"
  exit 1
fi

echo ""
echo "🚀 Creating Next.js project: $PROJECT_NAME"
echo "📍 Location: $TARGET"
echo ""

# -----------------------------
# Create Next.js app
# -----------------------------

echo "⚙️  Running create-next-app..."
npx create-next-app@latest "$TARGET" \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --no-turbopack \
  --no-experimental-react-compiler \
  --yes

cd "$TARGET"

# -----------------------------
# Init shadcn/ui
# -----------------------------

echo ""
echo "🎨 Initialising shadcn/ui..."
npx shadcn@latest init \
  --base-color zinc \
  --yes

# -----------------------------
# Init git repo
# -----------------------------

echo ""
echo "🔧 Setting up Git..."
git init
git add .
git commit -m "Initial commit — Next.js + TypeScript + Tailwind + shadcn/ui"

# -----------------------------
# Open in VS Code
# -----------------------------

echo ""
echo "🖥️  Opening in VS Code..."
code -r .

# -----------------------------
# Done
# -----------------------------

echo ""
echo "✅ Project ready!"
echo ""
echo "📍 $TARGET"
echo ""
echo "👉 Next steps:"
echo "   nrd          → start dev server"
echo "   gacp \"msg\"   → commit and push when ready"
echo "   ghopen       → open on GitHub once remote is added"
