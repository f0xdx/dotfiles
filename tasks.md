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

## Hyprland Ecosystem Migration (2026-03-20)

Goal: migrate tools used in the desktop config to the [hyprland
ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/), where tools exist. Avoid QT
usage where possible.

* [ ] Analzye the current setup and list all desktop components being used
* [ ] Identify which components could be replaced by hyprland ecosystem components
* [ ] Build a migration plan, including how to configure new components based on
existing settings for replaced components; validate this plan
* [ ] Migrate components and verify setup
