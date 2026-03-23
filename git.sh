#!/bin/bash

set -e

echo "⚙️ Configuring Git..."

# -----------------------------
# Identity
# -----------------------------

git config --global user.name "Mehran Khan"
git config --global user.email "mehran@mehrankhan.net"

# -----------------------------
# Defaults
# -----------------------------

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global pull.ff only
git config --global push.default simple
git config --global color.ui auto
git config --global core.editor "nvim"
git config --global core.autocrlf input

# -----------------------------
# Quality of life
# -----------------------------

git config --global status.branch true
git config --global status.short true
git config --global help.autocorrect 1
git config --global diff.colorMoved zebra

# -----------------------------
# Aliases
# -----------------------------

git config --global alias.s "status -sb"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.cm "commit -m"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.last "log -1 HEAD"
git config --global alias.lg "log --oneline --graph --decorate --all"

echo "✅ Git configured"
