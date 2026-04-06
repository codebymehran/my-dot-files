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

# Components — features + shared
mkdir -p src/components/features/placeholder
mkdir -p src/components/shared

# Hooks, types, context
mkdir -p src/hooks
mkdir -p src/types
mkdir -p src/context

# Lib — utils, data, helpers
mkdir -p src/lib

# Docs
mkdir -p src/docs

echo "  ✅ src/components/features/placeholder"
echo "  ✅ src/components/shared"
echo "  ✅ src/hooks"
echo "  ✅ src/types"
echo "  ✅ src/context"
echo "  ✅ src/lib"
echo "  ✅ src/docs"

# -----------------------------
# Scaffold component files
# -----------------------------

echo ""
echo "🧩 Scaffolding component files..."

# Feature placeholder component
cat > src/components/features/placeholder/Sidebar.tsx << 'SIDEBAR'
// ─── Imports ────────────────────────────────────────────────────────────────

// ─── Component ──────────────────────────────────────────────────────────────
// Sidebar — rename this folder to match your feature (e.g. dashboard, notes)

const Sidebar = () => {
  // ─── Render ───────────────────────────────────────────────────────────────
  return (
    <aside>
      <p>Sidebar</p>
    </aside>
  );
};

export default Sidebar;
SIDEBAR
echo "  ✅ src/components/features/placeholder/Sidebar.tsx"

# Shared — LoadingSpinner
cat > src/components/shared/LoadingSpinner.tsx << 'SPINNER'
// ─── Component ──────────────────────────────────────────────────────────────
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
echo "  ✅ src/components/shared/LoadingSpinner.tsx"

# Shared — EmptyState
cat > src/components/shared/EmptyState.tsx << 'EMPTY'
// ─── Component ──────────────────────────────────────────────────────────────
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
echo "  ✅ src/components/shared/EmptyState.tsx"

# Shared — PageHeader
cat > src/components/shared/PageHeader.tsx << 'HEADER'
// ─── Component ──────────────────────────────────────────────────────────────
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
echo "  ✅ src/components/shared/PageHeader.tsx"

# -----------------------------
# Lib files
# -----------------------------

echo ""
echo "🔧 Creating lib files..."

# utils.ts — cn helper
cat > src/lib/utils.ts << 'UTILS'
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
UTILS
echo "  ✅ src/lib/utils.ts (cn helper)"

# data.ts — mock data placeholder
cat > src/lib/data.ts << 'DATA'
// ─── Mock Data ───────────────────────────────────────────────────────────────
// Temporary data for development — replace with real API calls

export const placeholder = [];
DATA
echo "  ✅ src/lib/data.ts"

# -----------------------------
# App route folders
# -----------------------------

echo ""
echo "📂 Creating app route groups..."

# Auth routes
mkdir -p src/app/\(auth\)/login
cat > src/app/\(auth\)/login/page.tsx << 'LOGINPAGE'
export default function LoginPage() {
  return (
    <main>
      <p>Login</p>
    </main>
  );
}
LOGINPAGE
echo "  ✅ src/app/(auth)/login/page.tsx"

# Dashboard routes
mkdir -p src/app/\(dashboard\)/dashboard
cat > src/app/\(dashboard\)/dashboard/page.tsx << 'DASHPAGE'
export default function DashboardPage() {
  return (
    <main>
      <p>Dashboard</p>
    </main>
  );
}
DASHPAGE
echo "  ✅ src/app/(dashboard)/dashboard/page.tsx"

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
  --yes

echo ""
echo "🧩 Installing shadcn components..."
npx shadcn@latest add button input card dialog form select sonner dropdown-menu --yes --overwrite
echo "  ✅ button, input, card, dialog, form, select, sonner, dropdown-menu"

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
# Install cn dependencies
# -----------------------------

echo ""
echo "📦 Installing cn() dependencies..."
npm install clsx tailwind-merge
echo "  ✅ clsx + tailwind-merge installed"

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
echo "┌─────────────────────────────────────────┐"
echo "│  src/                                   │"
echo "│  ├── app/                               │"
echo "│  │   ├── (auth)/login/page.tsx          │"
echo "│  │   ├── (dashboard)/dashboard/page.tsx │"
echo "│  │   ├── layout.tsx                     │"
echo "│  │   └── page.tsx                       │"
echo "│  ├── components/                        │"
echo "│  │   ├── features/placeholder/          │"
echo "│  │   │   └── Sidebar.tsx                │"
echo "│  │   └── shared/                        │"
echo "│  │       ├── EmptyState.tsx             │"
echo "│  │       ├── LoadingSpinner.tsx         │"
echo "│  │       └── PageHeader.tsx             │"
echo "│  ├── lib/                               │"
echo "│  │   ├── data.ts                        │"
echo "│  │   └── utils.ts                       │"
echo "│  ├── hooks/                             │"
echo "│  ├── types/                             │"
echo "│  ├── context/                           │"
echo "│  └── docs/                              │"
echo "└─────────────────────────────────────────┘"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
