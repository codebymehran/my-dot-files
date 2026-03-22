# my-dot-files

Personal config files for macOS dev environment.

## What's included

| File | Location | Purpose |
|------|----------|---------|
| `zshrc_config.sh` | `~/.zshrc` | Shell config — aliases, functions, tools |
| `starship.toml` | `~/.config/starship.toml` | Prompt appearance |
| `.wezterm.lua` | `~/.wezterm.lua` | WezTerm terminal config |
| `settings.json` | `~/Library/Application Support/Code/User/settings.json` | VS Code settings |
| `keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` | VS Code keybindings |

## Setup on a new Mac

```bash
git clone https://github.com/codebymehran/my-dot-files.git
cd my-dot-files
bash install.sh
```

## Install dependencies first

```bash
# Core
brew install starship zsh-autosuggestions zsh-syntax-highlighting

# Optional tools (recommended)
brew install eza bat zoxide fnm fzf thefuck
```

## Font

Uses **MesloLGL Nerd Font Mono** — install from [nerdfonts.com](https://www.nerdfonts.com) before running the install script.
