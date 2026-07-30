# Emacs Configuration Module

This module manages a modern, native-compiled, XDG-compliant Emacs
configuration across macOS and Linux platforms using Home Manager.

---

## Directory Layout & File Organization

The configuration source lives in `cfg/` and is deployed by Home
Manager to `~/.config/emacs/`:

```
home/editor/emacs/
├── default.nix       # Home Manager module & package definition
├── README.md         # Architecture, conventions, and development guide
└── cfg/
    ├── init.el       # Main entry point (XDG standard location)
```


## Server & Client Usage

Running an emacs server and starting only client sessions in the
existing server is recommended to speed up initial launch. Shell
aliases support this pattern.

### Shell Aliases

* `ex`: Opens a new standalone GUI window (`emacsclient -c -a ''`). If no server is running, it automatically starts `emacs --daemon` and connects.
* `et`: Opens a terminal frame within your active terminal (`emacsclient -t -a ''`). If no server is running, it automatically starts `emacs --daemon` and connects.


### Manual Server Management

* Start server explicitly in background:
  ```sh
  emacs --daemon
  ```
* Stop running Emacs server:
  ```sh
  emacsclient -e '(kill-emacs)'
  ```


## Local Development & Testing Workflow

During active development, you can test and iterate on `.el`
configuration files directly from your repository working directory
without running `home-manager switch`.

### Isolated Testing (Without System Symlinks)

To test changes in an isolated Emacs process reading directly from
your local dotfiles checkout:

```sh
emacs --init-directory home/editor/emacs/cfg/
```

### Live Buffer Evaluation

While editing an `.el` file inside Emacs:

* Run `M-x eval-buffer` to evaluate the entire modified buffer live.
* Use `C-x C-e` (`eval-last-sexp`) to evaluate individual expressions.

### Hot-Reloading via `emacsclient`

To load updated Elisp files directly into an active background server
session without restarting:

```sh
emacsclient -e '(load-file "home/editor/emacs/cfg/init.el")'
```

Alternatively, use the built-in reload shortcut in Emacs:

* Press `C-c r` (bound to `reload-init-file`) to reload `init.el` and all `layers/*.el` modules.

## TODO Missing Features

Editor convenience

* kill current line
* comment out current line
* kill all in parenthesis
* insert line above (C-O) / below (C-o)