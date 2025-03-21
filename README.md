# dotfiles

Personal configuration to be used on different devices. These are base settings
for various tools in my personal workflow. Configuration is rolled out through
[nix home manager](https://github.com/nix-community/home-manager) and managed in
a nix flake.

Currently, this supports the nixos config of my personal machine (buildr),
buildrs home files for my user and my user on the work machine. Others may be
added in the future.


## Overview

The core toolchain is

* [alacritty](https://alacritty.org/) as terminal emulator
* [neovim](https://neovim.io/) as CLI editor and [zed](https://zed.dev/) as IDE
* [eza](https://eza.rocks/), [bat](https://github.com/sharkdp/bat),
  [zoxide](https://github.com/ajeetdsouza/zoxide) and of course 
  [fzf](https://github.com/junegunn/fzf) for a fast and modern CLI experience
* various small utilities tailored to a mostly CLI based workflow with some
  graphical tools where it makes sense

Other tools will be added as needed over time. For the nixos config, those are
run on a full wayland based custom desktop using pipewire which prioritises
speed and utility over completeness and design.


## How to apply

In order to update the dependencies run

```sh
nix flake update
```

For system update then run

```sh
sudo nixos-rebuild switch --flake .#
```

For home manager setup run

```sh
home-manager switch --flake .#f0xdx
```


## Desktop Guide

This section will over time be completed by explaining how to

* manage WIFIs
* manage bluetooth devices
* manage additional screens and peripherals
* setup screen recordings, screenshots and video calls

