#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# AndresMarulanda10 dotfiles — install.sh
# Requisito: Homebrew instalado
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

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

# copy_config $src $dst
copy_config() {
  local src="$1" dst="$2"
  local backup

  if [[ ! -e "$src" ]]; then
    err "No existe el origen: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" || -L "$dst" ]]; then
    backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    warn "Backup: $backup"
  fi

  if [[ -d "$src" ]]; then
    cp -R "$src" "$dst"
  else
    cp "$src" "$dst"
  fi

  ok "$(basename "$dst")"
}

write_gitconfig_local() {
  local dst="$HOME/.gitconfig.local"
  local backup git_name git_email

  if [[ -e "$dst" ]]; then
    warn "$dst ya existe"

    if gum confirm "¿Querés reemplazar ~/.gitconfig.local? Se va a crear backup."; then
      backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
      mv "$dst" "$backup"
      warn "Backup: $backup"
    else
      skip ".gitconfig.local"
      return
    fi
  fi

  git_name=$(gum input --placeholder "Tu nombre" --prompt "Nombre Git: ")
  git_email=$(gum input --placeholder "tu@email.com" --prompt "Email Git: ")

  if [[ -z "${git_name// }" || -z "${git_email// }" ]]; then
    warn "Nombre o email vacío; no se generó ~/.gitconfig.local"
    return
  fi

  cat > "$dst" <<EOF
[user]
	name = $git_name
	email = $git_email
	useConfigOnly = true
EOF

  chmod 600 "$dst"
  ok ".gitconfig.local"
}

should_run() {
  local option
  for option in "${ALL_OPTS[@]}"; do
    [[ "$option" == "$1 — "* ]] || continue
    if grep -qxF "$option" <<< "$CHOICES" ||
       grep -qxF "Todo — instalar todo" <<< "$CHOICES"; then
      return 0
    fi
  done
  return 1
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
    "$(gum style --foreground '#FCFCFA' --faint 'Solo se configuran: zsh, git, bat y lazygit.')"
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
  "ghostty — terminal"
  "atuin — historial shell"
  "fastfetch — resumen terminal"
  "Neovim — terminal-first editor"
  "Todo — instalar todo"
)

# Opciones exclusivas de macOS
MAC_OPTS=(
  "aerospace — window manager"
)

# Armar lista según OS
if $IS_MAC; then
  ALL_OPTS=("${COMMON_OPTS[@]:0:9}" "${MAC_OPTS[@]}" "${COMMON_OPTS[@]:9}")
elif $IS_CODESPACES; then
  ALL_OPTS=(
    "zsh — config y theme"
    "git — .gitconfig"
    "bat — config"
    "lazygit — config"
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
  "${ALL_OPTS[@]}" || true)

if [[ -z "$CHOICES" ]]; then
  echo -e "${DIM}  Sin selección. Saliendo.${RESET}"
  exit 0
fi

# ─── Brewfile ─────────────────────────────────────────────────────────────────
if should_run "Brewfile"; then
  title "Homebrew"

  BREW_FLAGS="--file=$DOTFILES_DIR/Brewfile"

  # Brewfile limita los casks a macOS; Linux conserva paquetes existentes.
  if $IS_LINUX; then
    BREW_FLAGS="$BREW_FLAGS --no-upgrade"
  fi

  if gum spin --spinner dot \
    --title "Instalando paquetes..." \
    --show-output \
    -- brew bundle $BREW_FLAGS; then
    ok "brew bundle completado"
  else
    err "brew bundle falló — revisá el output"
    exit 1
  fi
fi

# ─── zsh ─────────────────────────────────────────────────────────────────────
if should_run "zsh"; then
  title "zsh"

  if [[ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]]; then
    title "Instalando Oh My Zsh"
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
      info "Oh My Zsh instalado correctamente"
    else
      err "Falló la instalación de Oh My Zsh. Verificá el entorno."
      exit 1
    fi
  fi

  copy_config "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
  copy_config "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  copy_config "$DOTFILES_DIR/zsh/andres.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/andres.zsh-theme"
  warn "Abrí una terminal nueva para cargar la configuración."
fi

# ─── git ─────────────────────────────────────────────────────────────────────
if should_run "git"; then
  title "git"
  copy_config "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  write_gitconfig_local
fi

# ─── bat ─────────────────────────────────────────────────────────────────────
if should_run "bat"; then
  title "bat"
  copy_config "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
fi

# ─── lazygit ─────────────────────────────────────────────────────────────────
if should_run "lazygit"; then
  title "lazygit"

  if $IS_MAC; then
    LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
  else
    LAZYGIT_DIR="$HOME/.config/lazygit"
  fi

  copy_config "$DOTFILES_DIR/lazygit/config.yml" "$LAZYGIT_DIR/config.yml"
fi

# ─── Ghostty ─────────────────────────────────────────────────────────────────
if should_run "ghostty"; then
  title "Ghostty"
  copy_config "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
fi

# ─── Atuin ───────────────────────────────────────────────────────────────────
if should_run "atuin"; then
  title "Atuin"
  copy_config "$DOTFILES_DIR/atuin/config.toml" "$HOME/.config/atuin/config.toml"
fi

# ─── Fastfetch ────────────────────────────────────────────────────────────────
if should_run "fastfetch"; then
  title "Fastfetch"
  copy_config "$DOTFILES_DIR/fastfetch" "$HOME/.config/fastfetch"
fi

# ─── AeroSpace (macOS only) ───────────────────────────────────────────────────
if $IS_MAC && should_run "aerospace"; then
  title "AeroSpace"
  copy_config "$DOTFILES_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
fi

# ─── Neovim ───────────────────────────────────────────────────────────────────
if should_run "Neovim"; then
  title "Neovim"
  copy_config "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# ─── Done ────────────────────────────────────────────────────────────────────
echo ""
gum style \
  --foreground "#A9DC76" --bold \
  --border-foreground "#A9DC76" --border rounded \
  --padding "0 2" \
  "✓ Setup completado"
echo ""
