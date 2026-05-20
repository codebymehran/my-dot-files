#!/bin/bash
# rebuild-add.sh
# Strips logic from a component (or all components in a folder) and drops
# them into the -rebuild twin.
#
# Run from your project root:
#   rebuild src/features/tasks/components/TaskForm.tsx   # single file
#   rebuild src/features/tasks/components/               # entire folder
#
# What gets removed:
#   - useState / useEffect / useCallback / useMemo calls
#   - Handler function bodies (kept as empty shells)
#   - value= / onChange= / onValueChange= / onClick= / onCheckedChange= props
#   - Props type definitions and their destructuring in the function signature

set -e

if [ -z "$1" ]; then
  echo "❌ Usage: rebuild <path/to/Component.tsx|folder/>"
  echo "   Run from your project root (cd ~/Code/my-project first)"
  exit 1
fi

INPUT="$1"

# Derive rebuild twin from current working directory
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
REBUILD_DIR="$(dirname "$PROJECT_DIR")/$PROJECT_NAME-rebuild"

if [ ! -d "$REBUILD_DIR" ]; then
  echo "❌ Rebuild twin not found at $REBUILD_DIR"
  echo "   Did you scaffold with -rebuild? Make sure you're in the project root."
  exit 1
fi

# ── Python strip function ────────────────────────────────────────────────────

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
    lines = f.readlines()

out = []
skip_block = 0
skip_type  = False

for line in lines:
    stripped = line.strip()

    # Remove Props type/interface definitions
    if re.match(r'^(type|interface)\s+\w+Props\s*[={]', stripped):
        skip_type = True
    if skip_type:
        out.append('\n')
        if stripped.endswith('}') or stripped.endswith('};'):
            skip_type = False
        continue

    # Remove useState / useEffect / useCallback / useMemo
    if re.match(r'^\s*const\s+\[.*\]\s*=\s*use(State|Reducer)\(', line) or \
       re.match(r'^\s*use(Effect|Callback|Memo)\(', line):
        out.append('\n')
        continue

    # Remove derived state consts (isEditing, etc.)
    if re.match(r'^\s*const\s+\w+\s*=\s*(editingId|.*\.id\b)', line):
        out.append('\n')
        continue

    # Empty out handler function bodies, keep the signature line
    handler_start = re.match(r'^(\s*)(function\s+handle\w+|const\s+handle\w+\s*=)', line)
    if handler_start and '{' in line:
        brace_idx = line.index('{')
        out.append(line[:brace_idx + 1] + '\n')
        skip_block = 1
        for ch in line[brace_idx + 1:]:
            if ch == '{': skip_block += 1
            if ch == '}': skip_block -= 1
        continue

    if skip_block > 0:
        for ch in line:
            if ch == '{': skip_block += 1
            if ch == '}':
                skip_block -= 1
                if skip_block == 0:
                    out.append('}\n\n')
                    break
        continue

    # Strip event/value wiring props from JSX
    line = re.sub(r'\s*(value|checked|onChange|onValueChange|onClick|onCheckedChange|onSubmit)=\{[^}]*\}', '', line)

    # Strip prop destructuring from function signature
    line = re.sub(r'\(\s*\{[^}]*\}\s*(?::\s*\w+Props)?\s*\)', '()', line)

    out.append(line)

with open(dest_path, 'w') as f:
    f.writelines(out)
PYSTRIP

  echo "  ✅ $SRC"
}

# ── Single file or folder ────────────────────────────────────────────────────

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
