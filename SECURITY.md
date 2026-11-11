# Security policy

Este repo es un baseline público de dotfiles para reconstruir mi entorno macOS. No está pensado para guardar secretos ni identidad privada.

## Alcance

Se versionan configuraciones reproducibles y seguras: shell, Git base, terminal, herramientas CLI y apps de Homebrew. VS Code queda como archivo histórico inactivo, fuera del baseline y de la recuperación.

Quedan fuera a propósito:

- llaves SSH y `~/.ssh/config`
- tokens, `.env`, credenciales y archivos `*.local`
- identidad Git real fuera de `~/.gitconfig.local`
- configuración completa de OpenCode, salvo `opencode/themes/dracula-terminal.json`, asset independiente sin credenciales
- logins, permisos de macOS y sesiones de apps

## Bootstrap

El setup usa scripts remotos estándar para Homebrew y Oh My Zsh. Antes de ejecutarlos, revisá los comandos y corré el instalador solo en máquinas propias.

## Git identity

La configuración versionada de Git incluye `~/.gitconfig.local`. Ese archivo debe crearse localmente con permisos restrictivos y no debe commitearse.

Ejemplo:

```ini
[user]
	name = Tu Nombre
	email = tu-correo@ejemplo.com
	useConfigOnly = true
```

`useConfigOnly = true` evita que Git caiga al fallback automático de `usuario@hostname` cuando falta identidad explícita.

## Reporte de problemas

Si aparece un secreto commiteado por error, la respuesta correcta no es solo borrarlo: hay que rotarlo, eliminarlo del historial si aplica y revisar dónde se usó.
