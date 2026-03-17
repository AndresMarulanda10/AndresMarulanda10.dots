#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# AndresMarulanda10 dotfiles — install.sh
# Requisito: macOS con Homebrew instalado
# ─────────────────────────────────────────────────────────────────────────────

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Colores Monokai Pro ──────────────────────────────────────────────────────
PINK="\033[38;2;255;97;136m"
ORANGE="\033[38;2;252;152;103m"
YELLOW="\033[38;2;255;216;102m"
GREEN="\033[38;2;169;220;118m"
CYAN="\033[38;2;120;220;232m"
PURPLE="\033[38;2;171;157;242m"
FG="\033[38;2;252;252;250m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

# ─── Verificar Homebrew ───────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo -e "${PINK}✗ Homebrew no está instalado.${RESET}"
  echo -e "${DIM}  Instalalo con: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${RESET}"
  exit 1
fi

# ─── Instalar Gum si no está ──────────────────────────────────────────────────
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
    --padding "0 2" --margin "0 0" \
    "$1"
  echo ""
}

step() {
  echo -e "${CYAN}  →${RESET} ${FG}$1${RESET}"
}

ok() {
  echo -e "${GREEN}  ✓${RESET} ${FG}$1${RESET}"
}

skip() {
  echo -e "${DIM}  ·${RESET} ${DIM}$1 (ya existe)${RESET}"
}

err() {
  echo -e "${PINK}  ✗${RESET} ${FG}$1${RESET}"
}

# symlink $origen $destino
symlink() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  mkdir -p "$dst_dir"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    skip "$(basename "$dst")"
    return
  fi

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo -e "${ORANGE}  ⚠${RESET} ${DIM}Backup: $backup${RESET}"
  fi

  ln -sf "$src" "$dst"
  ok "$(basename "$dst")"
}

# ─── Header ───────────────────────────────────────────────────────────────────
clear
gum style \
  --foreground "#FCFCFA" --bold \
  --border-foreground "#AB9DF2" --border double \
  --padding "1 4" --margin "1 2" \
  "AndresMarulanda10 · dotfiles" \
  "" \
  "$(gum style --foreground '#78DCE8' --faint 'Setup reproducible para macOS')"

echo ""

# ─── Selección de módulos ─────────────────────────────────────────────────────
gum style --foreground "#FFD866" --bold "¿Qué querés instalar?"
echo ""

CHOICES=$(gum choose --no-limit \
  --cursor-prefix "○ " \
  --selected-prefix "● " \
  --unselected-prefix "○ " \
  --selected.foreground "#FFD866" \
  --cursor.foreground "#FF6188" \
  --height 10 \
  "Brewfile — paquetes y apps" \
  "zsh — config y theme" \
  "git — .gitconfig" \
  "bat — config" \
  "lazygit — config" \
  "aerospace — window manager" \
  "VS Code — settings y keybindings" \
  "opencode — config y agentes" \
  "Todo — instalar todo")

if [[ -z "$CHOICES" ]]; then
  echo -e "${DIM}  Sin selección. Saliendo.${RESET}"
  exit 0
fi

should_run() {
  echo "$CHOICES" | grep -qF "$1" || echo "$CHOICES" | grep -qF "Todo"
}

# ─── Brewfile ─────────────────────────────────────────────────────────────────
if should_run "Brewfile"; then
  title "Homebrew"
  step "Ejecutando brew bundle..."
  if gum spin --spinner dot \
    --title "Instalando paquetes..." \
    --show-output \
    -- brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    ok "brew bundle completado"
  else
    err "brew bundle falló — revisá el output"
  fi
fi

# ─── zsh ──────────────────────────────────────────────────────────────────────
if should_run "zsh"; then
  title "zsh"

  symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  symlink "$DOTFILES_DIR/zsh/andres.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/andres.zsh-theme"

  ok "Recargá con: source ~/.zshrc"
fi

# ─── git ──────────────────────────────────────────────────────────────────────
if should_run "git"; then
  title "git"
  symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi

# ─── bat ──────────────────────────────────────────────────────────────────────
if should_run "bat"; then
  title "bat"
  symlink "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
fi

# ─── lazygit ──────────────────────────────────────────────────────────────────
if should_run "lazygit"; then
  title "lazygit"
  LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
  symlink "$DOTFILES_DIR/lazygit/config.yml" "$LAZYGIT_DIR/config.yml"
fi

# ─── AeroSpace ────────────────────────────────────────────────────────────────
if should_run "aerospace"; then
  title "AeroSpace"
  symlink "$DOTFILES_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
fi

# ─── VS Code ──────────────────────────────────────────────────────────────────
if should_run "VS Code"; then
  title "VS Code"

  VSCODE_DIR="$HOME/Library/Application Support/Code/User"

  if [[ ! -d "$VSCODE_DIR" ]]; then
    err "VS Code no está instalado o nunca se abrió"
  else
    symlink "$DOTFILES_DIR/vscode/settings.json"    "$VSCODE_DIR/settings.json"
    symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
    echo ""
    echo -e "  ${DIM}Recargá VS Code: Cmd+Shift+P → Reload Window${RESET}"
  fi
fi

# ─── Opencode ────────────────────────────────────────────────────────────────
if should_run "opencode"; then
  title "Opencode"
  symlink "$DOTFILES_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
gum style \
  --foreground "#A9DC76" --bold \
  --border-foreground "#A9DC76" --border rounded \
  --padding "0 2" \
  "✓ Setup completado"
echo ""
