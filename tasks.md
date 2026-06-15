# Tasks

This file tracks the upcoming tasks, ideas, and planned improvements for the dotfiles project.

## Extension points (2025-05-26)

* [ ] automatic brightness control on wayland with [wluma](https://github.com/maximbaz/wluma)
* [ ] tiling window manager on mac osx with [aerospace](https://github.com/nikitabobko/AeroSpace)

## Hyprland Configuration (2025-05-26)

* [ ] waybar setup
  * [ ] use wireplumber instead of pulse audio module in waybar
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


## Ollama Module

Goal: Extract ollama configuration from `editor/zed` into a standalone
`home/services/ollama` module that can be independently enabled and accelerated per host.

* [ ] Create `home/services/ollama/default.nix` with:
  * [ ] `modules.ollama.enable` option
* [ ] Move `services.ollama` configuration from `hosts/buildr/home.nix` into the module;
      set `modules.ollama.enable = true`; set nixpkgs.config.cudaSupport in buildr's `home.nix`
* [ ] Import the new module in `home/default.nix` (disabled by default)

## Zed Module with Ollama Integration

Goal: Factor the Zed editor into a configurable module with optional ollama-backed inline
edit predictions.

* [ ] Add `modules.zed.enable` option and wrap the existing config in `lib.mkIf config.modules.zed.enable`
* [ ] Add `modules.zed.ollamaIntegration.enable` sub-option (default `false`)
* [ ] When `modules.zed.ollamaIntegration.enable = true`, configure Zed's inline AI / edit
      predictions to use the local ollama endpoint; derive the model from `ollama` module
      settings if available
* [ ] Emit a module warning if `modules.zed.ollamaIntegration.enable = true` but `ollama.enable =
      false`
* [ ] Enable `modules.zed.enable = true` by default in `home/default.nix`

## Hyprland Ecosystem Migration (2026-03-20)

Goal: migrate tools used in the desktop config to the [hyprland
ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/), where tools exist. Avoid QT
usage where possible.

* [ ] Analzye the current setup and list all desktop components being used
* [ ] Identify which components could be replaced by hyprland ecosystem components
* [ ] Build a migration plan, including how to configure new components based on
existing settings for replaced components; validate this plan
* [ ] Migrate components and verify setup
