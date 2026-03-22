#!/bin/bash
cp zshrc_config.sh ~/.zshrc
cp .wezterm.lua ~/.wezterm.lua
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml
cp settings.json ~/Library/Application\ Support/Code/User/settings.json
cp keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
source ~/.zshrc
echo "✅ Done"
