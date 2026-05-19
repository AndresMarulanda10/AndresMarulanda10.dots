#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_DIR=""

usage() {
  cat <<'USAGE'
Uso:
  vscode/apply-profile.sh base
  vscode/apply-profile.sh <perfil>
  vscode/apply-profile.sh base <perfil> [perfil...]
  vscode/apply-profile.sh base <perfil:alias-local> [perfil:alias-local...]

Perfiles:
  base          Solo settings/keybindings/extensiones globales
  java-aws      Davivienda: Java + AWS + Angular
  web-ts        Next.js + Node + Supabase + Vercel
  mobile-astro  Astro + Flutter + Node + Figma
  data-science  Python + Jupyter

Qué hace:
  - Instala extensiones desde vscode/global/extensions.txt y el perfil elegido.
  - Genera settings.json combinando vscode/global/settings.json + perfiles en orden.
  - Copia vscode/global/keybindings.json si existe.

Nota:
  Esta estrategia es versionable en Git y no depende de exportar .code-profile.
  Los aliases locales se guardan fuera del repo en ~/.config/andresmarulanda10.dots/vscode-profile-aliases.json
  Si querés aislar ventanas por perfil nativo, abrí VS Code con:
    code --profile "<perfil>" <ruta-del-proyecto>
USAGE
}

detect_vscode_dir() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
  else
    VSCODE_DIR="$HOME/.config/Code/User"
  fi
}

save_aliases() {
  [[ "$#" -gt 0 ]] || return 0

  local alias_file="${XDG_CONFIG_HOME:-$HOME/.config}/andresmarulanda10.dots/vscode-profile-aliases.json"
  mkdir -p "$(dirname "$alias_file")"

  python3 - "$alias_file" "$@" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
pairs = sys.argv[2:]

if path.exists():
    data = json.loads(path.read_text())
else:
    data = {"aliases": {}}

aliases = data.setdefault("aliases", {})

for pair in pairs:
    template, alias = pair.split("::", 1)
    aliases[alias] = template

path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
PY

  echo "  Aliases locales: $alias_file"
}

install_extensions() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  command -v code >/dev/null 2>&1 || {
    echo "WARN: 'code' no está en PATH; salteo instalación de extensiones: $file" >&2
    return 0
  }

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    extension="${extension%%#*}"
    extension="$(printf '%s' "$extension" | xargs)"
    [[ -z "$extension" ]] && continue
    code --install-extension "$extension" >/dev/null
  done < "$file"
}

merge_settings() {
  local global_settings="$1"
  local profile_settings="${2:-}"
  local output="$3"

  python3 - "$global_settings" "$profile_settings" "$output" <<'PY'
import json
import pathlib
import sys

def strip_jsonc(text: str) -> str:
    out = []
    i = 0
    in_string = False
    escape = False
    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""

        if in_string:
            out.append(ch)
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_string = False
            i += 1
            continue

        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue
        if ch == "/" and nxt == "/":
            i += 2
            while i < len(text) and text[i] not in "\r\n":
                i += 1
            continue
        if ch == "/" and nxt == "*":
            i += 2
            while i + 1 < len(text) and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(ch)
        i += 1
    return "".join(out)

def load_jsonc(path: str) -> dict:
    if not path:
        return {}
    p = pathlib.Path(path)
    if not p.exists():
        return {}
    return json.loads(strip_jsonc(p.read_text()))

def deep_merge(base: dict, overlay: dict) -> dict:
    result = dict(base)
    for key, value in overlay.items():
        if isinstance(result.get(key), dict) and isinstance(value, dict):
            result[key] = deep_merge(result[key], value)
        else:
            result[key] = value
    return result

global_path, profile_path, output_path = sys.argv[1:4]
merged = deep_merge(load_jsonc(global_path), load_jsonc(profile_path))
pathlib.Path(output_path).parent.mkdir(parents=True, exist_ok=True)
pathlib.Path(output_path).write_text(json.dumps(merged, indent=2, ensure_ascii=False) + "\n")
PY
}

main() {
  [[ "$#" -gt 0 ]] || { usage; exit 1; }
  [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

  local global_dir="$ROOT_DIR/vscode/global"
  local raw_profile=""
  local profile=""
  local alias=""
  local profile_dir=""
  local -a profile_settings=()
  local -a profile_extensions=()
  local -a applied_profiles=()
  local -a alias_pairs=()

  for raw_profile in "$@"; do
    [[ "$raw_profile" == "base" ]] && continue
    profile="${raw_profile%%:*}"
    alias=""
    if [[ "$raw_profile" == *:* ]]; then
      alias="${raw_profile#*:}"
    fi
    profile_dir="$ROOT_DIR/vscode/profiles/$profile"
    [[ -d "$profile_dir" ]] || {
      echo "Perfil desconocido: $profile" >&2
      usage
      exit 1
    }
    profile_settings+=("$profile_dir/settings.json")
    profile_extensions+=("$profile_dir/extensions.txt")
    applied_profiles+=("$profile")
    if [[ -n "$alias" ]]; then
      alias_pairs+=("$profile::$alias")
    fi
  done

  detect_vscode_dir
  [[ -d "$VSCODE_DIR" ]] || {
    echo "VS Code no está instalado o nunca se abrió: $VSCODE_DIR" >&2
    exit 1
  }

  mkdir -p "$VSCODE_DIR"
  if [[ -f "$global_dir/keybindings.json" ]]; then
    cp "$global_dir/keybindings.json" "$VSCODE_DIR/keybindings.json"
  fi

  local current_settings="$global_dir/settings.json"
  local tmp_settings=""
  local next_settings=""

  if [[ "${#profile_settings[@]}" -eq 0 ]]; then
    merge_settings "$global_dir/settings.json" "" "$VSCODE_DIR/settings.json"
  else
    tmp_settings="$(mktemp)"
    merge_settings "$global_dir/settings.json" "${profile_settings[0]}" "$tmp_settings"
    current_settings="$tmp_settings"

    local i=1
    while [[ "$i" -lt "${#profile_settings[@]}" ]]; do
      next_settings="$(mktemp)"
      merge_settings "$current_settings" "${profile_settings[$i]}" "$next_settings"
      [[ "$current_settings" == "$tmp_settings" || "$current_settings" == /tmp/* || "$current_settings" == /var/folders/* ]] && rm -f "$current_settings"
      current_settings="$next_settings"
      i=$((i + 1))
    done

    cp "$current_settings" "$VSCODE_DIR/settings.json"
    rm -f "$current_settings"
  fi

  install_extensions "$global_dir/extensions.txt"
  for profile_extensions_file in "${profile_extensions[@]}"; do
    install_extensions "$profile_extensions_file"
  done

  save_aliases "${alias_pairs[@]}"

  if [[ "${#applied_profiles[@]}" -eq 0 ]]; then
    echo "✓ VS Code aplicado: base"
  else
    echo "✓ VS Code aplicado: base + ${applied_profiles[*]}"
  fi
  echo "  Settings: $VSCODE_DIR/settings.json"
  echo "  Recargá VS Code: Cmd+Shift+P → Reload Window"
}

main "$@"
