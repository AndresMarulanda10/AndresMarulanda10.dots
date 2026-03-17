#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# AndresMarulanda10 dotfiles — install.sh
# Requisito: Homebrew instalado
# ─────────────────────────────────────────────────────────────────────────────

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Colores Monokai Pro ──────────────────────────────────────────────────────
PINK="\033[38;2;255;97;136m"
ORANGE="\033[38;2;252;152;103m"
YELLOW="\033[38;2;255;216;102m"
GREEN="\033[38;2;169;220;118m"
CYAN="\033[38;2;120;220;232m"
FG="\033[38;2;252;252;250m"
DIM="\033[2m"
RESET="\033[0m"

# ─── Verificar Homebrew ───────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo -e "${PINK}✗ Homebrew no está instalado.${RESET}"
  echo -e "${DIM}  Instalalo con: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${RESET}"
  exit 1
fi

# ─── Instalar Gum si no está ─────────────────────────────────────────────────
if ! command -v gum &>/dev/null; then
  echo -e "${CYAN}→ Instalando gum...${RESET}"
  brew install gum
fi

# ─── Helpers ─────────────────────────────────────────────────────────────────
title() {
  echo ""
  gum style \
    --foreground "#FFD866" --bold \
    --border-foreground "#78DCE8" --border rounded \
    --padding "0 2" \
    "$1"
  echo ""
}

ok()   { echo -e "${GREEN}  ✓${RESET} ${FG}$1${RESET}"; }
skip() { echo -e "${DIM}  ·  $1 (ya existe)${RESET}"; }
err()  { echo -e "${PINK}  ✗${RESET} ${FG}$1${RESET}"; }
warn() { echo -e "${ORANGE}  ⚠${RESET} ${DIM}$1${RESET}"; }
info() { echo -e "${DIM}    $1${RESET}"; }

# symlink $src $dst
symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    skip "$(basename "$dst")"; return
  fi

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    warn "Backup: $backup"
  fi

  ln -sf "$src" "$dst"
  ok "$(basename "$dst")"
}

should_run() {
  echo "$CHOICES" | grep -qF "$1" || echo "$CHOICES" | grep -qF "Todo"
}

# ─── Header ───────────────────────────────────────────────────────────────────
clear
gum style \
  --foreground "#FCFCFA" --bold \
  --border-foreground "#AB9DF2" --border double \
  --padding "1 4" --margin "1 2" \
  "AndresMarulanda10 · dotfiles" \
  "" \
  "$(gum style --foreground '#78DCE8' --faint 'Setup reproducible de entorno de desarrollo')"

echo ""

# ─── Selección de OS ─────────────────────────────────────────────────────────
gum style --foreground "#FFD866" --bold "¿En qué sistema estás?"
echo ""

OS=$(gum choose \
  --cursor-prefix "○ " \
  --selected-prefix "● " \
  --unselected-prefix "○ " \
  --selected.foreground "#FFD866" \
  --cursor.foreground "#FF6188" \
  "🍎  macOS" \
  "🐧  Linux" \
  "☁️   GitHub Codespaces" \
  "🪟  Windows")

# ─── Windows — chiste ────────────────────────────────────────────────────────
if [[ "$OS" == *"Windows"* ]]; then
  echo ""
  gum style \
    --foreground "#FF6188" --bold \
    --border-foreground "#FF6188" --border rounded \
    --padding "0 2" \
    "¿En serio? ¿Windows?" \
    "" \
    "$(gum style --foreground '#FC9867' 'Hacete un favor y arrancá desde una USB con Ubuntu.')" \
    "$(gum style --foreground '#FC9867' 'Este script no va a correr ahí y lo sabés.')"
  echo ""
  exit 0
fi

# ─── Normalizar OS ───────────────────────────────────────────────────────────
IS_MAC=false
IS_LINUX=false
IS_CODESPACES=false

[[ "$OS" == *"macOS"* ]]            && IS_MAC=true
[[ "$OS" == *"Linux"* ]]            && IS_LINUX=true
[[ "$OS" == *"Codespaces"* ]]       && IS_CODESPACES=true

# ─── Advertencias por OS ─────────────────────────────────────────────────────
if $IS_LINUX; then
  echo ""
  gum style \
    --foreground "#FC9867" \
    --border-foreground "#FC9867" --border rounded \
    --padding "0 2" \
    "⚠  Linux detectado" \
    "$(gum style --foreground '#FCFCFA' --faint 'AeroSpace, OrbStack, Homerow y Mole son macOS only — se omiten.')"
  echo ""
fi

if $IS_CODESPACES; then
  echo ""
  gum style \
    --foreground "#78DCE8" \
    --border-foreground "#78DCE8" --border rounded \
    --padding "0 2" \
    "☁  GitHub Codespaces" \
    "$(gum style --foreground '#FCFCFA' --faint 'Solo se instalan: zsh, git, bat, lazygit y VS Code.')"
  echo ""
fi

# ─── Construir opciones según OS ─────────────────────────────────────────────
echo ""
gum style --foreground "#FFD866" --bold "¿Qué querés instalar?"
echo ""

# Opciones comunes a todos los OS
COMMON_OPTS=(
  "Brewfile — paquetes y apps"
  "zsh — config y theme"
  "git — .gitconfig"
  "bat — config"
  "lazygit — config"
  "VS Code — settings y keybindings"
  "opencode — config y agentes"
  "Todo — instalar todo"
)

# Opciones exclusivas de macOS
MAC_OPTS=(
  "aerospace — window manager"
)

# Armar lista según OS
if $IS_MAC; then
  ALL_OPTS=("${COMMON_OPTS[@]:0:5}" "${MAC_OPTS[@]}" "${COMMON_OPTS[@]:5}")
elif $IS_CODESPACES; then
  ALL_OPTS=(
    "zsh — config y theme"
    "git — .gitconfig"
    "bat — config"
    "lazygit — config"
    "VS Code — settings y keybindings"
    "Todo — instalar todo"
  )
else
  ALL_OPTS=("${COMMON_OPTS[@]}")
fi

CHOICES=$(gum choose --no-limit \
  --cursor-prefix "○ " \
  --selected-prefix "● " \
  --unselected-prefix "○ " \
  --selected.foreground "#FFD866" \
  --cursor.foreground "#FF6188" \
  --height 12 \
  "${ALL_OPTS[@]}")

if [[ -z "$CHOICES" ]]; then
  echo -e "${DIM}  Sin selección. Saliendo.${RESET}"
  exit 0
fi

# ─── Brewfile ─────────────────────────────────────────────────────────────────
if should_run "Brewfile"; then
  title "Homebrew"

  BREW_FLAGS="--file=$DOTFILES_DIR/Brewfile"

  # En Linux saltear los casks macOS-only
  if $IS_LINUX; then
    warn "Saltando casks macOS-only (orbstack, aerospace, homerow, mole)"
    BREW_FLAGS="$BREW_FLAGS --no-upgrade"
  fi

  if gum spin --spinner dot \
    --title "Instalando paquetes..." \
    --show-output \
    -- brew bundle $BREW_FLAGS; then
    ok "brew bundle completado"
  else
    err "brew bundle falló — revisá el output"
  fi
fi

# ─── zsh ─────────────────────────────────────────────────────────────────────
if should_run "zsh"; then
  title "zsh"
  symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  symlink "$DOTFILES_DIR/zsh/andres.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/andres.zsh-theme"
  info "Recargá con: source ~/.zshrc"
fi

# ─── git ─────────────────────────────────────────────────────────────────────
if should_run "git"; then
  title "git"
  symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi

# ─── bat ─────────────────────────────────────────────────────────────────────
if should_run "bat"; then
  title "bat"
  symlink "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
fi

# ─── lazygit ─────────────────────────────────────────────────────────────────
if should_run "lazygit"; then
  title "lazygit"

  if $IS_MAC; then
    LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
  else
    LAZYGIT_DIR="$HOME/.config/lazygit"
  fi

  symlink "$DOTFILES_DIR/lazygit/config.yml" "$LAZYGIT_DIR/config.yml"
fi

# ─── AeroSpace (macOS only) ───────────────────────────────────────────────────
if $IS_MAC && should_run "aerospace"; then
  title "AeroSpace"
  symlink "$DOTFILES_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
fi

# ─── VS Code ─────────────────────────────────────────────────────────────────
if should_run "VS Code"; then
  title "VS Code"

  if $IS_MAC; then
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
  else
    VSCODE_DIR="$HOME/.config/Code/User"
  fi

  if [[ ! -d "$VSCODE_DIR" ]]; then
    err "VS Code no está instalado o nunca se abrió"
  else
    symlink "$DOTFILES_DIR/vscode/settings.json"    "$VSCODE_DIR/settings.json"
    symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
    info "Recargá VS Code: Cmd+Shift+P → Reload Window"
  fi
fi

# ─── Opencode ────────────────────────────────────────────────────────────────
if should_run "opencode"; then
  title "Opencode"
  symlink "$DOTFILES_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
fi

# ─── Done ────────────────────────────────────────────────────────────────────
echo ""
gum style \
  --foreground "#A9DC76" --bold \
  --border-foreground "#A9DC76" --border rounded \
  --padding "0 2" \
  "✓ Setup completado"
echo ""
