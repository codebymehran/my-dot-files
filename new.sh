#!/bin/bash

# ============================================================================
# new.sh
# Scaffold things inside an existing Next.js project
# Run from project root
#
# Usage:
#   new feature <name>              → scaffold src/features/<name>/
#   new feature --delete <name>     → delete src/features/<name>/
#   new feature --rename <old> <new>→ rename a feature folder
#   new feature --list              → list all features
#   new page <name>                 → scaffold src/app/<name>/page.tsx + loading.tsx + error.tsx
#   new api <name>                  → scaffold src/app/api/<name>/route.ts
#   new component <name>            → scaffold src/components/<name>.tsx
# ============================================================================

set -e

# -----------------------------
# Helpers
# -----------------------------

check_project_root() {
  if [ ! -f "package.json" ]; then
    echo "❌ No package.json found — run from your project root"
    exit 1
  fi
}

capitalise() {
  echo "$(tr '[:lower:]' '[:upper:]' <<< "${1:0:1}")${1:1}"
}

# -----------------------------
# Usage
# -----------------------------

usage() {
  echo ""
  echo "Usage:"
  echo "  new feature <name>               → scaffold src/features/<name>/"
  echo "  new feature --delete <name>      → delete a feature"
  echo "  new feature --rename <old> <new> → rename a feature"
  echo "  new feature --list               → list all features"
  echo "  new page <name>                  → scaffold src/app/<name>/"
  echo "  new api <name>                   → scaffold src/app/api/<name>/route.ts"
  echo "  new component <name>             → scaffold src/components/<name>.tsx"
  echo ""
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

TYPE="$1"
shift

# ============================================================================
# FEATURE
# ============================================================================

if [[ "$TYPE" == "feature" ]]; then

  check_project_root

  FEATURES_DIR="src/features"

  if [ ! -d "$FEATURES_DIR" ]; then
    echo "❌ src/features/ not found — is this a feature-based project?"
    exit 1
  fi

  # -- List --
  if [[ "$1" == "--list" ]]; then
    echo ""
    echo "📂 Features in $FEATURES_DIR/:"
    echo ""
    if [ -z "$(ls -A $FEATURES_DIR 2>/dev/null)" ]; then
      echo "  (none yet)"
    else
      for dir in "$FEATURES_DIR"/*/; do
        echo "  • $(basename "$dir")"
      done
    fi
    echo ""
    exit 0
  fi

  # -- Delete --
  if [[ "$1" == "--delete" ]]; then
    if [ -z "$2" ]; then
      echo "❌ Usage: new feature --delete <name>"
      exit 1
    fi
    FEATURE_DIR="$FEATURES_DIR/$2"
    if [ ! -d "$FEATURE_DIR" ]; then
      echo "❌ Feature '$2' not found at $FEATURE_DIR"
      exit 1
    fi
    echo ""
    echo "⚠️  This will permanently delete: $FEATURE_DIR"
    read -r -p "   Are you sure? [y/N] " confirm
    confirm="${confirm:-n}"
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      trash "$FEATURE_DIR"
      echo ""
      echo "🗑️  Moved $FEATURE_DIR to Trash"
      echo ""
    else
      echo ""
      echo "⏭️  Cancelled — nothing was deleted"
      echo ""
    fi
    exit 0
  fi

  # -- Rename --
  if [[ "$1" == "--rename" ]]; then
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "❌ Usage: new feature --rename <old> <new>"
      exit 1
    fi
    OLD_DIR="$FEATURES_DIR/$2"
    NEW_DIR="$FEATURES_DIR/$3"
    if [ ! -d "$OLD_DIR" ]; then
      echo "❌ Feature '$2' not found at $OLD_DIR"
      exit 1
    fi
    if [ -d "$NEW_DIR" ]; then
      echo "❌ Feature '$3' already exists at $NEW_DIR"
      exit 1
    fi
    mv "$OLD_DIR" "$NEW_DIR"
    echo ""
    echo "✅ Renamed '$2' → '$3'"
    echo ""
    exit 0
  fi

  # -- Create --
  if [ -z "$1" ]; then
    echo "❌ Usage: new feature <name>"
    exit 1
  fi

  FEATURE_NAME="$1"
  FEATURE_DIR="$FEATURES_DIR/$FEATURE_NAME"
  CAPITALISED=$(capitalise "$FEATURE_NAME")

  if [ -d "$FEATURE_DIR" ]; then
    echo "❌ Feature '$FEATURE_NAME' already exists at $FEATURE_DIR"
    exit 1
  fi

  echo ""
  echo "🗂️  Scaffolding feature: $FEATURE_NAME"
  echo "📍 $FEATURE_DIR/"
  echo ""

  mkdir -p "$FEATURE_DIR/components"
  mkdir -p "$FEATURE_DIR/hooks"
  mkdir -p "$FEATURE_DIR/types"
  mkdir -p "$FEATURE_DIR/services"

  cat > "$FEATURE_DIR/types/index.ts" << TYPES
// Types and interfaces for the $FEATURE_NAME feature

export type ${CAPITALISED}Status = 'idle' | 'loading' | 'error'
TYPES
  echo "  ✅ types/index.ts"

  cat > "$FEATURE_DIR/schema.ts" << SCHEMA
import { z } from 'zod'

// Validation schemas for the $FEATURE_NAME feature
// Usage: schema.parse(data) — throws if invalid
//        schema.safeParse(data) — returns { success, data, error }

export const ${FEATURE_NAME}Schema = z.object({
  // define your shape here
})

export type ${CAPITALISED}FormData = z.infer<typeof ${FEATURE_NAME}Schema>
SCHEMA
  echo "  ✅ schema.ts"

  cat > "$FEATURE_DIR/utils.ts" << UTILS
// Helper functions for the $FEATURE_NAME feature
// Keep these pure (no side effects, no API calls)
UTILS
  echo "  ✅ utils.ts"

  cat > "$FEATURE_DIR/services/index.ts" << SERVICES
// API calls for the $FEATURE_NAME feature
// These should be called from hooks, not directly from components

// example:
// export async function fetch${CAPITALISED}() {
//   const res = await fetch('/api/$FEATURE_NAME')
//   if (!res.ok) throw new Error('Failed to fetch')
//   return res.json()
// }
SERVICES
  echo "  ✅ services/index.ts"

  HOOK_NAME="use${CAPITALISED}"

  cat > "$FEATURE_DIR/hooks/$HOOK_NAME.ts" << HOOK
'use client'
import { useState } from 'react'

export function $HOOK_NAME() {
  // state

  // handlers

  return {}
}
HOOK
  echo "  ✅ hooks/$HOOK_NAME.ts"

  cat > "$FEATURE_DIR/index.ts" << INDEX
// Public API for the $FEATURE_NAME feature
// Only export what other features or pages need to consume
// Keep implementation details (hooks, utils) unexported unless needed

export * from './types'
INDEX
  echo "  ✅ index.ts"

  if ! grep -q '"zod"' package.json 2>/dev/null; then
    echo ""
    read -r -p "⚠️  Zod not found in package.json — install it now? [Y/n] " install_zod
    install_zod="${install_zod:-y}"
    if [[ "$install_zod" =~ ^[Yy]$ ]]; then
      npm install zod
      echo "  ✅ zod installed"
    else
      echo "  ⏭️  Skipped — add it later with: npm install zod"
    fi
  fi

  echo ""
  echo "✅ Feature ready!"
  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  src/features/$FEATURE_NAME/$(printf '%*s' $((26 - ${#FEATURE_NAME})) '')│"
  echo "│  ├── components/                        │"
  echo "│  ├── hooks/                             │"
  echo "│  │   └── $HOOK_NAME.ts$(printf '%*s' $((22 - ${#HOOK_NAME})) '')│"
  echo "│  ├── services/                          │"
  echo "│  │   └── index.ts                       │"
  echo "│  ├── types/                             │"
  echo "│  │   └── index.ts                       │"
  echo "│  ├── schema.ts                          │"
  echo "│  ├── utils.ts                           │"
  echo "│  └── index.ts                           │"
  echo "└─────────────────────────────────────────┘"
  echo ""
  echo "💡 Tips:"
  echo "   • Add types to types/index.ts first — everything else depends on them"
  echo "   • Keep API calls in services/, call them from hooks only"
  echo "   • Export from index.ts only what pages/other features need"
  echo "   • schema.ts is for form validation with Zod"

  exit 0
fi

# ============================================================================
# PAGE
# ============================================================================

if [[ "$TYPE" == "page" ]]; then

  check_project_root

  if [ -z "$1" ]; then
    echo "❌ Usage: new page <name>"
    exit 1
  fi

  if [ ! -d "src/app" ]; then
    echo "❌ src/app/ not found — is this a Next.js App Router project?"
    exit 1
  fi

  PAGE_NAME="$1"
  PAGE_DIR="src/app/$PAGE_NAME"
  CAPITALISED=$(capitalise "$PAGE_NAME")

  if [ -d "$PAGE_DIR" ]; then
    echo "❌ Page '$PAGE_NAME' already exists at $PAGE_DIR"
    exit 1
  fi

  mkdir -p "$PAGE_DIR"

  cat > "$PAGE_DIR/page.tsx" << PAGE
export default function ${CAPITALISED}Page() {
  return (
    <main>
      <h1>${CAPITALISED}</h1>
    </main>
  )
}
PAGE

  cat > "$PAGE_DIR/loading.tsx" << LOADING
export default function ${CAPITALISED}Loading() {
  return <div>Loading...</div>
}
LOADING

  cat > "$PAGE_DIR/error.tsx" << ERROR
'use client'
import { useEffect } from 'react'

export default function ${CAPITALISED}Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div>
      <h2>Something went wrong</h2>
      <button onClick={reset}>Try again</button>
    </div>
  )
}
ERROR

  echo ""
  echo "✅ Page ready!"
  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  src/app/$PAGE_NAME/$(printf '%*s' $((30 - ${#PAGE_NAME})) '')│"
  echo "│  ├── page.tsx                           │"
  echo "│  ├── loading.tsx                        │"
  echo "│  └── error.tsx                          │"
  echo "└─────────────────────────────────────────┘"
  echo ""

  exit 0
fi

# ============================================================================
# API
# ============================================================================

if [[ "$TYPE" == "api" ]]; then

  check_project_root

  if [ -z "$1" ]; then
    echo "❌ Usage: new api <name>"
    exit 1
  fi

  if [ ! -d "src/app" ]; then
    echo "❌ src/app/ not found — is this a Next.js App Router project?"
    exit 1
  fi

  API_NAME="$1"
  API_DIR="src/app/api/$API_NAME"
  CAPITALISED=$(capitalise "$API_NAME")

  if [ -d "$API_DIR" ]; then
    echo "❌ API route '$API_NAME' already exists at $API_DIR"
    exit 1
  fi

  mkdir -p "$API_DIR"

  cat > "$API_DIR/route.ts" << ROUTE
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
  try {
    // const { searchParams } = new URL(req.url)

    return NextResponse.json({ data: null })
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch' }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    // const body = await req.json()

    return NextResponse.json({ data: null }, { status: 201 })
  } catch (error) {
    return NextResponse.json({ error: 'Failed to create' }, { status: 500 })
  }
}
ROUTE

  echo ""
  echo "✅ API route ready!"
  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  src/app/api/$API_NAME/$(printf '%*s' $((27 - ${#API_NAME})) '')│"
  echo "│  └── route.ts  (GET + POST)             │"
  echo "└─────────────────────────────────────────┘"
  echo ""
  echo "💡 Tips:"
  echo "   • Add more methods (PUT, DELETE) as needed"
  echo "   • Validate request body with Zod before using it"

  exit 0
fi

# ============================================================================
# COMPONENT
# ============================================================================

if [[ "$TYPE" == "component" ]]; then

  check_project_root

  if [ -z "$1" ]; then
    echo "❌ Usage: new component <name>"
    exit 1
  fi

  COMPONENT_NAME="$1"
  CAPITALISED=$(capitalise "$COMPONENT_NAME")
  COMPONENTS_DIR="src/components"
  COMPONENT_FILE="$COMPONENTS_DIR/$CAPITALISED.tsx"

  mkdir -p "$COMPONENTS_DIR"

  if [ -f "$COMPONENT_FILE" ]; then
    echo "❌ Component '$CAPITALISED' already exists at $COMPONENT_FILE"
    exit 1
  fi

  cat > "$COMPONENT_FILE" << COMPONENT
type ${CAPITALISED}Props = {
  //
}

export function ${CAPITALISED}({}: ${CAPITALISED}Props) {
  return (
    <div>
      {/* $CAPITALISED */}
    </div>
  )
}
COMPONENT

  echo ""
  echo "✅ Component ready!"
  echo ""
  echo "  src/components/$CAPITALISED.tsx"
  echo ""
  echo "💡 Tips:"
  echo "   • Add 'use client' at the top if you need state or event handlers"
  echo "   • Export from src/components/index.ts if you have one"

  exit 0
fi

# ============================================================================
# Unknown type
# ============================================================================

echo "❌ Unknown type: $TYPE"
usage
