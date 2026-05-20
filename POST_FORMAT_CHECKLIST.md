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
- [ ] Elegir plantillas de VS Code si corresponde
- [ ] Asignar aliases locales por proyecto si hace falta

## 4. Validar terminal y shell

- [ ] Abrir una terminal nueva
- [ ] Confirmar que `zsh` carga sin errores
- [ ] Confirmar que `fastfetch` aparece una sola vez por sesión
- [ ] Confirmar que `atuin` funciona si está instalado
- [ ] Confirmar que Ghostty abre con la configuración esperada

## 5. Validar herramientas core

- [ ] Verificar que `git`, `gh`, `bat`, `lazygit`, `eza`, `fd`, `rg` estén disponibles
- [ ] Verificar que AeroSpace abra y pedir permisos de Accesibilidad si macOS los solicita
- [ ] Verificar que VS Code abra y aplicar/recargar configuración

## 6. VS Code

- [ ] Abrir VS Code
- [ ] Ejecutar reload de ventana si hace falta
- [ ] Confirmar que el theme / layout / extensiones base quedaron correctos
- [ ] Confirmar plantillas por stack (`java-aws`, `web-ts`, `mobile-astro`, `data-science`)
- [ ] Hacer login en GitHub / Copilot si aplica

## 7. Seguridad / manual

Estas cosas quedan manuales a propósito:

- [ ] Crear llaves SSH nuevas (`ssh-keygen`)
- [ ] Configurar `~/.ssh/config` manualmente
- [ ] Cambiar remote del repo de HTTPS a SSH
- [ ] Reaplicar cualquier ajuste manual de opencode / gentle-ai fuera del repo

## 8. Apps y sesiones

- [ ] Hacer login en Tailscale
- [ ] Hacer login en OrbStack si aplica
- [ ] Instalar / abrir apps no cubiertas por el repo (Notion, WhatsApp, Discord, Raycast, etc.)

## 9. Ajustes macOS

- [ ] Revisar keyboard repeat rate
- [ ] Revisar trackpad / gestures
- [ ] Revisar Dock / Mission Control
- [ ] Revisar permisos de Accesibilidad / Full Disk Access según apps

## 10. Cierre

- [ ] Verificar que el working tree del repo siga limpio
- [ ] Hacer una nota rápida de cualquier ajuste manual que valga la pena automatizar después
