#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Next.js App
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🚀
# @raycast.argument1 { "type": "text", "placeholder": "project-name" }

# Documentation:
# @raycast.description Scaffolds a new Next.js project with TypeScript, Tailwind, ESLint + shadcn/ui

set -e

# ============================================================================
# new-next-app.sh
# Creates a new Next.js project with TypeScript, Tailwind, ESLint + shadcn/ui
# Usage: bash new-next-app.sh <project-name>
# ============================================================================

# -----------------------------
# Preflight checks
# -----------------------------

echo ""
echo "🔍 Checking dependencies..."
missing=()
for cmd in node npx git; do
  if ! command -v "$cmd" &> /dev/null; then
    missing+=("$cmd")
  fi
done
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "❌ Missing required tools: ${missing[*]}"
  echo "   Please install them before running this script."
  exit 1
fi
echo "  ✅ node $(node --version), npx, git — all good"

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
  --yes

cd "$TARGET"

# -----------------------------
# Scaffold folder structure
# -----------------------------

echo ""
echo "📁 Creating folder structure..."
mkdir -p src/components
mkdir -p src/hooks
mkdir -p src/types
mkdir -p src/context
mkdir -p src/mock
touch src/mock/data.js
mkdir -p src/docs
echo "  ✅ src/components"
echo "  ✅ src/hooks"
echo "  ✅ src/types"
echo "  ✅ src/context"
echo "  ✅ src/mock (data.js)"
echo "  ✅ src/docs"

# -----------------------------
# Append to .gitignore
# -----------------------------

echo ""
echo "📝 Updating .gitignore..."
cat >> .gitignore << 'GITIGNORE'

# Environment
.env.local
.env.*.local

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Logs
*.log
npm-debug.log*

# Editor
.vscode/settings.json
GITIGNORE
echo "  ✅ .gitignore updated"

# -----------------------------
# Init shadcn/ui
# -----------------------------

echo ""
echo "🎨 Initialising shadcn/ui..."
npx shadcn@latest init \
  --defaults \
  --yes

echo ""
echo "🧩 Installing shadcn components..."
npx shadcn@latest add button input card dialog form select sonner dropdown-menu --yes
echo "  ✅ button, input, card, dialog, form, select, sonner, dropdown-menu"

echo ""
echo "🎨 Installing Claude theme..."
npx shadcn@latest add https://tweakcn.com/r/themes/claude.json --yes
echo "  ✅ Claude theme installed"

# -----------------------------
# Clean up boilerplate
# -----------------------------

echo ""
echo "🧹 Cleaning up boilerplate..."

find public/ -name "*.svg" -delete
echo "  ✅ SVGs removed from public/"

rm -f public/favicon.ico
echo "  ✅ favicon.ico removed"

cat > src/app/layout.tsx << 'LAYOUT'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "App",
  description: "",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
LAYOUT
echo "  ✅ layout.tsx stripped"

cat > src/app/page.tsx << 'PAGE'
export default function Home() {
  return <main></main>;
}
PAGE
echo "  ✅ page.tsx stripped"

echo ""
echo "🖱️  Patching globals.css for cursor: pointer..."
cat >> src/app/globals.css << 'CSS'

@layer base {
  button:not(:disabled),
  [role="button"]:not(:disabled) {
    cursor: pointer;
  }
}
CSS
echo "  ✅ globals.css cursor patch applied"

# -----------------------------
# Prettier config
# -----------------------------

echo ""
echo "✨ Adding Prettier config..."
cat > prettier.config.js << 'PRETTIER'
module.exports = {
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  semi: true,
  tabWidth: 2,
  arrowParens: 'avoid',
};
PRETTIER
echo "  ✅ prettier.config.js created"

# -----------------------------
# .env.local
# -----------------------------

echo ""
echo "🔐 Creating .env files..."
touch .env.local
echo "  ✅ .env.local created"

cat > .env.example << 'EOF'
# Copy this file to .env.local and fill in the values

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Add your secret keys below
# OPENAI_API_KEY=
# DATABASE_URL=
EOF
echo "  ✅ .env.example created"

# -----------------------------
# .nvmrc
# -----------------------------

echo ""
echo "📌 Creating .nvmrc..."
node --version > .nvmrc
echo "  ✅ .nvmrc created ($(node --version))"

# -----------------------------
# Clean git history — single commit
# -----------------------------

echo ""
echo "🔧 Resetting git history to single clean commit..."
rm -rf .git
git init
git add .
git commit -m "chore: initial setup"
echo "  ✅ Clean initial commit"

# -----------------------------
# Open in VS Code
# -----------------------------

echo ""
echo "🖥️  Opening in VS Code..."
if command -v code &> /dev/null; then
  code -r .
elif [ -f "/opt/homebrew/bin/code" ]; then
  /opt/homebrew/bin/code -r .
elif [ -f "/usr/local/bin/code" ]; then
  /usr/local/bin/code -r .
else
  open -a "Visual Studio Code" . || echo "⚠️  Could not open VS Code — open manually"
fi

# -----------------------------
# Done
# -----------------------------

echo ""
echo "✅ Project ready!"
echo ""
echo "📍 $TARGET"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
