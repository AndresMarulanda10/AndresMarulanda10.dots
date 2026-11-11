# Mac rebuild synchronization

## Objective
Make the repository reproduce the approved terminal-first Mac baseline and document manual recovery before formatting.

## Scope and constraints
- Use OpenCode V2 and Neovim; remove VS Code, RealVNC, and Orca from the automated baseline without uninstalling local applications.
- Include Moonlight and mpv using verified installation identities or documented manual recovery.
- Preserve only the standalone Dracula theme, never private OpenCode settings, credentials, or sessions.
- Document existing symlinks and remote prompt labels without changing local links or connecting remotely.
- Preserve unrelated files and human changes. No push or pull request is authorized.
- Delivery strategy: ask-on-risk. Forecast: approximately 300–380 authored changed lines, including the copied theme asset (not generated). Above 400 total authored changed lines, stop before committing and await the parent's single-PR/chain decision.

## Tasks
- [x] T1: Align package declarations and installer choices with the approved baseline; cover installer selection behavior with isolated tests. Commit: `c079176`.
- [ ] T2: Add the portable Dracula theme and safe recovery documentation, including app inventory, symlink policy, and pending SSH setup.

## Routing
- T1: delegated direct; multi-file implementation and preparation require one bounded writer.
- T2: delegated direct; same sequential writer, preserving a single write thread.

## Acceptance criteria
- OpenCode V2 is declared; obsolete VS Code/RealVNC/Orca automated entries are absent.
- Moonlight recovery is verified and mpv declared; no blanket dependency capture.
- Codespaces Todo stays within its advertised module set; macOS behavior and explicit selection remain coherent.
- The theme is installable independently without replacing cli.json or opencode.json.
- Recovery docs distinguish automated packages, manual apps, licensed/private data, and untested restore steps.
- Remote labels are documented as pending account-local setup, not falsely reported active.

## Verification
- Observe RED then GREEN for deterministic installer selection tests using stubs or source-only helpers; never execute the real installer on this Mac.
- Run bash tests/bootstrap-contract.sh, bash -n install.sh, zsh -n on changed Zsh files, ruby -c Brewfile, JSON parsing for the theme, and git diff --check.
- RDD is off (global); do not start native review or change the preference. Assess the writer diff for proportional independent verification.
- Syntax and static tests do not prove a full clean-Mac installation or visual rendering.

## Progress
- Exploration: installed app inventory and repository drift were inspected read-only; no private SSH/authentication data belongs in recovery artifacts.
- Implementation: T1 and T2 source changes prepared on `feat/mac-rebuild-sync`; task closure awaits verification and work-unit commits. No installer, SSH connection, package install/uninstall or live configuration change was performed.
- RED: `bash tests/bootstrap-contract.sh` failed on the baseline selection helper (Todo enabled VS Code/nonexistent modules); GREEN after offered-option matching and package/editor alignment.
- Engram mirror: saved observation `11224`; related-memory judgment completed.
- Rollback boundaries: T1 package/menu/editor behavior with its tests and docs; T2 standalone theme copying and recovery documentation. Runtime evidence uses extracted inert helpers/menu only; no full installation or visual rendering is claimed. RDD remains off.
- Verification after source normalization: `bash tests/bootstrap-contract.sh` PASS (also staged T1 in isolation); `bash -n install.sh vscode/apply-profile.sh` PASS; `zsh -n zsh/.zprofile zsh/.zshrc zsh/andres.zsh-theme` PASS; `ruby -c Brewfile` Syntax OK; Python JSON parse/byte comparison/six transparent values PASS; `git diff --check` PASS.
- T2 implementation and checks passed; checkbox closure awaits the final commit identity recorded in the parent handoff (a commit cannot embed its own hash). No clean-Mac or visual test was performed.
