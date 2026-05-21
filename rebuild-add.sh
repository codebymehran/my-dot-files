#!/bin/bash
# rebuild-add.sh
#
# Two modes:
#
#   1. Init — create a rebuild twin for an existing project:
#      rebuild --init my-project
#
#   2. Strip — strip logic from a file or folder into the rebuild twin:
#      rebuild src/features/tasks/components/TaskForm.tsx
#      rebuild src/features/tasks/components/
#      (run from your project root)

set -e

CODE_DIR="$HOME/Code"

# ── Init mode ────────────────────────────────────────────────────────────────

if [[ "$1" == "--init" ]]; then
  if [ -z "$2" ]; then
    echo "❌ Usage: rebuild --init <project-name>"
    exit 1
  fi

  PROJECT_NAME="$2"
  TARGET="$CODE_DIR/$PROJECT_NAME"
  REBUILD_DIR="$CODE_DIR/$PROJECT_NAME-rebuild"

  if [ ! -d "$TARGET" ]; then
    echo "❌ Project not found at $TARGET"
    exit 1
  fi

  if [ -d "$REBUILD_DIR" ]; then
    echo "❌ Rebuild twin already exists at $REBUILD_DIR"
    exit 1
  fi

  echo ""
  echo "🔁 Creating rebuild twin for: $PROJECT_NAME"
  echo "📍 Location: $REBUILD_DIR"
  echo ""

  echo "⚙️  Running create-next-app..."
  npx create-next-app@latest "$REBUILD_DIR" \
    --typescript \
    --tailwind \
    --eslint \
    --app \
    --src-dir \
    --import-alias "@/*" \
    --yes

  cd "$REBUILD_DIR"

  mkdir -p src/components src/lib src/features src/hooks src/types src/lib/api src/services

  cat > src/lib/utils.ts << 'UTILS'
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
UTILS

  [[ -f "$TARGET/src/components/LoadingSpinner.tsx" ]] && cp "$TARGET/src/components/LoadingSpinner.tsx" src/components/
  [[ -f "$TARGET/src/components/EmptyState.tsx" ]]     && cp "$TARGET/src/components/EmptyState.tsx"     src/components/
  [[ -f "$TARGET/src/components/PageHeader.tsx" ]]     && cp "$TARGET/src/components/PageHeader.tsx"     src/components/
  [[ -f "$TARGET/src/components/Dashboard.tsx" ]]      && cp "$TARGET/src/components/Dashboard.tsx"      src/components/
  [[ -f "$TARGET/src/app/layout.tsx" ]]                && cp "$TARGET/src/app/layout.tsx"                src/app/
  [[ -f "$TARGET/src/app/page.tsx" ]]                  && cp "$TARGET/src/app/page.tsx"                  src/app/
  [[ -f "$TARGET/src/app/globals.css" ]]               && cp "$TARGET/src/app/globals.css"               src/app/
  [[ -f "$TARGET/prettier.config.mjs" ]]               && cp "$TARGET/prettier.config.mjs"               .
  [[ -f "$TARGET/.env.example" ]]                      && cp "$TARGET/.env.example"                      .
  mkdir -p .vscode
  [[ -f "$TARGET/.vscode/settings.json" ]]             && cp "$TARGET/.vscode/settings.json"             .vscode/

  touch .env.local

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

  echo ""
  echo "🎨 Initialising shadcn/ui..."
  npx shadcn@latest init --yes

  echo ""
  echo "🧩 Installing shadcn components..."
  npx shadcn@latest add \
    button input card dialog form select sonner dropdown-menu \
    separator badge avatar tooltip sheet \
    tabs table skeleton alert popover \
    checkbox switch breadcrumb \
    --yes --overwrite

  echo ""
  echo "⬆️  Updating Next.js to latest..."
  npm install next@latest

  node --version > .nvmrc

  echo ""
  echo "🖥️  Opening in VS Code..."
  if command -v code &> /dev/null; then
    code "$REBUILD_DIR"
  elif [ -f "/opt/homebrew/bin/code" ]; then
    /opt/homebrew/bin/code "$REBUILD_DIR"
  elif [ -f "/usr/local/bin/code" ]; then
    /usr/local/bin/code "$REBUILD_DIR"
  else
    open -a "Visual Studio Code" "$REBUILD_DIR" || echo "⚠️  Could not open VS Code — open manually"
  fi

  echo ""
  echo "✅ Rebuild twin ready at $REBUILD_DIR"
  echo "   cd into your main project and run: rebuild src/your/feature/"
  exit 0
fi

# ── Strip mode ───────────────────────────────────────────────────────────────

if [ -z "$1" ]; then
  echo "❌ Usage:"
  echo "   rebuild --init <project-name>   → create rebuild twin for existing project"
  echo "   rebuild <file.tsx>              → strip single file (run from project root)"
  echo "   rebuild <folder/>               → strip all files in folder"
  exit 1
fi

INPUT="$1"

PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
REBUILD_DIR="$(dirname "$PROJECT_DIR")/$PROJECT_NAME-rebuild"

if [ ! -d "$REBUILD_DIR" ]; then
  echo "❌ Rebuild twin not found at $REBUILD_DIR"
  echo "   Run: rebuild --init $PROJECT_NAME"
  exit 1
fi

# ── Python stripper — keeps imports + JSX only ───────────────────────────────

strip_file() {
  local SRC="$1"

  if [ ! -f "$SRC" ]; then
    echo "  ⚠️  Skipping (not found): $SRC"
    return
  fi

  local DEST="$REBUILD_DIR/$SRC"
  mkdir -p "$(dirname "$DEST")"

  python3 - "$SRC" "$DEST" << 'PYSTRIP'
import re, sys

src_path, dest_path = sys.argv[1], sys.argv[2]
with open(src_path) as f:
    content = f.read()

lines = content.splitlines(keepends=True)

# Collect import lines and 'use client' directive
imports = []
for line in lines:
    if re.match(r"^\s*(import\s|'use client'|\"use client\")", line):
        imports.append(line)

# Find the last return (...) block — handles early returns like `if (!x) return null`
return_matches = list(re.finditer(r'\breturn\s*\(', content))
if not return_matches:
    func_match = re.search(r'export default function (\w+)\s*\(', content)
    func_name = func_match.group(1) if func_match else 'Component'
    with open(dest_path, 'w') as f:
        f.writelines(imports)
        f.write(f'\nexport default function {func_name}() {{\n  return null;\n}}\n')
    sys.exit(0)

# Extract the full return block via brace/paren depth tracking
start = return_matches[-1].start()
depth = 0
i = return_matches[-1].end() - 1
while i < len(content):
    if content[i] == '(':
        depth += 1
    elif content[i] == ')':
        depth -= 1
        if depth == 0:
            jsx_end = i + 1
            break
    i += 1

jsx_block = content[start:jsx_end]

# Strip any prop whose value is a {expression} — covers all handlers, state, variables
# Leaves string props like className="..." title="..." and bare values like type='submit'
jsx_block = re.sub(r'\s+\w+=\{[^}]*\}', '', jsx_block)

# Clean up self-closing tags left with trailing whitespace before />
jsx_block = re.sub(r'\s*\n\s*(/?>)', r'\1', jsx_block)

# Get component function name
func_match = re.search(r'export default function (\w+)\s*\(', content)
func_name = func_match.group(1) if func_match else 'Component'

with open(dest_path, 'w') as f:
    f.writelines(imports)
    f.write(f'\nexport default function {func_name}() {{\n')
    f.write(f'  {jsx_block.strip()}\n')
    f.write('}\n')
PYSTRIP

  echo "  ✅ $SRC"
}

# ── Dispatch: file or folder ──────────────────────────────────────────────────

if [ -f "$INPUT" ]; then
  echo ""
  strip_file "$INPUT"
  echo ""
  echo "Done. Switch to the rebuild twin and fill in the logic when ready."

elif [ -d "$INPUT" ]; then
  FILES=$(find "$INPUT" -type f \( -name "*.tsx" -o -name "*.ts" \) | sort)

  if [ -z "$FILES" ]; then
    echo "⚠️  No .tsx/.ts files found in $INPUT"
    exit 1
  fi

  COUNT=$(echo "$FILES" | wc -l | tr -d ' ')
  echo ""
  echo "✂️  Stripping $COUNT file(s) from $INPUT..."
  echo ""

  while IFS= read -r file; do
    strip_file "$file"
  done <<< "$FILES"

  echo ""
  echo "Done — $COUNT file(s) stripped into $REBUILD_DIR/$INPUT"
  echo "Switch to the rebuild twin and fill in the logic when ready."

else
  echo "❌ Not a file or folder: $INPUT"
  exit 1
fi
