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

# ─── LS Colors ────────────────────────────────────────────────────────────────
export LS_COLORS="di=38;5;67:ow=48;5;60:ex=38;5;132:ln=38;5;144:*.tar=38;5;180:*.zip=38;5;180:*.jpg=38;5;175:*.png=38;5;175:*.mp3=38;5;175:*.wav=38;5;175:*.txt=38;5;223:*.sh=38;5;132"
alias ls='ls --color=auto'

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
