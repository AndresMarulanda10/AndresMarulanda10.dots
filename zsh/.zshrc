# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="andres"

plugins=(git command-not-found z web-search copypath copyfile)

source $ZSH/oh-my-zsh.sh

# ─── Homebrew ─────────────────────────────────────────────────────────────────
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="code --wait"

# ─── Plugins ──────────────────────────────────────────────────────────────────
BREW_PREFIX="$(brew --prefix)"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ─── eza (ls moderno) ─────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias la='eza --icons --group-directories-first -a'
    alias ll='eza --icons --group-directories-first -l --git'
    alias lla='eza --icons --group-directories-first -la --git'
    alias lt='eza --icons --tree --level=2'
    alias lta='eza --icons --tree --level=2 -a'
else
    alias ls='ls --color=auto'
fi

# ─── Aliases ──────────────────────────────────────────────────────────────────

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Navegación
alias proj='cd ~/Documents/Projects'

# Utilidades
function mkcd() { mkdir -p "$1" && cd "$1" }
