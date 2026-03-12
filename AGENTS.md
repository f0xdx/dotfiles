# AGENTS.md

This file provides guidance for AI agents interacting with this Nix-based
dotfiles repository.

## Project Overview

This project uses **Nix Flakes** to manage both **NixOS** system configurations
and **Home Manager** user environments across different platforms (Linux,
macOS).

## Inventory & Structure

- `flake.nix`: The central entry point. Defines `nixosConfigurations` and
  `homeConfigurations`.
- `home/`: Modular user configuration.
    - `shell/`: Shell environment and aliases.
    - `editor/`: Config for `nvim` and `zed`.
    - `terminal/alacritty/`: Terminal configuration.
    - `desktop/`: Window manager (Hyprland), status bar (Waybar), and
      notifications.
    - `browser/firefox/`: Firefox customization.
    - `agents/`: AI-related configurations and skills.
- `system/`: System-level NixOS modules (Bluetooth, Sound, Printing, etc.).
- `hosts/`: Host-specific overrides.
    - `buildr/`: NixOS configuration for the primary workstation.
    - `PC90221.local/`: macOS configuration for the work machine.

## Key Workflows

### Update Dependencies

```sh
nix flake update
```

### Apply System Changes (NixOS)
```sh
sudo nixos-rebuild switch --flake .#
```

### Apply User Changes (Home Manager)

```sh
home-manager switch --flake .
```

## Coding Conventions

- Modular Imports: Prefer adding features as separate Nix files/directories
  and importing them in `home/default.nix` or `system/default.nix`.
- Flake Helpers: Use `mkNixosSystem` and `mkHomeConfig` in `flake.nix` for
  new hosts.
- Variable Usage: Use `user`, `host`, and `home` variables passed through
  `specialArgs` and `extraSpecialArgs`.

### Markdown Conventions

* avoid excessive use of bold face, especially in lists
* use `*` for list items
* for numeric lists mark all items as `1.`, so sequence can be changed later
  without changing the numbering
* provide local file or weblinks where references are mentioned

## Safety & Secrets

- No Secrets: Never hardcode API keys, passwords, or sensitive data in
  `.nix` files.
- Git Hygiene: Do not stage or commit changes unless explicitly requested.
- Validation: Before finishing a change, ensure it passes `nix flake check`
  or try a dry-run of the switch commands.
