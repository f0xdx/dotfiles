# README Conventions

## Formatting

* No Leading Bold: Avoid `**Tool**: description`. Use `[Tool](url) is used for...`.
* Lists: Use `*` for unordered and `1.` for numeric lists.
* Info Boxes: Use GitHub-style `> [!NOTE]` for warnings or notes.
* URLs: All tool references must include full hyperlinks to official repositories.

## Required Sections

1. Structure: Project directory overview.
2. Keybindings: Links to `keybindings.md`.
3. Desktop Environment: Window manager, status bar, and utilities.
4. CLI & AI: Modern toolchain and Gemini CLI integrations.
5. How to Apply: Setup guide including `nix flake update`.

## Constraints

* Omit host-specific hardware details.
* Omit contribution guidelines for personal repos.
* Map hosts to architecture/OS (e.g., `buildr` on NixOS/Linux, `PC90221.local` on macOS/Darwin).
* Internal references must use valid relative paths.
