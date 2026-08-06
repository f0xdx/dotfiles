# dotfiles

Personal configuration for various tools and environments, managed with [Nix
Home Manager](https://github.com/nix-community/home-manager) and Nix Flakes.

## Structure

* `flake.nix` is the central entry point for all configurations.
* `home/` contains modular user configuration (shell, editors, desktop).
* `system/` contains system-level NixOS modules (services, desktop support).
* `hosts/` contains host-specific overrides (e.g., `buildr` for Linux, `PC90221` for macOS).

## Keybindings

A comprehensive [keybinds.md](keybinds.md) reference is available for quick access to application shortcuts:

* [Hyprland](keybinds.md#hyprland-window-manager)
* [Neovim](keybinds.md#neovim-editor)
* [Zed](keybinds.md#zed-editor)
* [Ghostty](keybinds.md#ghostty-terminal)
* [tmux](keybinds.md#tmux-terminal-multiplexer)
* [Bash / Shell](keybinds.md#bash--shell)

## Desktop Environment

A Wayland-based setup centered around [Hyprland](https://hyprland.org/) and its ecosystem:

* [waybar](https://github.com/Alexays/Waybar) for status bar with system info and controls.
* [mako](https://github.com/emersion/mako) for notifications with lightweight alerts.
* [greetd](https://git.sr.ht/~qbit/greetd) with [tuigreet](https://github.com/apognu/tuigreet) for login, [hypridle](https://github.com/hyprwm/hypridle)/[hyprlock](https://github.com/hyprwm/hyprlock) for session management.
* [grim](https://github.com/emersion/grim)/[slurp](https://github.com/emersion/slurp) for screenshots and [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for clipboard management.
* Nerd Fonts ([Hack](https://github.com/source-foundry/Hack), [Fira Code](https://github.com/tonsky/FiraCode)) for a rich terminal experience.

## CLI & AI Integration

* [eza](https://eza.rocks/), [bat](https://github.com/sharkdp/bat), [zoxide](https://github.com/ajeetdsouza/zoxide), and [fzf](https://github.com/junegunn/fzf) for a fast and modern CLI experience.
* [neovim](https://neovim.io/) for CLI editing and [zed](https://zed.dev/) as a modern IDE.
* custom bash utilities in `home/shell/bash/bin/` for git cleanup, TOC generation, and more.
* AI agents integrated via the Gemini CLI and custom skills in `home/agents/`.

## How to Apply

### Prerequisites
Ensure Nix is installed with `nix-command` and `flakes` enabled.

### Apply Configuration
1. Update dependencies: `nix flake update`
2. Apply System (NixOS): `sudo nixos-rebuild switch --flake .#`
3. Apply User (Home Manager): `home-manager switch --flake .`

> [!NOTE]
> For a first-time setup on systems not managed through Nix (macOS, etc.), use:
> `nix run --no-write-lock-file github:nix-community/home-manager/ -- --flake . switch`

> [!NOTE]
> On macOS, the [Ghostty](https://ghostty.org) terminal application must be installed manually. Home Manager automatically manages its configuration at `$XDG_CONFIG_HOME/ghostty/config` (`~/.config/ghostty/config`).

## Roadmap
See [tasks.md](tasks.md) for planned improvements and upcoming migrations.
