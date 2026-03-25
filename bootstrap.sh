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

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode" ]]; then
  git clone https://github.com/jeffreytse/zsh-vi-mode \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
  echo "  ✅ zsh-vi-mode installed"
else
  echo "  ✅ zsh-vi-mode already installed — skipping"
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
