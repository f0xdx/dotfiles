# Tasks

This file tracks the upcoming tasks, ideas, and planned improvements for the dotfiles project.

## Bash Utility Support (2025-05-26)

* [ ] bash scripts reviewed / improved
* [ ] bash scripts available as home manager module

## Extension points (2025-05-26)

* [ ] automatic brightness control on wayland with [wluma](https://github.com/maximbaz/wluma)
* [ ] tiling window manager on mac osx with [aerospace](https://github.com/nikitabobko/AeroSpace)

## Hyprland Configuration (2025-05-26)

* [ ] waybar setup
  * [ ] use wireplumber instead of pulse audio module in waybar
  * [x] add a system group under an icon for pop-up to show cpu/temp/mem/disk
        elements
  * [x] complete styling of waybar
* [ ] switch to Brave browser
* [ ] theme wlgout
* [ ] switch to fuzzel launcher
* [ ] switch bluetooth config to [bzmenu](https://github.com/e-tho/bzmenu)
      (flake exists)
* [ ] switch wifi config to [iwmenu](https://github.com/e-tho/iwmenu)
      (flake exists) - this requires [iwd](https://nixos.wiki/wiki/Iwd), configured with network manager

## Ops Module

Goal: Extract cloud and Kubernetes operations tooling from the shared shell module into a
dedicated `ops` module, cleanly separating ops concerns from the general shell environment.

* [ ] Create `home/ops/default.nix` with `ops.enable` option
* [ ] Move `kubectl`, `auth0-cli`, `google-cloud-sdk` (with GKE plugin), and `k` alias into
      the module
* [ ] Move `USE_GKE_GCLOUD_AUTH_PLUGIN` from `bash.initExtra` to `home.sessionVariables`
* [ ] Move kubectl bash completion from `bash.initExtra` into the module
* [ ] Enable `ops.enable = true` by default in `home/default.nix`; import the module there
* [ ] Remove all migrated items from `home/shell/default.nix`

## Option Naming Convention Refactor

Goal: Standardize module option names to use nested attribute sets instead of
underscore-suffixed names, consistent with the `spotify.enable` / `agents.enable` pattern
already in use.

Naming rules:

* Home manager modules: `<name>.enable` (safe — HM uses `programs.*` / `services.*`)
* System (NixOS) modules: `modules.<name>.enable` (required to avoid clashes with NixOS
  built-ins such as `sound.enable` and `console.*`)

Home manager renames:

* [ ] `desktop_support.enable` → `desktop.enable`
* [ ] `firefox_support.enable` → `firefox.enable`
* [ ] `alacritty_support.enable` → `alacritty.enable`
* [ ] `ghostty_support.enable` → `ghostty.enable`
* [ ] `hyprland_support.enable` → `hyprland.enable` (and `hyprland_support.color` →
      `hyprland.color`)
* [ ] `kanshi_support.enable` → `kanshi.enable`
* [ ] `waybar_support.enable` → `waybar.enable`
* [x] `agents_gemini.enable` → `agents.antigravity.enable`

System (NixOS) renames:

* [ ] `console_support.enable` → `modules.console.enable`
* [ ] `desktop_support.enable` → `modules.desktop.enable`
* [ ] `sound_support.enable` → `modules.sound.enable`
* [ ] `bluetooth_support.enable` → `modules.bluetooth.enable`
* [ ] `nvidia_support.enable` → `modules.nvidia.enable`
* [ ] `printing_support.enable` → `modules.printing.enable`

Cleanup:

* [ ] Fix copy-paste option descriptions (kanshi, home desktop, waybar, and sound all read
      "Enables proprietary driver nvidia support.")
* [ ] Update all option references in host configs and parent modules accordingly
* [ ] Verify with `nix flake check`

## Ollama Module

Goal: Extract ollama configuration from `editor/zed` into a standalone
`home/services/ollama` module that can be independently enabled and accelerated per host.

* [ ] Create `home/services/ollama/default.nix` with:
  * [ ] `ollama.enable` option
  * [ ] `ollama.acceleration` option (type `enum ["cuda" "rocm" "metal"]`, optional, no
        default)
* [ ] Move `services.ollama` configuration from `hosts/buildr/home.nix` into the module;
      set `ollama.enable = true` and `ollama.acceleration = "cuda"` in buildr's `home.nix`
* [ ] Import the new module in `home/default.nix` (disabled by default)

## Zed Module with Ollama Integration

Goal: Factor the Zed editor into a configurable module with optional ollama-backed inline
edit predictions.

* [ ] Add `zed.enable` option and wrap the existing config in `lib.mkIf config.zed.enable`
* [ ] Add `zed.ollamaIntegration.enable` sub-option (default `false`)
* [ ] When `zed.ollamaIntegration.enable = true`, configure Zed's inline AI / edit
      predictions to use the local ollama endpoint; derive the model from `ollama` module
      settings if available
* [ ] Emit a module warning if `zed.ollamaIntegration.enable = true` but `ollama.enable =
      false`
* [ ] Enable `zed.enable = true` by default in `home/default.nix`

## Multi-Hostname Support for macOS Host

Goal: The macOS machine is `PC90221.local` within the work network and `PC90221`
outside it. Both hostnames should resolve to the same home-manager configuration
so `home-manager switch --flake .` works in either environment.

* [x] Change the entry `felixheinrichs@PC90221.local` to
  `felixheinrichs@PC90221` in `homeConfigurations` in `flake.nix` by changing
  `host` to `hosts/PC90221`
* [x] Move `hosts/PC90221.local` to `hosts/PC90221`
* [x] Ensure that the resulting map has another entry
  `felixheinrichs@PC90221.local` pointing to the same contents as
  `felixheinrichs@PC90221` 
* [x] Remove the stale `# host = "PC90221"` comment in `flake.nix:120`

## Hyprland Ecosystem Migration (2026-03-20)

Goal: migrate tools used in the desktop config to the [hyprland
ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/), where tools exist. Avoid QT
usage where possible.

* [ ] Analzye the current setup and list all desktop components being used
* [ ] Identify which components could be replaced by hyprland ecosystem components
* [ ] Build a migration plan, including how to configure new components based on
existing settings for replaced components; validate this plan
* [ ] Migrate components and verify setup
