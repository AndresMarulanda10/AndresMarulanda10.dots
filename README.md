# AndresMarulanda10.dots

My personal dotfiles — reproducible dev environment for macOS. Clone, run, code.

---

## Structure

```
.
├── aerospace/          # AeroSpace window manager
│   └── .aerospace.toml
├── bat/                # bat (cat replacement)
│   └── config
├── git/                # Git config
│   └── .gitconfig
├── lazygit/            # Lazygit TUI config
│   └── config.yml
├── vscode/             # VS Code versionable profiles
│   ├── global/         # Base global limpia + keybindings mínimos
│   ├── profiles/       # Plantillas genéricas por stack
│   └── apply-profile.sh
├── zsh/                # Zsh + Oh My Zsh
│   ├── .zshrc
│   └── andres.zsh-theme
├── Brewfile            # All packages and apps
└── install.sh          # Interactive setup script
```

---

## Quick start

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```bash
git clone git@github.com:AndresMarulanda10/AndresMarulanda10.dots.git ~/Documents/personal/AndresMarulanda10.dots
cd ~/Documents/personal/AndresMarulanda10.dots
```

### 3. Run the installer

```bash
./install.sh
```

The installer uses [Gum](https://github.com/charmbracelet/gum) for a TUI — lets you pick which modules to set up. It will install Gum automatically if missing.

---

## Post-install — Manual steps

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### Java

Homebrew installs `openjdk` but doesn't link it to the system automatically:

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

### VS Code

VS Code usa una estrategia versionable propia en Git, no exports `.code-profile`.

La base global vive en:

```text
vscode/global/settings.json
vscode/global/keybindings.json
vscode/global/extensions.txt
```

No se versiona `mcp.json`: la configuración real local tiene MCPs/discovery, pero este repo mantiene VS Code limpio y solo conserva lo reproducible por archivos.

Sí se versiona un `keybindings.json` mínimo porque el único cambio real que querés mantener es `Cmd+Shift+M` para abrir/cerrar la terminal.

Las plantillas por stack viven en `vscode/profiles/`:

| Profile | Stack |
|---------|-------|
| `java-aws` | Davivienda: Java, AWS, Angular |
| `web-ts` | Next.js, Node, Supabase, Vercel |
| `mobile-astro` | Ancrar: Astro, Flutter, Node, Figma |
| `data-science` | Python, Jupyter |

El repo mantiene nombres genéricos por seguridad. Cuando corrés `./install.sh`, la TUI te deja asignar aliases locales por proyecto (por ejemplo `Tokinm`, `Davivienda`, `Ancrar`) y los guarda fuera del repo en:

```text
~/.config/andresmarulanda10.dots/vscode-profile-aliases.json
```

Aplicar solo la base:

```bash
./vscode/apply-profile.sh base
```

Aplicar uno o varios perfiles específicos:

```bash
./vscode/apply-profile.sh web-ts
./vscode/apply-profile.sh java-aws
./vscode/apply-profile.sh mobile-astro
./vscode/apply-profile.sh data-science
./vscode/apply-profile.sh base web-ts data-science
./vscode/apply-profile.sh base web-ts:Tokinm java-aws:Davivienda
```

El script combina `global/settings.json` + `profiles/<perfil>/settings.json` en orden, copia `global/keybindings.json` e instala extensiones desde `extensions.txt`. Desde `./install.sh`, al elegir VS Code, la TUI aplica `base` siempre y permite seleccionar plantillas extra.

Si querés separar ventanas con perfiles nativos de VS Code, abrí el proyecto con:

```bash
code --profile "web-ts" /ruta/al/proyecto
```

Después de aplicar settings, reload VS Code:

```
Cmd+Shift+P → Reload Window
Cmd+Shift+P → Custom UI Style: Reload
```

---

## Prompt (andres.zsh-theme)

Custom theme built on the Monokai Pro palette:

```
AndresMarulanda10  ~/…/path/to/project ❄ ⬡ v22.1.0 ·  main ✓
❯
```

| Element | Color | Style |
|---------|-------|-------|
| Username | `#FFD866` yellow | Bold |
| Path | `#FC9867` orange | Italic |
| Runtime version | varies | Bold |
| Branch | `#78DCE8` cyan | Bold + Italic |
| `❄` separator | `#FCFCFA` white | — |
| `·` separator | `#AB9DF2` purple | — |
| `❯` cursor | `#FF6188` pink | — |

**Runtime detection** — shows automatically based on project files:

| Runtime | Trigger file | Color |
|---------|-------------|-------|
| ⬡ Node | `package.json` | `#A9DC76` green |
| Ⓐ Angular | `angular.json` | `#FF6188` pink |
| ☕ Java | `pom.xml` / `build.gradle` | `#FFD866` yellow |

**Git status indicators:**

| Symbol | Meaning |
|--------|---------|
| `✓` | Clean |
| `⚡` | Dirty |
| `!` | Ahead of remote |
| `✚` | Added |
| `✹` | Modified |
| `✖` | Deleted |
| `➜` | Renamed |
| `✭` | Untracked |

---

## Tools

### CLI

| Tool | Description |
|------|-------------|
| `git` | Version control |
| `gh` | GitHub CLI |
| `lazygit` | Git TUI |
| `bat` | `cat` with syntax highlighting |
| `fd` | Modern `find` |
| `eza` | Modern `ls` |

### Zsh plugins (Oh My Zsh)

| Plugin | Description |
|--------|-------------|
| `git` | Git aliases |
| `z` | Smart directory jumping |
| `web-search` | Search from terminal |
| `copypath` | Copy current path to clipboard |
| `copyfile` | Copy file contents to clipboard |
| `command-not-found` | Suggests install when command is missing |
| `zsh-syntax-highlighting` | Colorizes valid/invalid commands |
| `zsh-autosuggestions` | History-based suggestions |

### Dev apps (via Brewfile)

| App | Description |
|-----|-------------|
| VS Code | Editor |
| OrbStack | Docker/Linux VMs (macOS only) |
| AeroSpace | Window manager (macOS only) |
| Homerow | Keyboard navigation (macOS only) |
| Mole | SSH tunnel manager (macOS only) |
| Ghostty | Terminal |
| Tailscale | Private networking |

### Daily apps

Apps I use daily — not in the Brewfile, install manually:

| App | Notes |
|-----|-------|
| Notion | Notes and docs |
| Notion Calendar | Calendar |
| WhatsApp | Messaging |
| Discord | Community |
| Claude Desktop | AI assistant |
| Figma | Design |
| FocusPomo | Pomodoro timer |
| MyWallpaper | Wallpaper manager |
| Microsoft Excel | Spreadsheets |
| Microsoft Word | Documents |
| Raycast | Launcher (optional — replaces Spotlight) |

### Runtimes

| Runtime | Description |
|---------|-------------|
| Node | Via Homebrew |
| OpenJDK | Via Homebrew (manual symlink required) |

---

## Aliases

```zsh
# Git
g       → git
gs      → git status
ga      → git add
gc      → git commit
gp      → git push
gl      → git log --oneline --graph --decorate

# Navigation
proj    → cd ~/Documents/Projects

# Utils
mkcd    → mkdir + cd in one command
```

---

## Platforms

| Platform | Status |
|----------|--------|
| macOS (Apple Silicon) | ✅ Fully supported |
| macOS (Intel) | ✅ Supported |
| Linux | ⚠️ Skip OrbStack, AeroSpace, Homerow, Mole — adjust Homebrew path |
| GitHub Codespaces | 🔜 Coming soon |
