#!/bin/bash

set -e

echo "⚙️ Installing dotfiles..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/Library/Application Support/Code/User/snippets"

cp zshrc.sh "$HOME/.zshrc"
cp wezterm.lua "$HOME/.wezterm.lua"
cp starship.toml "$HOME/.config/starship.toml"
cp karabiner.json "$HOME/.config/karabiner/karabiner.json"
cp settings.json "$HOME/Library/Application Support/Code/User/settings.json"
cp keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
cp React_Snippets.code-snippets "$HOME/Library/Application Support/Code/User/snippets/React_Snippets.code-snippets"

echo "✅ Dotfiles installed successfully"
echo "👉 Run: exec zsh"
