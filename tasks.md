# Tasks

This file tracks the upcoming tasks, ideas, and planned improvements for the dotfiles project.

## Extension points

* [ ] automatic brightness control on wayland with [wluma](https://github.com/maximbaz/wluma)
* [ ] tiling window manager on mac osx with [aerospace](https://github.com/nikitabobko/AeroSpace)

## Hyprland Configuration

* [ ] waybar setup
  * [ ] use wireplumber instead of pulse audio module in waybar
* [ ] switch to Brave browser
* [ ] theme wlgout
* [ ] switch to fuzzel launcher
* [ ] switch bluetooth config to [bzmenu](https://github.com/e-tho/bzmenu)
      (flake exists)
* [ ] switch wifi config to [iwmenu](https://github.com/e-tho/iwmenu)
      (flake exists) - this requires [iwd](https://nixos.wiki/wiki/Iwd), configured with network manager


## Hyprland Ecosystem Migration

Goal: migrate tools used in the desktop config to the [hyprland
ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/), where tools exist. Avoid QT
usage where possible.

* [ ] Analzye the current setup and list all desktop components being used
* [ ] Identify which components could be replaced by hyprland ecosystem components
* [ ] Build a migration plan, including how to configure new components based on
existing settings for replaced components; validate this plan
* [ ] Migrate components and verify setup

## Upstream Workarounds

* [ ] re-check whether the `bind -f "$INPUTRC"` workaround in
  [home/shell/default.nix](home/shell/default.nix) is still required after
  updating Bash or Home Manager (`nix flake update`): test with
  `env -u INPUTRC -u __HM_SESS_VARS_SOURCED bash --noprofile --norc -ic 'source ~/.profile; bind -q history-search-backward'`
  and check if `home-manager`'s `programs.readline` module handles Bash
  initialization when `home.preferXdgDirectories = true`

## State Version 26.11 Rollout

* [x] on `PC90221`, apply Home Manager `26.11` from [home/default.nix](home/default.nix)
  with `home-manager switch --flake .` and verify `~/Applications/Home Manager Apps/Firefox.app`
  opens the migrated profile in `~/Library/Application Support/org.nixos.firefox`
* [ ] on `PC90221`, remove backup `~/Library/Application Support/Firefox.bak-26.05`
  after confirming Firefox profile integrity
* [ ] on `buildr`, apply NixOS `26.11` from [hosts/buildr/configuration.nix](hosts/buildr/configuration.nix)
  (`sudo nixos-rebuild switch --flake .#`) and Home Manager `26.11`
  (`home-manager switch --flake .`)
* [ ] fix `allowUnfree` loss on `f0xdx@buildr`: setting `nixpkgs.config.cudaSupport = true`
  in [hosts/buildr/home.nix](hosts/buildr/home.nix) causes Home Manager to re-import
  `nixpkgs` without `allowUnfree = true` from [flake.nix](flake.nix), blocking evaluation
  of unfree packages such as `antigravity-cli` and `spotify`

