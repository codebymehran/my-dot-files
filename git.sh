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

# Rebase local commits on top of pulled changes (cleaner history than merge)
# If you prefer merge commits, change to: pull.rebase false
git config --global pull.rebase true

git config --global color.ui auto
git config --global core.editor "code --wait"
git config --global core.autocrlf input

# Push new branches upstream automatically — no more --set-upstream
git config --global push.autoSetupRemote true

# -----------------------------
# Quality of life
# -----------------------------

git config --global status.branch true
git config --global status.short true

# Wait 1 second before auto-running corrected command (gives you time to cancel)
git config --global help.autocorrect 10

git config --global diff.colorMoved zebra

# Show number of stashed changes in status
git config --global status.showStash true

# Prune deleted remote branches automatically when fetching
git config --global fetch.prune true

# More readable conflict markers — shows the common ancestor too
git config --global merge.conflictStyle diff3

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

# Undo last commit but keep changes staged
git config --global alias.undo "reset --soft HEAD~1"

# Show all branches sorted by most recently used
git config --global alias.recent "branch --sort=-committerdate"

echo "✅ Git configured"
