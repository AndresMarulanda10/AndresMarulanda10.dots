# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="andres"

plugins=(command-not-found z web-search copypath copyfile)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="code --wait"

# ─── Plugins ──────────────────────────────────────────────────────────────────
if command -v brew &>/dev/null; then
    BREW_PREFIX="$(brew --prefix)"

    ZSH_SYNTAX_HIGHLIGHTING="$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_AUTOSUGGESTIONS="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    [[ -f "$ZSH_SYNTAX_HIGHLIGHTING" ]] && source "$ZSH_SYNTAX_HIGHLIGHTING"
    [[ -f "$ZSH_AUTOSUGGESTIONS" ]] && source "$ZSH_AUTOSUGGESTIONS"
fi

# ─── Atuin ────────────────────────────────────────────────────────────────────
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

# ─── Fastfetch ────────────────────────────────────────────────────────────────
if [[ -o interactive && -z "$FASTFETCH_SHOWN" && -z "$VSCODE_INJECTION" && -z "$CI" ]]; then
    export FASTFETCH_SHOWN=1
    command -v fastfetch &>/dev/null && fastfetch
fi

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

# Navegación
alias proj='cd ~/Documents/Projects'

# Utilidades
function mkcd() { mkdir -p "$1" && cd "$1" }
