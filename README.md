# dotfiles

Personal configuration to be used on different devices. These are base settings
for various tools in my personal workflow. 

**ATTENTION: REWRITE UNDER WAY**

Currently I am working on a major re-write of my configuration and aim to move everything to
nix - nixos for my home machine and home-manager setup for the various work machines. Stay tuned for
a more comprehensive README once this work is stabilising.

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
