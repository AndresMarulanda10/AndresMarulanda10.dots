# Post-format checklist

Checklist mínimo para reconstruir la Mac después de formatearla.

## 1. Base del sistema

- [ ] Iniciar sesión en iCloud / App Store
- [ ] Instalar Xcode Command Line Tools si macOS no lo hizo todavía
- [ ] Instalar Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Clonar el repo

Primero por HTTPS, porque todavía no existe SSH local.

```bash
git clone https://github.com/AndresMarulanda10/AndresMarulanda10.dots.git ~/Documents/personal/AndresMarulanda10.dots
cd ~/Documents/personal/AndresMarulanda10.dots
```

## 3. Ejecutar instalación

- [ ] Correr `./install.sh`
- [ ] Elegir módulos a instalar
- [ ] Completar nombre y email para `~/.gitconfig.local`
- [ ] Revisar [APP_RECOVERY.md](APP_RECOVERY.md) antes de recuperar apps manuales

## 4. Validar terminal y shell

- [ ] Abrir una terminal nueva
- [ ] Confirmar que `zsh` carga sin errores
- [ ] Confirmar que `fastfetch` aparece una sola vez por sesión
- [ ] Confirmar que `atuin` funciona si está instalado
- [ ] Confirmar que Ghostty abre con la configuración esperada

## 5. Validar herramientas core

- [ ] Verificar que `git`, `gh`, `bat`, `lazygit`, `eza`, `fd`, `rg` estén disponibles
- [ ] Verificar que AeroSpace abra y pedir permisos de Accesibilidad si macOS los solicita
- [ ] Verificar `opencode --version`, `nvim`, `mpv` y Moonlight

## 6. Editor y asistencia

- [ ] Confirmar que Git y shell usan Neovim
- [ ] Configurar proveedores de OpenCode V2 manualmente, fuera del repo
- [ ] Opcional: instalar `OpenCode theme` y seleccionar `dracula-terminal` en la UI

VS Code, RealVNC y Orca no forman parte de la recuperación aprobada.

## 7. Seguridad / manual

Estas cosas quedan manuales a propósito:

- [ ] Crear llaves SSH nuevas (`ssh-keygen`)
- [ ] Configurar `~/.ssh/config` manualmente
- [ ] Cambiar remote del repo de HTTPS a SSH
- [ ] Reaplicar cualquier ajuste manual de opencode / gentle-ai fuera del repo

## 8. Apps y sesiones

- [ ] Hacer login en Tailscale
- [ ] Hacer login en OrbStack si aplica
- [ ] Instalar / abrir apps personales no cubiertas por el repo (WhatsApp, Discord, etc.)

## 9. Ajustes macOS

- [ ] Revisar keyboard repeat rate
- [ ] Revisar trackpad / gestures
- [ ] Revisar Dock / Mission Control
- [ ] Revisar permisos de Accesibilidad / Full Disk Access según apps

## 10. Cierre

- [ ] Verificar que el working tree del repo siga limpio
- [ ] Hacer una nota rápida de cualquier ajuste manual que valga la pena automatizar después
