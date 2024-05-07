# dotfiles

This repository contains my personal dotfiles. Configuration is based on
[home manager]().

## Install

In order to install, backup your current configuration and run


```sh
git clone git@github.com:f0xdx/dotfiles.git
cd dotfiles
home-manager switch --flake hmconf/
```

> **NOTE** This is currently a work in progress. There is another branch that
> was an earlier attempt at moving to home manger (nix), which also supports a
> NixOS configuration. Stay tuned for further integration

## Future Work

* [ ] consolidate with nix branch to have a single flake
* [ ] add proper dev tooling support (git, gh, etc.)
* [ ] add shell completions back from earlier bash file
