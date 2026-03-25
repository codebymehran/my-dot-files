#!/bin/bash

set -e

echo "🚀 Bootstrapping fresh macOS machine..."
echo ""

# -----------------------------
# Homebrew
# -----------------------------

if ! command -v brew &> /dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for the rest of this script
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
  else
    eval "$(/usr/local/bin/brew shellenv)"       # Intel
  fi

  echo "  ✅ Homebrew installed"
else
  echo "  ✅ Homebrew already installed — skipping"
fi
echo ""

# -----------------------------
# Oh My Zsh
# -----------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "🐚 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "  ✅ Oh My Zsh installed"
else
  echo "  ✅ Oh My Zsh already installed — skipping"
fi
echo ""

# -----------------------------
# ZSH Plugins
# -----------------------------

echo "🔌 Installing ZSH plugins..."

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  echo "  ✅ zsh-autosuggestions installed"
else
  echo "  ✅ zsh-autosuggestions already installed — skipping"
fi

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  echo "  ✅ zsh-syntax-highlighting installed"
else
  echo "  ✅ zsh-syntax-highlighting already installed — skipping"
fi
echo ""

# -----------------------------
# fnm + Node LTS
# -----------------------------

if ! command -v fnm &> /dev/null; then
  echo "📦 Installing fnm..."
  brew install fnm
  eval "$(fnm env)"
  echo "  ✅ fnm installed"
else
  echo "  ✅ fnm already installed — skipping"
  eval "$(fnm env)"
fi

echo "📦 Installing Node LTS..."
fnm install --lts
fnm use lts-latest
fnm default lts-latest
echo "  ✅ Node $(node -v) installed"
echo ""


# -----------------------------
# SSH Key for GitHub
# -----------------------------

echo "🔑 Setting up SSH key for GitHub..."

SSH_KEY="$HOME/.ssh/id_ed25519"

if [[ -f "$SSH_KEY" ]]; then
  echo "  ✅ SSH key already exists — skipping"
else
  read -p "  Enter your GitHub email: " github_email
  ssh-keygen -t ed25519 -C "$github_email" -f "$SSH_KEY" -N ""
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add "$SSH_KEY"
  echo ""
  echo "  ✅ SSH key generated"
  echo ""
  echo "  📋 Copy the public key below and add it to GitHub:"
  echo "     GitHub → Settings → SSH and GPG keys → New SSH key"
  echo ""
  cat "$SSH_KEY.pub"
  echo ""
  read -p "  Press Enter once you've added the key to GitHub..."
  ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && echo "  ✅ GitHub SSH connection verified" || echo "  ⚠️  Could not verify — you can test later with: ssh -T git@github.com"
fi
echo ""
# -----------------------------
# Done
# -----------------------------

echo "✅ Bootstrap complete!"
echo ""
echo "👉 Next steps:"
echo "   1. bash install.sh"
echo "   2. exec zsh"
echo "   3. brew bundle"
echo "   4. bash git.sh"
echo "   5. bash macos.sh"
