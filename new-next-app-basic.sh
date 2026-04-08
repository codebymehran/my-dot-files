#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Next.js App (Basic)
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🚀
# @raycast.argument1 { "type": "text", "placeholder": "project-name" }

# Documentation:
# @raycast.description Scaffolds a simple Next.js project with TypeScript, Tailwind, ESLint + shadcn/ui

set -e

# ============================================================================
# new-next-app-basic.sh
# Simple Next.js starter — good for learning and small projects
# Usage: bash new-next-app-basic.sh <project-name>
# ============================================================================

# -----------------------------
# Validate input
# -----------------------------

if [ -z "$1" ]; then
  echo "❌ Usage: bash new-next-app-basic.sh <project-name>"
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
mkdir -p src/lib

echo "  ✅ src/components"
echo "  ✅ src/lib"

# -----------------------------
# cn utility
# -----------------------------

echo ""
echo "🔧 Creating lib/utils.ts..."

cat > src/lib/utils.ts << 'UTILS'
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
UTILS
echo "  ✅ src/lib/utils.ts (cn helper)"

# -----------------------------
# Shared components
# -----------------------------

echo ""
echo "🧩 Scaffolding components..."

cat > src/components/LoadingSpinner.tsx << 'SPINNER'
// Reusable loading spinner — drop anywhere you need a loading state

const LoadingSpinner = () => {
  return (
    <div className="flex items-center justify-center p-4">
      <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-foreground" />
    </div>
  );
};

export default LoadingSpinner;
SPINNER
echo "  ✅ src/components/LoadingSpinner.tsx"

cat > src/components/EmptyState.tsx << 'EMPTY'
// Reusable empty state — use in any list when there's nothing to show

interface EmptyStateProps {
  message?: string;
}

const EmptyState = ({ message = 'Nothing here yet.' }: EmptyStateProps) => {
  return (
    <p className="text-sm text-muted-foreground">{message}</p>
  );
};

export default EmptyState;
EMPTY
echo "  ✅ src/components/EmptyState.tsx"

cat > src/components/PageHeader.tsx << 'HEADER'
// Reusable page header — title + optional subtitle

interface PageHeaderProps {
  title: string;
  subtitle?: string;
}

const PageHeader = ({ title, subtitle }: PageHeaderProps) => {
  return (
    <div className="mb-6">
      <h1 className="text-2xl font-semibold tracking-tight">{title}</h1>
      {subtitle && <p className="text-sm text-muted-foreground mt-1">{subtitle}</p>}
    </div>
  );
};

export default PageHeader;
HEADER
echo "  ✅ src/components/PageHeader.tsx"

# -----------------------------
# Clean up boilerplate
# -----------------------------

echo ""
echo "🧹 Cleaning up boilerplate..."

find public/ -name "*.svg" -delete
echo "  ✅ SVGs removed from public/"

rm -f public/favicon.ico
rm -f src/app/favicon.ico
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
    <html lang="en" suppressHydrationWarning>
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
# Init shadcn/ui
# -----------------------------

echo ""
echo "🎨 Initialising shadcn/ui..."
npx shadcn@latest init --yes

echo ""
echo "🧩 Installing shadcn components..."
npx shadcn@latest add button input card dialog form select sonner dropdown-menu --yes --overwrite
echo "  ✅ button, input, card, dialog, form, select, sonner, dropdown-menu"

# -----------------------------
# Prettier config
# -----------------------------

echo ""
echo "✨ Adding Prettier config..."
cat > prettier.config.mjs << 'PRETTIER'
/** @type {import('prettier').Config} */
const config = {
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  semi: true,
  tabWidth: 2,
  arrowParens: 'avoid',
};

export default config;
PRETTIER
echo "  ✅ prettier.config.mjs created"

# -----------------------------
# .env files
# -----------------------------

echo ""
echo "🔐 Creating .env files..."
touch .env.local
echo "  ✅ .env.local created"

cat > .env.example << 'EOF'
# Copy this file to .env.local and fill in the values

NEXT_PUBLIC_APP_URL=http://localhost:3000

# Add your keys below
# OPENAI_API_KEY=
# DATABASE_URL=
EOF
echo "  ✅ .env.example created"

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
# .vscode/settings.json
# -----------------------------

echo ""
echo "🔧 Creating .vscode/settings.json..."
mkdir -p .vscode
cat > .vscode/settings.json << 'VSCODE'
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "tailwindCSS.experimental.classRegex": [
    ["cn\\(([^)]*)\\)", "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)"]
  ],
  "css.lint.unknownAtRules": "ignore"
}
VSCODE
echo "  ✅ .vscode/settings.json"

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
echo "┌─────────────────────────────────┐"
echo "│  src/                           │"
echo "│  ├── app/                       │"
echo "│  │   ├── layout.tsx             │"
echo "│  │   ├── page.tsx               │"
echo "│  │   └── globals.css            │"
echo "│  ├── components/                │"
echo "│  │   ├── EmptyState.tsx         │"
echo "│  │   ├── LoadingSpinner.tsx     │"
echo "│  │   └── PageHeader.tsx         │"
echo "│  └── lib/                       │"
echo "│      └── utils.ts               │"
echo "└─────────────────────────────────┘"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
echo ""
echo "💡 When your project grows, consider adding:"
echo "   src/hooks/        → custom React hooks"
echo "   src/types/        → shared TypeScript types"
echo "   src/lib/api/      → fetch wrapper"
echo "   src/services/     → API call functions"
