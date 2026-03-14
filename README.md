# AndresMarulanda10.dots

My personal dotfiles — reproducible dev environment for macOS. Clone, run, code.

---

## What's inside

| File | Description |
|------|-------------|
| `Brewfile` | All tools and apps installed via Homebrew |
| `zsh/.zshrc` | Zsh configuration |
| `zsh/themes/andres.zsh-theme` | Custom prompt theme (Monokai Pro palette) |

---

## Quick start

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```bash
git clone git@github.com:AndresMarulanda10/AndresMarulanda10.dots.git ~/Documents/Projects/AMR/AndresMarulanda10.dots
cd ~/Documents/Projects/AMR/AndresMarulanda10.dots
```

### 3. Install everything

```bash
brew bundle
```

### 4. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### 5. Copy dotfiles

```bash
cp zsh/.zshrc ~/.zshrc
cp zsh/themes/andres.zsh-theme ~/.oh-my-zsh/themes/andres.zsh-theme
```

### 6. Reload shell

```bash
source ~/.zshrc
```

---

## Post-install — Manual steps

### Java

Homebrew installs `openjdk` but doesn't link it to the system automatically:

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

### OrbStack

OrbStack is **macOS only**. Skip this on Linux — use Docker Engine directly instead.

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

### Apps
| App | Description |
|-----|-------------|
| VS Code | Editor |
| OrbStack | Docker/Linux VMs (macOS only) |
| Insomnia | API client |
| OpenCode | AI coding assistant |

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
| Linux | ⚠️ Skip OrbStack, adjust Homebrew path |
| GitHub Codespaces | 🔜 Coming soon |
