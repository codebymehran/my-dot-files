#!/bin/bash
mkdir -p ~/.config
mkdir -p ~/.config/karabiner
mkdir -p ~/Library/Application\ Support/Code/User/snippets

cp zshrc.sh ~/.zshrc
cp wezterm.lua ~/.wezterm.lua
cp starship.toml ~/.config/starship.toml
cp karabiner.json ~/.config/karabiner/karabiner.json
cp settings.json ~/Library/Application\ Support/Code/User/settings.json
cp keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
cp React_Snippets.code-snippets ~/Library/Application\ Support/Code/User/snippets/React_Snippets.code-snippets

source ~/.zshrc
echo "✅ Done"
