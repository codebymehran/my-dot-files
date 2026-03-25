#!/bin/bash

set -e

cd "$(dirname "$0")"

echo "⚙️ Installing dotfiles..."
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

copy() {
  local src="$1"
  local dst="$2"
  local label="$3"

  read -p "  Copy $label? (Y/n): " confirm
  if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
    echo "  ⏭️  Skipped $label"
  else
    cp "$src" "$dst"
    echo "  ✅ $label"
  fi
}

# -----------------------------
# Create directories
# -----------------------------

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/Library/Application Support/Code/User/snippets"
mkdir -p "$HOME/Code/explore"
mkdir -p "$HOME/Desktop/cheatsheets"

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
copy karabiner-cheatsheet.html "$HOME/Desktop/cheatsheets/karabiner-cheatsheet.html" "karabiner-cheatsheet"
copy snippets-cheatsheet.html "$HOME/Desktop/cheatsheets/snippets-cheatsheet.html" "snippets-cheatsheet"
copy terminal-cheatsheet.html "$HOME/Desktop/cheatsheets/terminal-cheatsheet.html" "terminal-cheatsheet"

echo ""
echo "✅ Dotfiles installed successfully"
echo ""
echo "💡 To apply changes:"
echo "   • Terminal  → exec zsh (or open a new tab)"
echo "   • VS Code   → Restart VS Code"
echo "   • Karabiner → It reloads automatically"
