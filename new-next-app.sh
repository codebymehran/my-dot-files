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

mkdir -p src/components/features/placeholder
mkdir -p src/components/shared
mkdir -p src/hooks
mkdir -p src/types
mkdir -p src/context
mkdir -p src/lib/api
mkdir -p src/services
mkdir -p src/mocks
mkdir -p docs

echo "  ✅ src/components/features/placeholder"
echo "  ✅ src/components/shared"
echo "  ✅ src/hooks"
echo "  ✅ src/types"
echo "  ✅ src/context"
echo "  ✅ src/lib/api"
echo "  ✅ src/services"
echo "  ✅ src/mocks"
echo "  ✅ docs/ (root)"

# -----------------------------
# Scaffold component files
# -----------------------------

echo ""
echo "🧩 Scaffolding component files..."

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

cat > src/lib/utils.ts << 'UTILS'
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
UTILS
echo "  ✅ src/lib/utils.ts (cn helper)"

# -----------------------------
# API client + endpoints + barrel
# -----------------------------

cat > src/lib/api/client.ts << 'CLIENT'
// ─── API Client ──────────────────────────────────────────────────────────────
// Base fetch wrapper — use this for all external API calls
// Components should never import this directly — use src/services/ instead

const BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? process.env.NEXT_PUBLIC_APP_URL ?? '';

type RequestOptions = RequestInit & {
  params?: Record<string, string>;
};

async function request<T>(endpoint: string, options: RequestOptions = {}): Promise<T> {
  const { params, ...init } = options;

  const url = new URL(`${BASE_URL}${endpoint}`);
  if (params) {
    Object.entries(params).forEach(([key, value]) => url.searchParams.set(key, value));
  }

  const res = await fetch(url.toString(), {
    headers: {
      'Content-Type': 'application/json',
      ...init.headers,
    },
    ...init,
  });

  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }

  return res.json() as Promise<T>;
}

export const api = {
  get: <T>(endpoint: string, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'GET' }),

  post: <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'POST', body: JSON.stringify(body) }),

  put: <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'PUT', body: JSON.stringify(body) }),

  patch: <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'PATCH', body: JSON.stringify(body) }),

  delete: <T>(endpoint: string, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'DELETE' }),
};
CLIENT
echo "  ✅ src/lib/api/client.ts (window.location.origin removed)"

cat > src/lib/api/endpoints.ts << 'ENDPOINTS'
// ─── API Endpoints ───────────────────────────────────────────────────────────
// Keep all URL strings here — import into services, never into components

export const endpoints = {
  // auth
  auth: {
    login: '/auth/login',
    logout: '/auth/logout',
    me: '/auth/me',
  },
  // add more resource groups as your app grows
};
ENDPOINTS
echo "  ✅ src/lib/api/endpoints.ts"

cat > src/lib/api/index.ts << 'APIBARREL'
export { api } from './client';
export { endpoints } from './endpoints';
APIBARREL
echo "  ✅ src/lib/api/index.ts (barrel)"

# -----------------------------
# Services
# -----------------------------

cat > src/services/auth.service.ts << 'AUTHSERVICE'
// ─── Auth Service ────────────────────────────────────────────────────────────
// All auth-related API calls — import this in hooks/components, not api directly

import { api } from '@/lib/api';
import { endpoints } from '@/lib/api';

export const authService = {
  login: (credentials: { email: string; password: string }) =>
    api.post(endpoints.auth.login, credentials),

  logout: () =>
    api.post(endpoints.auth.logout, {}),

  getMe: () =>
    api.get(endpoints.auth.me),
};
AUTHSERVICE
echo "  ✅ src/services/auth.service.ts"

cat > src/services/index.ts << 'SERVICESBARREL'
// ─── Services Barrel ─────────────────────────────────────────────────────────
// Export all services from here for clean imports

export { authService } from './auth.service';
SERVICESBARREL
echo "  ✅ src/services/index.ts (barrel)"

# -----------------------------
# Mocks
# -----------------------------

cat > src/mocks/index.ts << 'MOCKS'
// ─── Mock Data ───────────────────────────────────────────────────────────────
// Temporary data for development — replace with real API calls via services/

export const mockUser = {
  id: '1',
  name: 'Jane Doe',
  email: 'jane@example.com',
};
MOCKS
echo "  ✅ src/mocks/index.ts"

# -----------------------------
# Types barrel file
# -----------------------------

cat > src/types/index.ts << 'TYPES'
// ─── Shared Types ────────────────────────────────────────────────────────────
// Add shared types here as your project grows
// e.g. User, ApiResponse, etc.
TYPES
echo "  ✅ src/types/index.ts"

# -----------------------------
# Context barrel file
# -----------------------------

cat > src/context/index.ts << 'CONTEXT'
// ─── Context Exports ─────────────────────────────────────────────────────────
// Export all context providers from here for clean imports
CONTEXT
echo "  ✅ src/context/index.ts"

# -----------------------------
# useLocalStorage hook
# -----------------------------

cat > src/hooks/useLocalStorage.ts << 'LOCALSTORAGE'
import { useState, useEffect } from 'react';

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') return initialValue;
    try {
      const item = window.localStorage.getItem(key);
      return item ? (JSON.parse(item) as T) : initialValue;
    } catch {
      return initialValue;
    }
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;
    try {
      window.localStorage.setItem(key, JSON.stringify(storedValue));
    } catch {
      console.warn(`useLocalStorage: could not save key "${key}"`);
    }
  }, [key, storedValue]);

  return [storedValue, setStoredValue] as const;
}
LOCALSTORAGE
echo "  ✅ src/hooks/useLocalStorage.ts"

# -----------------------------
# App route folders
# -----------------------------

echo ""
echo "📂 Creating app route groups..."

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

cat > src/app/\(dashboard\)/dashboard/loading.tsx << 'LOADING'
import LoadingSpinner from '@/components/shared/LoadingSpinner';

export default function Loading() {
  return <LoadingSpinner />;
}
LOADING
echo "  ✅ src/app/(dashboard)/dashboard/loading.tsx"

cat > src/app/\(dashboard\)/dashboard/error.tsx << 'ERROR'
'use client';

import { useEffect } from 'react';

interface ErrorProps {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function Error({ error, reset }: ErrorProps) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <main className="flex flex-col items-center justify-center p-8 gap-4">
      <p className="text-sm text-muted-foreground">Something went wrong.</p>
      <button
        onClick={reset}
        className="text-sm underline underline-offset-4 hover:text-foreground"
      >
        Try again
      </button>
    </main>
  );
}
ERROR
echo "  ✅ src/app/(dashboard)/dashboard/error.tsx"

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
# Prettier config (ESM-safe)
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
echo "  ✅ prettier.config.mjs created (ESM-safe)"

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
NEXT_PUBLIC_API_URL=

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
echo "┌─────────────────────────────────────────────────┐"
echo "│  src/                                           │"
echo "│  ├── app/                                       │"
echo "│  │   ├── (auth)/login/page.tsx                  │"
echo "│  │   ├── (dashboard)/dashboard/                 │"
echo "│  │   │   ├── page.tsx                           │"
echo "│  │   │   ├── loading.tsx                        │"
echo "│  │   │   └── error.tsx                          │"
echo "│  │   ├── layout.tsx                             │"
echo "│  │   └── page.tsx                               │"
echo "│  ├── components/                                │"
echo "│  │   ├── features/placeholder/Sidebar.tsx       │"
echo "│  │   └── shared/                                │"
echo "│  │       ├── EmptyState.tsx                     │"
echo "│  │       ├── LoadingSpinner.tsx                 │"
echo "│  │       └── PageHeader.tsx                     │"
echo "│  ├── hooks/useLocalStorage.ts                   │"
echo "│  ├── types/index.ts                             │"
echo "│  ├── context/index.ts                           │"
echo "│  ├── services/                                  │"
echo "│  │   ├── auth.service.ts                        │"
echo "│  │   └── index.ts                               │"
echo "│  ├── mocks/index.ts                             │"
echo "│  └── lib/                                       │"
echo "│      ├── api/                                   │"
echo "│      │   ├── client.ts                          │"
echo "│      │   ├── endpoints.ts                       │"
echo "│      │   └── index.ts                           │"
echo "│      └── utils.ts                               │"
echo "│                                                 │"
echo "│  docs/  (root)                                  │"
echo "└─────────────────────────────────────────────────┘"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
