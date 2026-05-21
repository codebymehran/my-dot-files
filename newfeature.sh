#!/bin/bash

# ============================================================================
# newfeature.sh
# Scaffolds or deletes a feature folder inside an existing Next.js project
# Run from project root: newfeature <feature-name>
#                        newfeature --delete <feature-name>
#
# Creates:
#   src/features/<name>/
#   ├── components/        → UI components for this feature
#   ├── hooks/             → custom hooks (e.g. useTaskForm)
#   ├── types/             → TypeScript types/interfaces
#   ├── services/          → API calls for this feature
#   ├── schema.ts          → Zod validation schemas
#   ├── utils.ts           → feature-specific helpers
#   └── index.ts           → public API — export only what other features need
# ============================================================================

set -e

# -----------------------------
# Validate
# -----------------------------

if [ -z "$1" ]; then
  echo "❌ Usage: newfeature <feature-name>"
  echo "          newfeature --delete <feature-name>"
  echo "   Run from your project root"
  exit 1
fi

# -----------------------------
# Delete mode
# -----------------------------

if [[ "$1" == "--delete" ]]; then
  if [ -z "$2" ]; then
    echo "❌ Usage: newfeature --delete <feature-name>"
    exit 1
  fi

  FEATURE_NAME="$2"
  FEATURE_DIR="src/features/$FEATURE_NAME"

  if [ ! -f "package.json" ]; then
    echo "❌ No package.json found — run from your project root"
    exit 1
  fi

  if [ ! -d "$FEATURE_DIR" ]; then
    echo "❌ Feature '$FEATURE_NAME' not found at $FEATURE_DIR"
    exit 1
  fi

  echo ""
  echo "⚠️  This will permanently delete: $FEATURE_DIR"
  read -r -p "   Are you sure? [y/N] " confirm
  confirm="${confirm:-n}"

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$FEATURE_DIR"
    echo ""
    echo "🗑️  Deleted $FEATURE_DIR"
    echo ""
  else
    echo ""
    echo "⏭️  Cancelled — nothing was deleted"
    echo ""
  fi

  exit 0
fi

FEATURE_NAME="$1"
FEATURES_DIR="src/features"
FEATURE_DIR="$FEATURES_DIR/$FEATURE_NAME"

# Must be run from a Next.js project root
if [ ! -f "package.json" ]; then
  echo "❌ No package.json found — run from your project root"
  exit 1
fi

if [ ! -d "$FEATURES_DIR" ]; then
  echo "❌ src/features/ not found — is this a feature-based project?"
  exit 1
fi

if [ -d "$FEATURE_DIR" ]; then
  echo "❌ Feature '$FEATURE_NAME' already exists at $FEATURE_DIR"
  exit 1
fi

# -----------------------------
# Scaffold folders
# -----------------------------

echo ""
echo "🗂️  Scaffolding feature: $FEATURE_NAME"
echo "📍 $FEATURE_DIR/"
echo ""

mkdir -p "$FEATURE_DIR/components"
mkdir -p "$FEATURE_DIR/hooks"
mkdir -p "$FEATURE_DIR/types"
mkdir -p "$FEATURE_DIR/services"

# -----------------------------
# types/index.ts
# -----------------------------

cat > "$FEATURE_DIR/types/index.ts" << TYPES
// Types and interfaces for the $FEATURE_NAME feature

export type ${FEATURE_NAME^}Status = 'idle' | 'loading' | 'error'
TYPES
echo "  ✅ types/index.ts"

# -----------------------------
# schema.ts
# -----------------------------

cat > "$FEATURE_DIR/schema.ts" << SCHEMA
import { z } from 'zod'

// Validation schemas for the $FEATURE_NAME feature
// Usage: schema.parse(data) — throws if invalid
//        schema.safeParse(data) — returns { success, data, error }

export const ${FEATURE_NAME}Schema = z.object({
  // define your shape here
})

export type ${FEATURE_NAME^}FormData = z.infer<typeof ${FEATURE_NAME}Schema>
SCHEMA
echo "  ✅ schema.ts"

# -----------------------------
# utils.ts
# -----------------------------

cat > "$FEATURE_DIR/utils.ts" << UTILS
// Helper functions for the $FEATURE_NAME feature
// Keep these pure (no side effects, no API calls)
UTILS
echo "  ✅ utils.ts"

# -----------------------------
# services/index.ts
# -----------------------------

cat > "$FEATURE_DIR/services/index.ts" << SERVICES
// API calls for the $FEATURE_NAME feature
// These should be called from hooks, not directly from components

// example:
// export async function fetch${FEATURE_NAME^}() {
//   const res = await fetch('/api/$FEATURE_NAME')
//   if (!res.ok) throw new Error('Failed to fetch')
//   return res.json()
// }
SERVICES
echo "  ✅ services/index.ts"

# -----------------------------
# hooks/use${FEATURE_NAME^}.ts
# -----------------------------

# Capitalise first letter for the hook filename
HOOK_NAME="use${FEATURE_NAME^}"

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

# -----------------------------
# index.ts — public API
# -----------------------------

cat > "$FEATURE_DIR/index.ts" << INDEX
// Public API for the $FEATURE_NAME feature
// Only export what other features or pages need to consume
// Keep implementation details (hooks, utils) unexported unless needed

export * from './types'
INDEX
echo "  ✅ index.ts"

# -----------------------------
# Check if Zod is installed, offer to install if not
# -----------------------------

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

# -----------------------------
# Done
# -----------------------------

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
