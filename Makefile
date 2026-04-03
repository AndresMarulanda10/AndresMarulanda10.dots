# ─────────────────────────────────────────────────────────────────────────────
# AndresMarulanda10 dotfiles — Makefile
#
# IMPORTANTE: este Makefile calcula su propio path automáticamente.
# Podés mover el repo a donde quieras: simplemente corré `make` de nuevo.
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_DIR := $(shell cd "$(dir $(abspath $(lastword $(MAKEFILE_LIST))))" && pwd)
HOME         := $(shell echo $$HOME)
IS_MAC       := $(shell uname -s | grep -c Darwin)

# ─── Colores ─────────────────────────────────────────────────────────────────
GREEN  := \033[38;2;169;220;118m
CYAN   := \033[38;2;120;220;232m
YELLOW := \033[38;2;255;216;102m
PINK   := \033[38;2;255;97;136m
DIM    := \033[2m
RESET  := \033[0m

.DEFAULT_GOAL := help

# ─── Helpers ─────────────────────────────────────────────────────────────────
define symlink
	@mkdir -p "$(dir $(2))"
	@if [ -L "$(2)" ] && [ "$$(readlink '$(2)')" = "$(1)" ]; then \
		printf "$(DIM)  ·  $(notdir $(2)) (sin cambios)$(RESET)\n"; \
	elif [ -e "$(2)" ] && [ ! -L "$(2)" ]; then \
		mv "$(2)" "$(2).backup.$$(date +%Y%m%d%H%M%S)"; \
		ln -sf "$(1)" "$(2)"; \
		printf "$(YELLOW)  ↺  $(notdir $(2)) (backup creado)$(RESET)\n"; \
	else \
		ln -sf "$(1)" "$(2)"; \
		printf "$(GREEN)  ✓  $(notdir $(2))$(RESET)\n"; \
	fi
endef

# ─── Targets ─────────────────────────────────────────────────────────────────

.PHONY: help
help:
	@printf "\n$(CYAN)AndresMarulanda10 · dotfiles$(RESET)\n"
	@printf "$(DIM)repo: $(DOTFILES_DIR)$(RESET)\n\n"
	@printf "  $(YELLOW)make install$(RESET)   instala / actualiza todos los symlinks\n"
	@printf "  $(YELLOW)make link$(RESET)      alias de install\n"
	@printf "  $(YELLOW)make status$(RESET)    muestra el estado de cada symlink\n"
	@printf "  $(YELLOW)make check$(RESET)     alias de status\n"
	@printf "  $(YELLOW)make brew$(RESET)      instala paquetes del Brewfile\n"
	@printf "\n"

.PHONY: install link
install link:
	@printf "\n$(CYAN)→ Linkeando desde: $(DOTFILES_DIR)$(RESET)\n\n"
	@printf "$(YELLOW)zsh$(RESET)\n"
	$(call symlink,$(DOTFILES_DIR)/zsh/.zshrc,$(HOME)/.zshrc)
	$(call symlink,$(DOTFILES_DIR)/zsh/andres.zsh-theme,$(HOME)/.oh-my-zsh/custom/themes/andres.zsh-theme)

	@printf "$(YELLOW)git$(RESET)\n"
	$(call symlink,$(DOTFILES_DIR)/git/.gitconfig,$(HOME)/.gitconfig)

	@printf "$(YELLOW)bat$(RESET)\n"
	$(call symlink,$(DOTFILES_DIR)/bat/config,$(HOME)/.config/bat/config)

	@printf "$(YELLOW)lazygit$(RESET)\n"
ifeq ($(IS_MAC),1)
	$(call symlink,$(DOTFILES_DIR)/lazygit/config.yml,$(HOME)/Library/Application Support/lazygit/config.yml)
else
	$(call symlink,$(DOTFILES_DIR)/lazygit/config.yml,$(HOME)/.config/lazygit/config.yml)
endif

ifeq ($(IS_MAC),1)
	@printf "$(YELLOW)aerospace$(RESET)\n"
	$(call symlink,$(DOTFILES_DIR)/aerospace/.aerospace.toml,$(HOME)/.aerospace.toml)
endif

	@printf "$(YELLOW)opencode$(RESET)\n"
	$(call symlink,$(DOTFILES_DIR)/opencode/opencode.json,$(HOME)/.config/opencode/opencode.json)

	@printf "\n$(GREEN)✓ Todo linkeado desde $(DOTFILES_DIR)$(RESET)\n\n"
	@printf "$(DIM)  Si movés el repo, simplemente corré \`make\` de nuevo.$(RESET)\n\n"

.PHONY: status check
status check:
	@printf "\n$(CYAN)Estado de symlinks$(RESET)\n"
	@printf "$(DIM)repo: $(DOTFILES_DIR)$(RESET)\n\n"
	@for f in \
		"$(HOME)/.zshrc" \
		"$(HOME)/.gitconfig" \
		"$(HOME)/.aerospace.toml" \
		"$(HOME)/.config/bat/config" \
		"$(HOME)/Library/Application Support/lazygit/config.yml" \
		"$(HOME)/.config/opencode/opencode.json"; do \
		name=$$(basename "$$f"); \
		if [ -L "$$f" ]; then \
			target=$$(readlink "$$f"); \
			if [ -e "$$f" ]; then \
				printf "$(GREEN)  ✓$(RESET)  $$name → $(DIM)$$target$(RESET)\n"; \
			else \
				printf "$(PINK)  ✗$(RESET)  $$name → $(PINK)$$target (ROTO — archivo origen no existe)$(RESET)\n"; \
			fi; \
		elif [ -e "$$f" ]; then \
			printf "$(YELLOW)  ·$(RESET)  $$name $(DIM)(archivo real, no symlink)$(RESET)\n"; \
		else \
			printf "$(DIM)  -  $$name (no existe)$(RESET)\n"; \
		fi; \
	done
	@printf "\n"

.PHONY: brew
brew:
	@printf "\n$(CYAN)→ Instalando paquetes del Brewfile...$(RESET)\n"
	brew bundle --file=$(DOTFILES_DIR)/Brewfile
	@printf "\n$(GREEN)✓ brew bundle completado$(RESET)\n\n"
