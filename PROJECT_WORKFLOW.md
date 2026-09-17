# Project Workflow

This document records the operational workflow for organizing projects and working with Herdr, OpenCode, LazyGit, and Neovim. It is a practical starting point, not an immutable business priority decision.

Herdr is installed as the Homebrew core formula `herdr`. It is covered by the existing TUI installation flow: `Brewfile` -> `install.sh` -> `brew bundle`. OpenCode is tracked in the same Brewfile through `anomalyco/tap`.

## Tool Roles

| Tool | Role |
|------|------|
| Herdr | Organizes and monitors agent sessions. It is the primary tool for Mew and agent work. |
| OpenCode | Provides assisted implementation and research from each project root. |
| LazyGit | Handles Git status, diffs, commits, and branch work. |
| Neovim | Handles editing, navigation, and project or tool configuration. |

## Operational Priority

| Priority | Projects | Operating intent |
|----------|----------|------------------|
| P0 | `mew-stack` and Mew agent repositories | Main agent-driven work; organize and monitor sessions with Herdr. |
| P1 | `mew-template` and `odelza` | Active application and template work; use Herdr when agent sessions are useful. |
| P2 | Dotfiles and configuration | Maintain the local development environment and reproducible setup. |
| P3 | `monitoreo-plagas` and `AppleMusicTUI` | Secondary projects; use the same tools as needed without requiring Herdr. |

This ordering is an initial operational map. Reprioritize it as current work changes; it is not a permanent business decision.

## Per-Project Workflow

| Project | Herdr | OpenCode | LazyGit | Neovim |
|---------|-------|----------|---------|--------|
| `mew-stack` | Primary for agent/session organization and monitoring | Assisted implementation and research from the project root | Review status and diffs; commit and manage branches | Edit and navigate the stack |
| Mew agent repositories | Primary for agent/session organization and monitoring | Assisted implementation and research from each project root | Review status and diffs; commit and manage branches | Edit agent code and configuration |
| `mew-template` | Optional when agent sessions are useful | Assisted implementation and research from the project root | Review status and diffs; commit and manage branches | Edit and navigate the template |
| `odelza` | Optional for non-agent work | Assisted implementation and research from the project root | Review status and diffs; commit and manage branches | Edit and navigate the project |
| Dotfiles/configuration | Optional | Assisted implementation and research from the dotfiles root | Review status and diffs; commit and manage branches | Edit and navigate configuration |
| `monitoreo-plagas` | Optional for non-agent work | Assisted implementation and research from the project root | Review status and diffs; commit and manage branches | Edit and navigate the project |
| `AppleMusicTUI` | Optional for non-agent work | Assisted implementation and research from the project root | Review status and diffs; commit and manage branches | Edit and navigate the project |

## Recovery Commands

Set `DOTFILES_DIR` to the root of this repository, then restore the tools through the existing Brewfile installation path:

```bash
brew bundle --file="$DOTFILES_DIR/Brewfile"
herdr --help
```

The current Homebrew installation also contains Orca, but Homebrew marks that cask as disabled by the macOS Gatekeeper check. It is therefore documented as a manual recovery item rather than included in the automated Brewfile path.

For project work, start each tool from the relevant project root:

```bash
cd <project-root>
opencode
lazygit
nvim .
```

Herdr's exact operational commands are intentionally not prescribed here. Use `herdr --help` to inspect the installed version and available commands.
