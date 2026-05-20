#!/bin/bash
cd "$(dirname "$0")"

# -----------------------------
# Flags
# -----------------------------
YES_ALL=false
for arg in "$@"; do
  if [[ "$arg" == "--yes" || "$arg" == "-y" ]]; then
    YES_ALL=true
  fi
done

echo "⚙️ Installing dotfiles..."
[[ "$YES_ALL" == true ]] && echo "   (auto-confirming all)" || echo "   (pass -y to auto-confirm all)"
echo ""

# -----------------------------
# Auto-backup Karabiner config
# -----------------------------
if [[ -f "$HOME/.config/karabiner/karabiner.json" ]]; then
  cp "$HOME/.config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json.backup"
  echo "💾 Karabiner config backed up → karabiner.json.backup"
  echo ""
fi

# -----------------------------
# Helper
# -----------------------------
SKIPPED=()
COPIED=()
MISSING=()

copy() {
  local src="$1"
  local dst="$2"
  local label="$3"

  # Check source file exists
  if [[ ! -f "$src" ]]; then
    echo "  ⚠️  Missing source: $src — skipping $label"
    MISSING+=("$label ($src)")
    return
  fi

  # Warn if destination already exists
  local overwrite_note=""
  if [[ -f "$dst" ]]; then
    overwrite_note=" [will overwrite existing]"
  fi

  if [[ "$YES_ALL" == true ]]; then
    confirm="y"
  else
    read -p "  Copy $label?$overwrite_note (Y/n): " confirm
  fi

  if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
    echo "  ⏭️  Skipped $label"
    SKIPPED+=("$label")
  else
    cp "$src" "$dst"
    echo "  ✅ $label"
    COPIED+=("$label")
  fi
}

# -----------------------------
# Create directories
# -----------------------------
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/.config/raycast/snippets"
mkdir -p "$HOME/Library/Application Support/Code/User/snippets"
mkdir -p "$HOME/Code/explore"
mkdir -p "$HOME/Desktop/cheatsheets"
mkdir -p "$HOME/Desktop/resources"

# -----------------------------
# Copy files
# -----------------------------
echo "📂 Select files to copy (press Enter to confirm, n to skip):"
echo ""
copy zshrc.sh "$HOME/.zshrc" "zshrc"
copy wezterm.lua "$HOME/.wezterm.lua" "wezterm.lua"
copy starship.toml "$HOME/.config/starship.toml" "starship.toml"
copy karabiner.json "$HOME/.config/karabiner/karabiner.json" "karabiner.json"
copy settings.json "$HOME/Library/Application Support/Code/User/settings.json" "VS Code settings"
copy keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json" "VS Code keybindings"
copy React_Snippets.code-snippets "$HOME/Library/Application Support/Code/User/snippets/React_Snippets.code-snippets" "React snippets"

echo ""
echo "📄 Cheatsheets:"
echo ""
copy karabiner-cheatsheet.html "$HOME/Desktop/cheatsheets/karabiner-cheatsheet.html" "karabiner-cheatsheet"
copy snippets-cheatsheet.html "$HOME/Desktop/cheatsheets/snippets-cheatsheet.html" "snippets-cheatsheet"
copy terminal-cheatsheet.html "$HOME/Desktop/cheatsheets/terminal-cheatsheet.html" "terminal-cheatsheet"
copy vscode-cheatsheet.html "$HOME/Desktop/cheatsheets/vscode-cheatsheet.html" "vscode-cheatsheet"
copy ai_snippet_cheatsheet.html "$HOME/Desktop/cheatsheets/ai_snippet_cheatsheet.html" "ai-snippet-cheatsheet"

echo ""
echo "📚 Resources:"
echo ""
copy raycast_snippets.json "$HOME/.config/raycast/snippets/raycast_snippets.json" "Raycast snippets"
copy react-nextjs-patterns.pdf "$HOME/Desktop/resources/react-nextjs-patterns.pdf" "react-nextjs-patterns"
copy react-nextjs-resources.pdf "$HOME/Desktop/resources/react-nextjs-resources.pdf" "react-nextjs-resources"
copy github-and-communities.pdf "$HOME/Desktop/resources/github-and-communities.pdf" "github-and-communities"
copy react-nextjs-roadmap.pdf "$HOME/Desktop/resources/react-nextjs-roadmap.pdf" "react-nextjs-roadmap"

# -----------------------------
# Make scripts executable
# -----------------------------
echo ""
echo "🔧 Making scripts executable..."
chmod +x ./*.sh
echo "  ✅ Scripts are ready"

# -----------------------------
# Summary
# -----------------------------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Copied:  ${#COPIED[@]} file(s)"
echo "  ⏭️  Skipped: ${#SKIPPED[@]} file(s)"
echo "  ⚠️  Missing: ${#MISSING[@]} file(s)"

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo ""
  echo "  Missing source files:"
  for m in "${MISSING[@]}"; do
    echo "    • $m"
  done
fi

echo ""
echo "✅ Dotfiles installed successfully"
echo ""
echo "💡 To apply changes:"
echo "   • Terminal  → exec zsh (or open a new tab)"
echo "   • VS Code   → Restart VS Code"
echo "   • Karabiner → It reloads automatically"
echo "   • Raycast   → Raycast Settings → Snippets → Import → ~/.config/raycast/snippets/raycast_snippets.json"
echo ""
echo "⚡ Available scripts:"
echo "   nna <name>       → Create new Next.js project"
echo "   nnab <name>      → Create new Next.js project (basic, + optional rebuild twin)"
echo "   rebuild <path>   → Strip component logic into rebuild twin (file or folder)"
echo "   clone <url>      → Clone & explore any GitHub repo"
echo "   cloneown <url>   → Clone your own repo into ~/Code"
echo "   repodelete       → Delete local folder + GitHub repo"
echo "   dotinstall       → Pull GitHub dot file changes & reinstall"
