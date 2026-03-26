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

**Step 1 — Bootstrap** (Homebrew, Oh My Zsh, ZSH plugins, Node, SSH key):
```bash
cd ~
git clone https://github.com/codebymehran/my-dot-files.git
cd my-dot-files
bash bootstrap.sh
```

> `bootstrap.sh` will generate an SSH key and prompt you to add it to GitHub. Follow the on-screen instructions before continuing.

**Step 2 — Install dotfiles:**
```bash
bash install.sh
exec zsh
```

**Step 3 — Install apps:**
```bash
brew bundle
```

**Step 4 — One-time configs** (run once, not needed on updates):
```bash
bash git.sh
bash macos.sh
```

**Step 5 — VS Code extensions:**
```bash
cat vscode-extensions.txt | xargs -L 1 code --install-extension
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

> Always push your changes to GitHub before running update — the local repo is deleted first.

---

## macOS Settings

```bash
bash macos.sh
```

Includes: Finder, Dock, Keyboard, Trackpad, Screenshots, Spotlight, Battery/Power settings.

---

## Git Setup

```bash
bash git.sh
```

---

## GitHub CLI (gh)

`gh` lets you create repos, open PRs, and manage GitHub without leaving the terminal.

### First-time setup (run once)

**Step 1 — Install:**
```bash
brew install gh
```

**Step 2 — Login:**
```bash
gh auth login
```
Choose: GitHub.com → SSH → Yes (upload your existing SSH key) → Login with a web browser → follow the prompt.

**Step 3 — Verify:**
```bash
gh auth status
```

---

### Creating a repo for a new project

After running `nna my-project`, your project has a local git repo but no GitHub remote yet. To create one:

```bash
ghcreate
```

That's it. It creates a private repo named after your current folder, sets it as origin, and pushes everything.

Or with a custom name:
```bash
ghcreate my-custom-name
```

---

### Other useful gh commands

```bash
gh repo view --web        # Open current repo on GitHub in browser
gh pr create              # Create a pull request
gh pr list                # List open PRs
gh issue create           # Create an issue
gh issue list             # List open issues
gh repo list              # List all your repos
```

---

## Manual Apps (App Store)

Install these manually:
- BetterSnapTool
- ScreenBrush

---

## Fonts

Already included in Brewfile and installed automatically with `brew bundle`:

```bash
brew install --cask font-meslo-lg-nerd-font       # MesloLGS — used in WezTerm
brew install --cask font-jetbrains-mono-nerd-font  # JetBrains Mono — used in VS Code
brew install --cask font-fira-code                 # Fira Code — ligatures
```

Other great coding fonts worth trying:

```bash
brew install --cask font-monaspace               # Monaspace — GitHub's font family (5 styles)
brew install --cask font-commit-mono             # Commit Mono — clean, neutral
brew install --cask font-geist-mono              # Geist Mono — by Vercel
brew install --cask font-cascadia-code           # Cascadia Code — Microsoft, great ligatures
brew install --cask font-sf-mono                 # SF Mono — Apple's own monospace
brew install --cask font-victor-mono             # Victor Mono — cursive italics
```

Or browse the full list at: https://www.nerdfonts.com/

---

## Notes

- Always push your changes to GitHub before running update
- Update process deletes the local repo and installs a fresh copy
- `bootstrap.sh` is for fresh machines only — skip on updates
- `install.sh` only handles dotfiles
- Apps are installed separately via `brew bundle`
- VS Code extensions are installed separately
- `git.sh` and `macos.sh` are one-time setup scripts

---

## Scripts

Reusable shell scripts in the repo root. All work from terminal directly or via Raycast.

| Script | Alias | Usage |
|--------|-------|-------|
| new-next-app.sh | `nna` | `nna my-project` — scaffolds Next.js + TS + Tailwind + shadcn/ui |
| git-clone-and-setup-dev-environment.sh | `clone` | `clone <url>` — clones into ~/Code/explore and opens in VS Code |
| clone-own.sh | `cloneown` | `cloneown <url>` — clones your own repo into ~/Code and opens in VS Code |

### GitHub CLI aliases (defined in zshrc)

| Alias | Usage |
|-------|-------|
| `ghcreate` | `ghcreate` — create private GitHub repo from current folder and push |
| `ghcreate <name>` | `ghcreate my-name` — same but with a custom repo name |
| `ghopen` | Opens current repo on GitHub in browser |

Aliases are defined in `zshrc.sh` and available after `exec zsh`.
