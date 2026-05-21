# my-dot-files
Personal config files for macOS dev environment.

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
bash install.sh      # interactive — confirm each file
# or
bash install.sh -y   # auto-confirm all files
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
dotinstall   # pulls latest from GitHub + reinstalls everything + reloads shell
```

> Always push your changes to GitHub before running `dotinstall` — the local repo is deleted first.

---

## Scripts

Reusable shell scripts. All available as aliases after `exec zsh`.

| Script | Alias | Usage |
|--------|-------|-------|
| new-next-app.sh | `nna` | `nna my-project` — scaffold Next.js + TS + Tailwind + shadcn/ui |
| new-next-app-basic.sh | `nnab` | `nnab my-project` — scaffold basic Next.js app + optional rebuild twin |
| new.sh | `new` | `new feature tasks` / `new page dashboard` / `new api users` / `new component Button`. Also: `new feature --delete tasks`, `new feature --rename old new`, `new feature --list` |
| rebuild-add.sh | `rebuild` | `rebuild src/features/tasks/components/` — strip imports+JSX into rebuild twin. `rebuild --init my-project` to create the twin. |
| git-clone-and-setup-dev-environment.sh | `clone` | `clone <url>` — clone into ~/Code/explore and open in VS Code |
| clone-own.sh | `cloneown` | `cloneown <url>` — clone your own repo into ~/Code |
| repodelete.sh | `repodelete` | `repodelete <name>` — delete project locally (Trash) + remove from GitHub |

### Rebuild workflow

```bash
nnab my-project             # scaffold — answer y to create rebuild twin
# or later:
rebuild --init my-project   # create twin for an existing project

# as you build, from your project root...
rebuild src/features/tasks/components/TaskForm.tsx   # single file
rebuild src/features/tasks/components/               # entire folder

# when ready to drill...
cd ~/Code/my-project-rebuild && npm run dev -- -p 3001
```

---

## GitHub CLI (gh)

### First-time setup (run once)

```bash
brew install gh
gh auth login
gh auth refresh -h github.com -s delete_repo   # needed for repodelete
gh auth status                                  # verify
```

### GitHub CLI aliases (defined in zshrc)

| Alias | Usage |
|-------|-------|
| `ghcreate` | Create public GitHub repo from current folder and push |
| `ghcreate <name>` | Same but with a custom repo name |
| `ghcreate --private` | Create private repo |
| `ghopen` | Open current repo on GitHub in browser |

### Other useful gh commands

```bash
gh pr create / gh pr list
gh issue create / gh issue list
gh repo list
```

---

## What's included

### Config files

| File | Installed to | Purpose |
|------|-------------|---------|
| zshrc.sh | ~/.zshrc | Shell config — aliases, functions, PATH, tools |
| starship.toml | ~/.config/starship.toml | Prompt appearance |
| wezterm.lua | ~/.wezterm.lua | WezTerm terminal config |
| karabiner.json | ~/.config/karabiner/karabiner.json | Keyboard remapping |
| settings.json | ~/Library/Application Support/Code/User/ | VS Code settings |
| keybindings.json | ~/Library/Application Support/Code/User/ | VS Code keybindings |
| React_Snippets.code-snippets | ~/Library/Application Support/Code/User/snippets/ | VS Code React snippets |
| raycast_snippets.json | ~/.config/raycast/snippets/ | Raycast text snippets |
| vscode-extensions.txt | repo only | VS Code extensions list |
| cheatsheets/ | ~/Desktop/cheatsheets/ | HTML reference files (karabiner, snippets, terminal, vscode, ai) |

### Scripts

| File | Alias | Purpose |
|------|-------|---------|
| new.sh | `new` | Scaffold features, pages, API routes, components |
| new-next-app.sh | `nna` | Full Next.js app scaffold |
| new-next-app-basic.sh | `nnab` | Basic Next.js app + optional rebuild twin |
| rebuild-add.sh | `rebuild` | Strip JSX-only into rebuild twin |
| git-clone-and-setup-dev-environment.sh | `clone` | Clone + open any repo |
| clone-own.sh | `cloneown` | Clone your own repo into ~/Code |
| repodelete.sh | `repodelete` | Delete local + GitHub repo |
| install.sh | `dotinstall` | Install/update all dotfiles |
| bootstrap.sh | — | Fresh machine setup only |
| git.sh | — | One-time git config |
| macos.sh | — | One-time macOS system settings |

---

## Notes

- Always push changes to GitHub before running `dotinstall`
- `bootstrap.sh` is for fresh machines only — skip on updates
- `git.sh` and `macos.sh` are one-time setup scripts — skip on updates
- `-rebuild` projects are excluded from `gitallpull` and `gacpall` automatically
- Apps installed separately via `brew bundle`
- VS Code extensions installed separately

---

## Fonts

Included in Brewfile, installed with `brew bundle`:

```bash
font-meslo-lg-nerd-font        # WezTerm
font-jetbrains-mono-nerd-font  # VS Code
font-fira-code                 # ligatures
```

Other good options: `font-monaspace`, `font-geist-mono`, `font-cascadia-code`, `font-sf-mono`, `font-victor-mono`

Browse all: https://www.nerdfonts.com/

---

## Apps

**Development:** VS Code, WezTerm, iTerm2, Karabiner-Elements

**Productivity:** Raycast, Contexts, CleanShot, PopClip, Itsycal

**Utilities:** AppCleaner, The Unarchiver, HiddenBar, KeyboardCleanTool, Mic Drop

**Media/Browser:** Google Chrome, IINA

**App Store (manual):** BetterSnapTool, ScreenBrush
