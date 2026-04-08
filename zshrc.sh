# ============================================================================
# PATH
# ============================================================================
export PATH="$HOME/my-dot-files:$PATH"

# ============================================================================
# DEFAULT EDITOR
# ============================================================================
export EDITOR="code"
export VISUAL="code --wait"

# ============================================================================
# OH MY ZSH SETUP
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Plugins (order matters - zsh-syntax-highlighting must be last, zsh-vi-mode second to last)
plugins=(
  git
  npm
  node
  colored-man-pages
  zsh-autosuggestions
  zsh-vi-mode
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# ZSH HISTORY IMPROVEMENTS
# ============================================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space
setopt SHARE_HISTORY         # Share history between terminals (implies incremental append)

# ============================================================================
# PROJECTS — auto-discovered from ~/Code (excludes explore and my-dot-files)
# Used by: gitallpull, gacpall
# ============================================================================
PROJECTS=()
if [[ -d "$HOME/Code" ]]; then
  for dir in "$HOME/Code"/*/; do
    dirname=$(basename "$dir")
    if [[ "$dirname" != "explore" && "$dirname" != "my-dot-files" && -d "$dir/.git" ]]; then
      PROJECTS+=("${dir%/}")
    fi
  done
fi

# ============================================================================
# SAFETY ALIASES (prevents accidental deletions)
# ============================================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================================================
# QUICK NAVIGATION
# ============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias co='code -r .'  # Open current directory in VS Code

# ============================================================================
# SMART FILE OPERATIONS
# ============================================================================
# Copy with progress bar (requires rsync)
alias cpv='rsync -ah --info=progress2'

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# trash CLI installed via Homebrew (bootstrap.sh) — no override needed

# Quick file operations
alias cx='chmod +x'  # Make file executable
alias 000='chmod 000'
alias 644='chmod 644'
alias 755='chmod 755'
alias 777='chmod 777'

# ============================================================================
# PROJECT SHORTCUTS
# Use zoxide (z) to jump to projects — e.g. z task-manager
# ============================================================================
alias cex='cd ~/Code/explore'
alias cdf='cd ~/my-dot-files'  # go to dotfiles repo

# ============================================================================
# GIT ALIASES
# ============================================================================
alias gs='git status'
alias gl='git log --oneline --graph --decorate -10'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glh='git log -1 --stat'  # Show last commit with file stats
grc() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    return 1
  fi
  echo "⚠️  This will reset all changes and delete untracked files"
  read "confirm?Type 'YES' to continue: "
  if [[ "$confirm" != "YES" ]]; then
    echo "❌ Aborted"
    return 1
  fi
  git reset --hard && git clean -fd && echo "✅ Done"
}

# ============================================================================
# ENHANCED GIT FUNCTIONS
# ============================================================================

# Git add + commit + push (with safety checks)
gacp() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: gacp \"commit message\""
    return 1
  fi

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    return 1
  fi

  if [[ -z "$(git status --porcelain)" ]]; then
    echo "ℹ️  No changes to commit"
    return 0
  fi

  echo "📝 Changes to be committed:"
  git status --short
  echo ""

  local branch
  branch=$(git symbolic-ref --short HEAD)
  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    echo "⚠️  You are on '$branch'. Are you sure you want to push directly?"
    read "confirm?Type 'y' or Enter to continue: "
    # Convert input to lowercase (zsh syntax)
    confirm="${confirm:l}"
    if [[ "$confirm" != "y" && "$confirm" != "" ]]; then
      echo "❌ Aborted"
      return 1
    fi
  fi

  if git add -A && git commit -m "$1" && git push; then
    echo "✅ Committed and pushed: $1"
  else
    echo "❌ Failed to commit/push"
  fi
}

# Pull all projects
gitallpull() {
  for dir in "${PROJECTS[@]}"; do
    if [[ -d "$dir/.git" ]]; then
      echo "🔄 Pulling in $(basename $dir)..."
      (cd "$dir" && git pull && echo "✅ Done") || echo "❌ Failed"
      echo ""
    else
      echo "⚠️  $dir is not a git repository"
    fi
  done
}

# Commit + push all projects (interactive)
gacpall() {
  for dir in "${PROJECTS[@]}"; do
    if [[ -d "$dir/.git" ]]; then
      (cd "$dir"
        if [[ -n "$(git status --porcelain)" ]]; then
          echo "📝 Changes detected in $(basename $dir):"
          git status --short
          echo ""
          read "msg?Enter commit message (or press Enter to skip): "
          if [[ -n "$msg" ]]; then
            if git add . && git commit -m "$msg" && git push; then
              echo "✅ Committed and pushed"
            else
              echo "❌ Failed"
            fi
          else
            echo "⏭️  Skipped"
          fi
        else
          echo "ℹ️  No changes in $(basename $dir)"
        fi
        echo ""
      )
    fi
  done
}

# Wipe all commit history, keep files (⚠️ dangerous!)
gitwipe() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    return 1
  fi

  echo "⚠️  This will DELETE ALL commit history and force push to remote"
  read "confirm?Type 'YES' to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "❌ Aborted"
    return 1
  fi

  echo "🗑️  Wiping history..."
  git checkout --orphan temp
  git add .

  read "msg?Commit message (or press Enter for 'Initial commit'): "
  git commit -m "${msg:-Initial commit}"

  git branch -D main 2>/dev/null || git branch -D master 2>/dev/null
  git branch -m main

  local current_branch
  current_branch=$(git symbolic-ref --short HEAD)
  echo "🚀 Force pushing..."
  git push -f origin "$current_branch"

  echo "✅ Done! Clean slate."
}

# Create public GitHub repo from current local project and push
# Usage:
#   ghcreate                   → public repo, uses folder name
#   ghcreate my-name           → public repo, custom name
#   ghcreate --private         → private repo, uses folder name
#   ghcreate my-name --private → private repo, custom name
ghcreate() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repo — run: git init && git add . && git commit -m 'initial commit'"
    return 1
  fi

  local name=""
  local visibility="--public"

  for arg in "$@"; do
    if [[ "$arg" == "--private" ]]; then
      visibility="--private"
    else
      name="$arg"
    fi
  done

  name="${name:-$(basename $PWD)}"

  if [[ -z "$(git log --oneline -1 2>/dev/null)" ]]; then
    echo "❌ No commits yet — add some files first:"
    echo "   touch README.md && git add . && git commit -m 'initial commit'"
    echo "   Then run ghcreate again"
    return 1
  fi

  echo "🚀 Creating ${visibility/--/} repo: $name"
  gh repo create "$name" "$visibility" || { echo "❌ Failed to create repo"; return 1; }

  local username
  username=$(gh api user -q .login)
  local repo_url="https://github.com/$username/$name.git"

  if git remote get-url origin &>/dev/null; then
    echo "⚠️  Remote 'origin' already exists — updating to new repo"
    git remote set-url origin "$repo_url"
  else
    git remote add origin "$repo_url"
  fi

  local branch
  branch=$(git symbolic-ref --short HEAD)
  git push -u origin "$branch" && \
    echo "✅ Done — https://github.com/$username/$name" || \
    echo "❌ Push failed"
}

# Git stash
alias gst='git stash'
alias gstp='git stash pop'

# ============================================================================
# NODE/NPM ALIASES
# ============================================================================
alias ni='npm install'
alias nid='npm install --save-dev'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrs='npm run start'
alias nrt='npm run test'
alias nup='npm update'

# ============================================================================
# DEV UTILITIES
# ============================================================================

# Kill process on a specific port
killport() {
  lsof -ti tcp:"$1" | xargs kill -9 && echo "✅ Killed port $1"
}

# Kill all node processes
alias killnode='pkill -f node && echo "✅ All node processes killed" || echo "ℹ️  No node processes found"'

# Clear all node_modules recursively from current directory
cleannm() {
  local count
  count=$(find . -name "node_modules" -type d -prune | wc -l | tr -d ' ')
  if [[ "$count" -eq 0 ]]; then
    echo "ℹ️  No node_modules found"
    return 0
  fi
  echo "⚠️  Found $count node_modules folder(s) — move to Trash?"
  read "confirm?Type 'YES' to continue: "
  if [[ "$confirm" != "YES" ]]; then
    echo "❌ Aborted"
    return 1
  fi
  find . -name "node_modules" -type d -prune -exec trash {} + && echo "✅ node_modules moved to Trash"
}

# Check what's eating your disk
alias ducks='du -cksh * | sort -rh | head -15'

# Open current git repo in browser
alias ghopen='open $(git remote get-url origin | sed "s/git@github.com:/https:\/\/github.com\//;s/\.git$//")'

# ============================================================================
# SCRIPTS
# ============================================================================
alias nna='bash ~/my-dot-files/new-next-app.sh'
_nna_completion() {
  local projects=($(ls ~/Code))
  compadd -S '' -- $projects
}
compdef _nna_completion nna
alias nnab='bash ~/my-dot-files/new-next-app-basic.sh'
compdef _nna_completion nnab  
alias clone='bash ~/my-dot-files/git-clone-and-setup-dev-environment.sh'
alias cloneown='bash ~/my-dot-files/clone-own.sh'
alias repodelete='bash ~/my-dot-files/repodelete.sh'

# ============================================================================
# QUICK EDIT & RELOAD
# ============================================================================
alias zc="${EDITOR:-nano} ~/.zshrc"       # Edit zsh config
alias zr='source ~/.zshrc'               # Reload zsh config
alias starshipconfig="${EDITOR:-nano} ~/.config/starship.toml"

# ============================================================================
# USEFUL UTILITIES
# ============================================================================
alias ports='lsof -i -P -n | grep LISTEN'  # Show listening ports
alias myip='curl -s ifconfig.me'            # Show public IP
alias localip='ipconfig getifaddr en0'      # Show local IP

# ============================================================================
# LS / EZA (brew install eza)
# ============================================================================
if command -v eza &> /dev/null; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza -l --icons=always --group-directories-first'
  alias la='eza -la --icons=always --group-directories-first'
  alias lt='eza --tree --icons=always -a -I "node_modules|.git" -L 3'
else
  alias ls='ls -h'
  alias ll='ls -lh'
  alias la='ls -lah'
  if command -v tree &> /dev/null; then
    alias lt='tree -L 2'
  fi
fi

# ============================================================================
# HELP COMMAND - Show all shortcuts
# ============================================================================
shortcuts() {
  echo ""
  echo "╔══════════════════════════════════════════════════════════════════════╗"
  echo "║                    🚀 Terminal Shortcuts Reference                   ║"
  echo "╠══════════════════════════════════════════════════════════════════════╣"
  echo "║                                                                      ║"
  echo "║  📁 NAVIGATION                                                        ║"
  echo "║    ..               → Go up one directory                            ║"
  echo "║    ...              → Go up two directories                          ║"
  echo "║    ....             → Go up three directories                        ║"
  echo "║    .....            → Go up four directories                         ║"
  echo "║    c                → Clear screen                                   ║"
  echo "║                                                                      ║"
  echo "║  📂 PROJECT SHORTCUTS                                                 ║"
  echo "║    nna <n>       → Scaffold new Next.js project into ~/Code       ║"
  echo "║    cex              → Go to ~/Code/explore (throwaway clones)        ║"
  echo "║    cdf              → Go to ~/my-dot-files                           ║"
  echo "║    clone <url>      → Clone repo and set up dev environment          ║"
  echo "║    cloneown <url>   → Clone your own repo into ~/Code                ║"
  echo "║    repodelete <n> → Delete local folder + GitHub repo                ║"
  echo "║    z <n>         → Jump to any project (zoxide learns from usage) ║"
  echo "║    co               → Open current folder in VS Code                 ║"
  echo "║                                                                      ║"
  echo "║  📋 FILE OPERATIONS                                                   ║"
  echo "║    mkcd <dir>       → Create directory and cd into it                ║"
  echo "║    cpv <src> <dst>  → Copy with progress bar                         ║"
  echo "║    trash <file>     → Move to trash (safer than rm)                  ║"
  echo "║    cx <file>        → Make file executable                           ║"
  echo "║    ls / ll / la     → List files                                     ║"
  echo "║    lt               → List files in tree view                        ║"
  echo "║    cat <file>       → View file with syntax highlighting (bat)       ║"
  echo "║    catp <file>      → View file plain (no highlighting)              ║"
  echo "║                                                                      ║"
  echo "║  🔄 GIT COMMANDS                                                      ║"
  echo "║    gacp \"msg\"       → Add, commit & push with message                ║"
  echo "║    gacpall          → Interactive commit & push all projects         ║"
  echo "║    gitallpull       → Pull latest changes from all projects          ║"
  echo "║    gitwipe          → Wipe ALL history, keep files (⚠️ dangerous!)    ║"
  echo "║    gs               → Git status                                     ║"
  echo "║    gl               → Git log (last 10, with graph)                  ║"
  echo "║    glh              → Last commit with file stats                    ║"
  echo "║    gd               → Git diff                                       ║"
  echo "║    gco <branch>     → Git checkout branch                            ║"
  echo "║    gb               → Git branch list                                ║"
  echo "║    grc              → Git reset hard & clean (⚠️ dangerous!)          ║"
  echo "║    gst              → git stash                                      ║"
  echo "║    gstp             → git stash pop                                  ║"
  echo "║    ghcreate         → Create public GitHub repo + push               ║"
  echo "║    ghcreate --private → Same but private                             ║"
  echo "║    ghcreate <n> [--private] → Custom name, optional private          ║"
  echo "║    ghopen           → Open current repo on GitHub in browser         ║"
  echo "║                                                                      ║"
  echo "║  📦 NODE/NPM SHORTCUTS                                                ║"
  echo "║    ni               → npm install                                    ║"
  echo "║    nid              → npm install --save-dev                         ║"
  echo "║    nrd              → npm run dev                                    ║"
  echo "║    nrb              → npm run build                                  ║"
  echo "║    nrs              → npm run start                                  ║"
  echo "║    nrt              → npm run test                                   ║"
  echo "║    nup              → npm update                                     ║"
  echo "║                                                                      ║"
  echo "║  🛠️  SYSTEM & UTILITIES                                               ║"
  echo "║    ports            → Show listening ports                           ║"
  echo "║    myip             → Show public IP address                         ║"
  echo "║    localip          → Show local IP address                          ║"
  echo "║    killport <port>  → Kill process on port                           ║"
  echo "║    killnode         → Kill all node processes                        ║"
  echo "║    cleannm          → Move node_modules to Trash (with confirmation) ║"
  echo "║    ducks            → Show largest files/dirs in current directory   ║"
  echo "║    zc               → Edit zsh config (opens VS Code)               ║"
  echo "║    zr               → Reload zsh config                             ║"
  echo "║    starshipconfig   → Edit Starship prompt config                    ║"
  echo "║    shortcuts        → Show this help message                         ║"
  echo "║                                                                      ║"
  echo "║  💡 PRO TIPS                                                          ║"
  echo "║    • Use Tab for auto-completion                                     ║"
  echo "║    • Use Ctrl+R for history search (fuzzy find)                      ║"
  echo "║    • Commands starting with space won't be saved in history          ║"
  echo "║    • nna <tab> shows existing ~/Code projects to avoid duplicates    ║"
  echo "║                                                                      ║"
  echo "╚══════════════════════════════════════════════════════════════════════╝"
  echo ""
}

# ============================================================================
# FZF SETUP (fuzzy finder — brew install fzf)
# ============================================================================
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap --bind '?:toggle-preview' --height 50%"

  # Use ripgrep for fzf if available (much faster file search)
  if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  fi

  # Fuzzy project switcher
  proj() {
    local dir
    dir=$(find ~/Code -maxdepth 2 -type d 2>/dev/null | fzf --height 40% --reverse --border) || return
    cd "$dir" || return
  }
fi

# ============================================================================
# BAT — better cat (brew install bat)
# ============================================================================
if command -v bat &> /dev/null; then
  export BAT_THEME="tokyonight_night"
  alias cat='bat'
  alias catp='bat --plain'
fi

# ============================================================================
# ZOXIDE — smart cd (brew install zoxide)
# ============================================================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# ============================================================================
# FNM — Node version manager (brew install fnm)
# ============================================================================
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# ============================================================================
# THEFUCK — correct mistyped commands (brew install thefuck)
# ============================================================================
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias fuck fk)"
fi

# ============================================================================
# STARSHIP PROMPT
# ============================================================================
eval "$(starship init zsh)"
