# dotfiles

Personal configuration to be used on different devices. These are base settings
for various tools in my personal workflow. Feel free to use, adapt or laugh at
them. Most of their contents are not my own creative work, but stem from
various sources, in fact far to many for me to recall. All I can do to thank
those anonymous authors which have put time and effort into figuring out what
works and what doesn't, is to contribute my patchwork back to the community and
let you guys do the same. Enjoy :)


## Parameters

To figure out whether this repo is useful for you, I will first list some of my
base parameters. If you find yourself nodding at most of them, it might be
a fit. If not, maybe there are better config repos out there for you.

These are my basic parameters:

 * I work on different machines with different OS, mainly Windows 10 and Linux
   (Fedora, Ubuntu) ... sorry MacOS fanboys
 * I love Vim, in fact neovim, and modal editing but I hate controversy around
   editors; everybody should use what works for them
 * I love the fresh air that the rust language, community and ecosystem bring,
   you guys are great!
 * color schemes and themes do matter, one-dark all the way!

Tools supporting my daily work:

 * neovim and vscode
 * alacritty, zsh and powershell ... yep, it's way cooler than we linux nerds
   care to admit
 * fzf, ripgrep, bat and exa (maybe lsd or broot might replace exa in the not
   so far future)


## Requirements

TBD (nerdfonts, powershell, zsh installed, rustup installed)


## Installation

### Windows

This repo includes a simple powershell script that will install the settings on
your system. Note that Powershell controls script execution
[through execution policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
to prevent execution of scripts from dubious sources.

Therefore, you will have to either set the correct execution policy or sign the
script yourself. In order to execute the script once without permanently
changing any settings on your system, you can run the following snippet from an
elevated command line (admin):

```powershell
Set-ExecutionPolicy -Scope Process RemoteSigned; .\setup.ps1
```

## Future Work 

 * [ ] add script and installation instructions for linux
 * [ ] adapt scripts to prepare environment, point out missing programs
   initiate installs etc.
 * [ ] configure [Alacritty](https://github.com/jwilm/alacritty)
 * [ ] configure tmux / vim for tmux
 * [ ] configure zsh / oh-my-zsh and oh-my-posh