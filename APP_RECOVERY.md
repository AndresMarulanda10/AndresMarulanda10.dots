# App recovery before formatting

Use the Brewfile for the approved baseline; restore the remaining apps individually. This is an inventory, not proof of a successful clean-Mac restore. Never bulk-copy application support folders or credentials into this public repository.

## Automated baseline

`Brewfile` declares the selected CLI tools (including `anomalyco/tap/opencode-v2`, Neovim and mpv), macOS apps and fonts. It intentionally does not mirror all 164 installed formulas: only the approved baseline is retained. Casks are guarded by `OS.mac?`; Codespaces Todo only configures its four offered modules.

Moonlight replaces RealVNC in the declarations. The official [Homebrew cask metadata](https://formulae.brew.sh/api/cask/moonlight.json), checked 2026-11-11, identifies `moonlight`, upstream `moonlight-stream/moonlight-qt`, and `Moonlight.app`. The observed manual installation was 6.1.0; recovery is not version-pinned. Pairing, hosts and macOS permissions remain manual. Existing manual apps may conflict with cask installation: inspect and resolve deliberately, never force-overwrite them.

## Manual recovery channels

| Observed apps | Recovery channel / action |
|---|---|
| ChatGPT, DeepL, Discord, Godot | Official vendor downloads; sign in separately where needed |
| CurseForge, GameHub, Steam | Official vendor launchers; recover libraries/saves through supported backup or account workflows |
| Jump Desktop Connect, RemotePlay | Official vendor downloads; confirm the exact product before reinstalling and reauthorize access locally |
| Logitech Options+ | Official Logitech download; reapply device permissions |
| FocusPomo, JapaneseLife, Excel, Word, MyWallpaper, WhatsApp, Xcode | App Store purchase/download history; Microsoft licensing and Xcode setup remain manual |
| Cyberpunk 2077 (user Applications) | Original licensed distribution and supported saves backup |
| Odelza (private app) | Private authorized distribution; no binaries, private paths or account data in this repo |

IINA has a receipt but no observed app: do not reinstall automatically. VS Code, RealVNC and Orca are explicitly excluded, even if installed today. Personal/corporate agents are not automatically approved by their presence. This change uninstalls nothing.

## Configuration and private recovery

- The installer copies configs with timestamped backups. Three existing legacy symlinks (`~/.zshrc`, the Oh My Zsh `andres.zsh-theme`, and `~/.aerospace.toml`) are preserved on this Mac; no links were changed. A future selected install backs up the link and writes a real copy. Verify each target before formatting; the symlinks themselves are not a backup.
- Restore private SSH material/config only through a separate secure process. Desired prompt labels are local Mac `andresmarulanda` and remote `davi-`, `mew-`, `odelza-vps-`, `orb-andresmarulanda`. Remote account-local setup remains pending: no connection, authorization or remote modification was performed or implied.
- Optional `OpenCode theme` copies only the standalone Dracula asset. Select `dracula-terminal` in the OpenCode UI. Its six transparent background values are preserved verbatim; server/CLI settings, providers, tokens and sessions are not recovered.
- Keep licenses, app logins, pairing, saves and private backups outside Git. Review restore coverage before erasing the disk; syntax and isolated tests are not a full installation or visual test.
