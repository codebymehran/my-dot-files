# my-dot-files

Personal config files for macOS dev environment.

---

## What's included

| File | Location | Purpose |
|------|----------|---------|
| zshrc.sh | ~/.zshrc | Shell config — aliases, functions, tools |
| starship.toml | ~/.config/starship.toml | Prompt appearance |
| wezterm.lua | ~/.wezterm.lua | WezTerm terminal config |
| karabiner.json | ~/.config/karabiner/karabiner.json | Keyboard remapping |
| settings.json | ~/Library/Application Support/Code/User/settings.json | VS Code settings |
| keybindings.json | ~/Library/Application Support/Code/User/keybindings.json | VS Code keybindings |
| React_Snippets.code-snippets | ~/Library/Application Support/Code/User/snippets/React_Snippets.code-snippets | VS Code React snippets |
| vscode-extensions.txt | local file in repo | VS Code extensions list |
| cheatsheets | ~/Desktop/cheatsheets | HTML reference files |

---

## Apps

### Development
- Visual Studio Code
- WezTerm
- iTerm2
- Karabiner-Elements

### Productivity
- Raycast
- Contexts
- CleanShot
- PopClip
- Itsycal

### Utilities
- AppCleaner
- The Unarchiver
- HiddenBar
- KeyboardCleanTool
- Mic Drop

### Media / Browser
- Google Chrome
- IINA

---

## Setup (New Machine)

```bash
cd ~
git clone https://github.com/codebymehran/my-dot-files.git
cd my-dot-files
bash install.sh
exec zsh
```

---

## Update (After changes on GitHub)

```bash
cd ~
rm -rf my-dot-files
git clone https://github.com/codebymehran/my-dot-files.git
cd my-dot-files
bash install.sh
exec zsh
```

---

## Install Apps (Homebrew)

```bash
brew bundle
```

---


## macOS Settings

Apply macOS preferences:

```bash
cd ~/my-dot-files
bash macos.sh
```

This script currently includes:
- Finder preferences
- Dock preferences
- Keyboard repeat settings
- Trackpad preferences
- Screenshot preferences
- Spotlight shortcut disabled for Raycast
- Battery / power preferences

---

## VS Code Extensions

```bash
cat vscode-extensions.txt | xargs -L 1 code --install-extension
```
## Git Setup

Configure Git with default settings, aliases, and identity:

```bash
cd ~/my-dot-files
bash git.sh
```
---

## Install dependencies (manual)

```bash
brew install starship zsh-autosuggestions zsh-syntax-highlighting
brew install eza bat zoxide fnm fzf thefuck
```

---

## Manual Apps (App Store)

Install these manually:

- BetterSnapTool
- ScreenBrush

---

## Font

Uses **MesloLGL Nerd Font Mono**

Install via Homebrew or from:
https://www.nerdfonts.com/

---

## Notes

- Always push your changes to GitHub before running update
- Update process deletes the local repo and installs a fresh copy
- `install.sh` only handles dotfiles
- Apps are installed separately using `brew bundle`
- VS Code extensions are installed separately
- Mac OS settings can be installed using `bash macos.sh`
- Git Configuration `bash git.sh`
