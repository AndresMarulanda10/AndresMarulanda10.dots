# AndresMarulanda10.dots

Mis dotfiles personales para reconstruir una Mac real después de formatear.

La estrategia principal ahora es **copy-based**: el instalador copia configs a las rutas normales del sistema y hace backup con timestamp si ya existe algo. No deja las configs instaladas dependiendo de symlinks al repo.

---

## Estructura

```text
.
├── aerospace/          # AeroSpace window manager
├── atuin/              # Config versionable de Atuin
├── bat/                # bat
├── fastfetch/          # Config + logo usado al abrir terminal
├── ghostty/            # Config + shader usado por Ghostty
├── git/                # .gitconfig base; identidad local fuera del repo
├── lazygit/            # Lazygit
├── vscode/             # Settings/perfiles aplicados por script propio
├── zsh/                # .zprofile, .zshrc y theme andres
├── Brewfile
└── install.sh
```

---

## Instalación

Antes de correr cualquier cosa, revisá `Brewfile`, `install.sh` y los módulos que vas a instalar. Este repo instala software de terceros y ejecuta scripts remotos estándar del ecosistema macOS; usalo solo en máquinas tuyas y con criterio.

### 1. Instalar Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clonar el repo

Primero clonalo por HTTPS. Después, cuando ya tengas SSH configurado en la máquina, podés cambiar el remote a SSH.

```bash
git clone https://github.com/AndresMarulanda10/AndresMarulanda10.dots.git ~/Documents/personal/AndresMarulanda10.dots
cd ~/Documents/personal/AndresMarulanda10.dots
```

### 3. Ejecutar instalador

```bash
./install.sh
```

El instalador usa [Gum](https://github.com/charmbracelet/gum) para elegir módulos. Si Gum no está, lo instala con Homebrew.

Cuando copiás una config y el destino ya existe, se mueve a:

```text
archivo.backup.YYYYMMDDHHMMSS
```

---

## Módulos incluidos

| Módulo | Destino |
|--------|---------|
| `zsh` | `~/.zprofile`, `~/.zshrc`, theme en Oh My Zsh |
| `git` | `~/.gitconfig` + genera `~/.gitconfig.local` |
| `bat` | `~/.config/bat/config` |
| `lazygit` | macOS: `~/Library/Application Support/lazygit/config.yml`; Linux: `~/.config/lazygit/config.yml` |
| `ghostty` | `~/.config/ghostty` |
| `atuin` | `~/.config/atuin/config.toml` |
| `fastfetch` | `~/.config/fastfetch` |
| `aerospace` | `~/.aerospace.toml` |
| `VS Code` | Aplica settings reales con `vscode/apply-profile.sh` |

---

## Git local

`git/.gitconfig` incluye:

```ini
[include]
    path = ~/.gitconfig.local
```

Al instalar `git`, la TUI pide nombre y email y genera:

```text
~/.gitconfig.local
```

Si ya existe, pregunta antes de reemplazarlo y crea backup. Ese archivo NO se versiona porque es identidad local de la máquina.

---

## Zsh

Se versionan:

- `zsh/.zprofile`: Homebrew shellenv + integración OrbStack protegida.
- `zsh/.zshrc`: Oh My Zsh con theme `andres`, aliases, Atuin y Fastfetch.
- `zsh/andres.zsh-theme`: prompt actual.

Detalles importantes:

- Homebrew se inicializa en `.zprofile`, no dos veces en `.zshrc`.
- Atuin se activa solo si `atuin` existe.
- Fastfetch se muestra en shells interactivos, una vez por sesión, y no en CI.
- Plugins externos se sourcean solo si el archivo existe.
- Zellij queda fuera por ahora: no se asume auto-start.

---

## VS Code

VS Code mantiene estrategia propia: `vscode/apply-profile.sh` combina settings versionables y escribe archivos reales en la config de VS Code. No usa symlink.

Plantillas disponibles:

| Profile | Stack |
|---------|-------|
| `java-aws` | Java, AWS, Angular |
| `web-ts` | Next.js, Node, Supabase, Vercel |
| `mobile-astro` | Astro, Flutter, Node, Figma |
| `data-science` | Python, Jupyter |

Ejemplos:

```bash
./vscode/apply-profile.sh base
./vscode/apply-profile.sh base web-ts java-aws:Davivienda
```

---

## Seguridad / manual

Para más detalles, ver `SECURITY.md`.

Queda intencionalmente fuera:

- **SSH config**: manual y no versionable por seguridad.
- **Claves SSH**: generarlas manualmente después del setup y recién ahí cambiar remotes a SSH.
- **SSHFS / macFUSE**: se dejaron fuera del baseline porque en Apple Silicon pueden requerir bajar la postura de seguridad del sistema (`Reduced Security`). Si algún día los necesitás, instalalos manualmente y con esa decisión bien consciente.
- **Neovim**: no se usa en esta fase.
- **Config completa de opencode**: queda fuera. Si necesitás un theme puntual, aplicalo manualmente fuera del repo.
- **Zellij auto-start**: fuera por ahora para no cambiar comportamiento de shell sin decisión explícita.
- **Login en apps**: Tailscale, GitHub/Copilot, OrbStack y cualquier app personal siguen siendo manuales.
- **Permisos de macOS**: Accesibilidad / Full Disk Access para apps como AeroSpace o Ghostty siguen siendo manuales.

Tailscale ya está cubierto por `Brewfile` con `tailscale-app`; no necesita configuración especial en esta fase.

---

## Trabajo futuro

Por ahora el flujo es repo → sistema. No hay sincronización automática sistema → repo.

Si en el futuro hace falta capturar cambios locales, conviene implementar un comando explícito de sync/reconcile con diff y allowlist. No hacerlo a medias: copiar configs locales sin revisar es una receta para versionar basura o secretos, y eso NO.

También existe `POST_FORMAT_CHECKLIST.md` como guía operativa para reconstruir la Mac paso a paso.

---

## Plataformas

| Platform | Status |
|----------|--------|
| macOS Apple Silicon | ✅ Principal |
| macOS Intel | ✅ Soportado |
| Linux | ⚠️ Parcial; se omiten apps macOS-only |
| GitHub Codespaces | ⚠️ Básico: zsh, git, bat, lazygit, VS Code |
