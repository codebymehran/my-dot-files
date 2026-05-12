#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Express App
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🛠️
# @raycast.argument1 { "type": "text", "placeholder": "project-name" }

# Documentation:
# @raycast.description Scaffolds a minimal Express + TypeScript API project

set -e

# ============================================================================
# new-express-app.sh
# Minimal Express + TypeScript starter — for learning and small APIs
# Usage: bash new-express-app.sh <project-name>
# ============================================================================

# -----------------------------
# Validate input
# -----------------------------

if [ -z "$1" ]; then
  echo "❌ Usage: bash new-express-app.sh <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
TARGET="$HOME/Code/$PROJECT_NAME"

if [ -d "$TARGET" ]; then
  echo "❌ '$TARGET' already exists — choose a different name"
  exit 1
fi

echo ""
echo "🛠️  Creating Express project: $PROJECT_NAME"
echo "📍 Location: $TARGET"
echo ""

# -----------------------------
# Create project folder
# -----------------------------

mkdir -p "$TARGET"
cd "$TARGET"

# -----------------------------
# package.json
# -----------------------------

echo "⚙️  Initialising package.json..."

cat > package.json << 'PKG'
{
  "name": "express-app",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "nodemon",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
PKG
echo "  ✅ package.json"

# -----------------------------
# Install dependencies
# -----------------------------

echo ""
echo "📦 Installing dependencies..."
npm install express
echo "  ✅ express"

echo ""
echo "📦 Installing dev dependencies..."
npm install --save-dev typescript @types/node @types/express tsx nodemon
echo "  ✅ typescript, @types/node, @types/express, tsx, nodemon"

# -----------------------------
# tsconfig.json
# -----------------------------

echo ""
echo "🔧 Creating tsconfig.json..."

cat > tsconfig.json << 'TSC'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
TSC
echo "  ✅ tsconfig.json"

# -----------------------------
# nodemon.json
# -----------------------------

echo ""
echo "🔧 Creating nodemon.json..."

cat > nodemon.json << 'NODEMON'
{
  "watch": ["src"],
  "ext": "ts",
  "exec": "tsx src/index.ts"
}
NODEMON
echo "  ✅ nodemon.json (watches src/, runs tsx)"

# -----------------------------
# Folder structure
# -----------------------------

echo ""
echo "📁 Creating folder structure..."

mkdir -p src/routes
mkdir -p src/middleware

echo "  ✅ src/routes"
echo "  ✅ src/middleware"

# -----------------------------
# Entry point
# -----------------------------

echo ""
echo "🧩 Scaffolding source files..."

cat > src/index.ts << 'INDEX'
import express from 'express';
import { router as exampleRouter } from './routes/example';

const app = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ──────────────────────────────────────────────────────────────
app.use(express.json()); // Parse JSON request bodies

// ── Routes ──────────────────────────────────────────────────────────────────
app.use('/api/example', exampleRouter);

// ── Health check ────────────────────────────────────────────────────────────
app.get('/', (_req, res) => {
  res.json({ message: 'Server is running 🚀' });
});

// ── Start ────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 Server running at http://localhost:${PORT}\n`);
});
INDEX
echo "  ✅ src/index.ts"

# -----------------------------
# Example route
# -----------------------------

cat > src/routes/example.ts << 'ROUTE'
import { Router, Request, Response } from 'express';

export const router = Router();

// GET /api/example
router.get('/', (_req: Request, res: Response) => {
  res.json({ message: 'Hello from the example route!' });
});

// GET /api/example/:id
router.get('/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  res.json({ message: `You requested item with id: ${id}` });
});

// POST /api/example
router.post('/', (req: Request, res: Response) => {
  const body = req.body;
  res.status(201).json({ message: 'Created!', received: body });
});
ROUTE
echo "  ✅ src/routes/example.ts"

# -----------------------------
# Request logger middleware
# -----------------------------

cat > src/middleware/logger.ts << 'LOGGER'
import { Request, Response, NextFunction } from 'express';

// Simple request logger — add to app.use() in index.ts when you need it
export function logger(req: Request, _res: Response, next: NextFunction) {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
}
LOGGER
echo "  ✅ src/middleware/logger.ts"

# -----------------------------
# .env files
# -----------------------------

echo ""
echo "🔐 Creating .env files..."
touch .env.local

cat > .env.example << 'ENV'
# Copy this file to .env.local and fill in the values

PORT=3000

# Add your keys below
# DATABASE_URL=
# JWT_SECRET=
ENV
echo "  ✅ .env.local"
echo "  ✅ .env.example"

# -----------------------------
# .gitignore
# -----------------------------

echo ""
echo "📝 Creating .gitignore..."

cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/

# Build output
dist/

# Environment
.env.local
.env.*.local

# macOS
.DS_Store

# Logs
*.log
npm-debug.log*

# Editor
.vscode/settings.json
GITIGNORE
echo "  ✅ .gitignore"

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
  }
}
VSCODE
echo "  ✅ .vscode/settings.json"

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
echo "  ✅ prettier.config.mjs"

# -----------------------------
# .nvmrc
# -----------------------------

echo ""
echo "📌 Creating .nvmrc..."
node --version > .nvmrc
echo "  ✅ .nvmrc ($(node --version))"

# -----------------------------
# Git — clean initial commit
# -----------------------------

echo ""
echo "🔧 Initialising git..."
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
echo "│  ├── index.ts                   │"
echo "│  ├── routes/                    │"
echo "│  │   └── example.ts             │"
echo "│  └── middleware/                │"
echo "│      └── logger.ts              │"
echo "└─────────────────────────────────┘"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 Test your API:"
echo "   GET  http://localhost:3000/"
echo "   GET  http://localhost:3000/api/example"
echo "   GET  http://localhost:3000/api/example/123"
echo "   POST http://localhost:3000/api/example"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
echo ""
echo "💡 As your project grows, add:"
echo "   src/controllers/   → move route logic here"
echo "   src/services/      → business logic"
echo "   src/types/         → shared TypeScript types"
echo "   src/lib/           → utilities and helpers"
