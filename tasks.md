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

* [x] Create `home/ops/default.nix` with `ops.enable` option
* [x] Move `kubectl`, `auth0-cli`, `google-cloud-sdk` (with GKE plugin), and `k` alias into
      the module
* [x] Move `USE_GKE_GCLOUD_AUTH_PLUGIN` from `bash.initExtra` to `home.sessionVariables`
* [x] Move kubectl bash completion from `bash.initExtra` into the module
* [x] Enable `ops.enable = true` by default in `home/default.nix`; import the module there
* [x] Remove all migrated items from `home/shell/default.nix`


## Ollama Module

Goal: Extract ollama configuration from `editor/zed` into a standalone
`home/ai/ollama` module that can be independently enabled and accelerated per host.

* [x] Create `home/ai/ollama/default.nix` with:
  * [x] `modules.ollama.enable` option
* [x] Move `services.ollama` configuration from `hosts/buildr/home.nix` into the module;
      set `modules.ollama.enable = true`; set nixpkgs.config.cudaSupport in buildr's `home.nix`
* [x] Import the new module in `home/default.nix` (disabled by default)

## Zed Module with Ollama Integration

Goal: Factor the Zed editor into a configurable module with optional ollama-backed inline
edit predictions.

* [x] Add `modules.zed.enable` option and wrap the existing config in `lib.mkIf config.modules.zed.enable`
* [x] Add `modules.zed.ollamaIntegration.enable` sub-option (default `false`)
* [x] When `modules.zed.ollamaIntegration.enable = true`, configure Zed's inline AI / edit
      predictions to use the local ollama endpoint; derive the model from `ollama` module
      settings if available
* [x] Emit a module warning if `modules.zed.ollamaIntegration.enable = true` but `ollama.enable =
      false`
* [x] Enable `modules.zed.enable = true` by default in `home/default.nix`

## Hyprland Ecosystem Migration (2026-03-20)

Goal: migrate tools used in the desktop config to the [hyprland
ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/), where tools exist. Avoid QT
usage where possible.

* [ ] Analzye the current setup and list all desktop components being used
* [ ] Identify which components could be replaced by hyprland ecosystem components
* [ ] Build a migration plan, including how to configure new components based on
existing settings for replaced components; validate this plan
* [ ] Migrate components and verify setup

## Emacs Module (2026-07-29)

Goal: Add a modern, XDG-compliant, cross-platform Emacs configuration module with native compilation, demand-driven server startup via `emacsclient`, and local development guidelines.

* [x] Create `home/editor/emacs/cfg/init.el` and modular Elisp configs under `home/editor/emacs/cfg/lisp/`
* [x] Create `home/editor/emacs/default.nix` with `modules.emacs.enable` option and OS-specific package selection (`emacs30-pgtk` on Linux, `emacs30` on macOS)
* [x] Set `ALTERNATE_EDITOR=""`, `EDITOR`, `VISUAL`, and `ex`/`et` shell aliases
* [x] Import `./editor/emacs` in `home/default.nix` and enable it by default
* [x] Create `home/editor/emacs/README.md` documenting layout, manual server management, and local dev/test workflow

## Preferred Editor Selection (2026-07-29)

Goal: Resolve `EDITOR` / `VISUAL` sessionVariable definition conflicts between editor modules by introducing a centralized `modules.editor.default` option.

* [x] Create `home/editor/default.nix` with `modules.editor.default` option and mapping logic
* [x] Add `modules.nvim.enable` option to `home/editor/nvim/default.nix` and remove hardcoded `sessionVariables`
* [x] Remove hardcoded `sessionVariables` from `home/editor/emacs/default.nix`
* [x] Update `home/default.nix` to import `./editor` and set default editor preference
* [x] Verify configuration evaluation with `nix flake check`

## macOS Ghostty Support (2026-08-06)

Goal: Enable Ghostty configuration management on macOS via Home Manager without compiling `pkgs.ghostty` on Darwin.

* [x] Update `home/terminal/ghostty/default.nix` to set `programs.ghostty.package = null` and `installBatSyntax = false` on Darwin
* [x] Set `modules.ghostty.enable = true;` in `hosts/PC90221/home.nix`
* [x] Add manual application installation note to `README.md`
* [x] Validate configuration evaluation with `nix flake check`



