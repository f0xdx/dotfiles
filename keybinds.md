# Keybinds Reference

This document provides a quick reference for keybindings used in various applications within this dotfiles repository.

## Table of Contents

* [Hyprland (Window Manager)](#hyprland-window-manager)
* [Neovim (Editor)](#neovim-editor)
* [Zed (Editor)](#zed-editor)
* [Ghostty (Terminal)](#ghostty-terminal)
* [tmux (Terminal Multiplexer)](#tmux-terminal-multiplexer)
* [Bash / Shell](#bash--shell)

---

## Hyprland (Window Manager)

The main modifier key (`$mod` / `$mainMod`) is **SUPER** (Windows key).

### General

| Keybinding | Action |
| :--- | :--- |
| `$mod + T` | Open Terminal (Alacritty) |
| `$mod + Space` / `$mod + R` | Open Menu (Wofi) |
| `$mod + E` | Open File Manager |
| `$mod + Q` | Exit / Power Menu (Wlogout) |
| `$mod + C` / `$mod + W` | Kill active window |
| `$mod + M` | Exit Hyprland |
| `$mod + V` | Toggle floating |
| `$mod + P` | Pseudo-tiling (Dwindle) |
| `$mod + J` | Toggle split (Dwindle) |
| `$mod + Ctrl + L` | Lock screen |

### Window Management

| Keybinding | Action |
| :--- | :--- |
| `$mod + Arrows` | Move focus |
| `$mod + Shift + Arrows` | Move window |
| `$mod + Alt + Arrows` | Resize active window |
| `$mod + Tab` | Cycle to next visible window |
| `$mod + Shift + Tab` | Cycle to previous visible window |
| `$mod + LMB (Drag)` | Move window |
| `$mod + RMB (Drag)` | Resize window |

### Workspaces

| Keybinding | Action |
| :--- | :--- |
| `$mod + [0-9]` | Switch to workspace 1-10 |
| `$mod + Shift + [0-9]` | Move window to workspace 1-10 |
| `$mod + S` | Toggle special workspace (scratchpad) |
| `$mod + Shift + S` | Move window to special workspace |
| `$mod + Scroll` | Cycle through workspaces |

### Multimedia

| Keybinding | Action |
| :--- | :--- |
| `AudioRaiseVolume` | Increase volume (5%) |
| `AudioLowerVolume` | Decrease volume (5%) |
| `AudioMute` | Toggle mute audio |
| `AudioMicMute` | Toggle mute microphone |
| `MonBrightnessUp` | Increase brightness (10%) |
| `MonBrightnessDown` | Decrease brightness (10%) |
| `AudioNext` | Next track (Playerctl) |
| `AudioPrev` | Previous track (Playerctl) |
| `AudioPlay` / `Pause` | Play/Pause (Playerctl) |

---

## Neovim (Editor)

The leader key is **Space**.

### Core Navigation (Normal Mode)

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + h/j/k/l` | Navigate windows |
| `Ctrl + w + Ctrl + h/j/k/l` | Resize windows |
| `Ctrl + w + Ctrl + .` | Vertical split (Side-by-side) |
| `Ctrl + w + Ctrl + ,` | Horizontal split (Top-bottom) |
| `Shift + h/l` | Previous / Next buffer |
| `Esc Esc` | Clear search highlights |
| `[q / ]q` | Previous / Next Quickfix item |
| `[l / ]l` | Previous / Next Location List item |
| `Ctrl + d/u` | Scroll Down / Up (centered) |

### Insert Mode

| Keybinding | Action |
| :--- | :--- |
| `jk` | Exit Insert mode |
| `Ctrl + Space` | Trigger completion |

### Visual Mode

| Keybinding | Action |
| :--- | :--- |
| `< / >` | Indent / Outdent (stay in visual mode) |
| `Alt + j/k` | Move selected lines down/up |
| `p` | Paste without losing register content |
| `jk` | Exit Visual mode |

### Telescope (Fuzzy Finder)

| Keybinding | Action |
| :--- | :--- |
| `<leader>ff` | Find Files |
| `<leader>fp` | Find Git Files |
| `<leader>fg` | Live Grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help Tags |
| `<leader>fm` | Marks |
| `<leader>fq` | Quickfix |
| `<leader>fd` | File Browser |
| `<leader>u` | Undo History |

### LSP (Language Server Protocol)

| Keybinding | Action |
| :--- | :--- |
| `gd` | Go to Definition |
| `gD` | Go to Declaration |
| `gt` | Go to Type Definition |
| `gr` | Show References |
| `gi` | Show Implementations |
| `gc` / `gC` | Incoming / Outgoing Calls |
| `<leader>h` | Toggle Inlay Hints |
| `<leader>k` | Signature Help |
| `<leader>s` | Document Symbols |
| `<leader>xr` | Rename |
| `<leader>xa` | Code Action |
| `<leader>xf` | Format Document |
| `<leader>df` | Open Diagnostic Float |
| `<leader>dd` | Set Diagnostic Quickfix List |
| `<leader>db` | Set Diagnostic Location List |

### LLM

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + y` | Accept suggestion |
| `Ctrl + e` | Dismiss suggestion |

---

## Zed (Editor)

Zed is configured with **Vim mode** and **VSCode** base keymap.

### Custom Bindings

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + h/j/k/l` | Navigate panes |
| `Ctrl + w %` | Vertical split (Side-by-side) |
| `Ctrl + w "` | Horizontal split (Top-bottom) |
| `Space f f` | Toggle File Finder |
| `Space f t` | Toggle Tab Switcher |
| `Space f c` | Toggle Command Palette |
| `Space f g` | Deploy Search |

---

## Ghostty (Terminal)

Ghostty uses `Ctrl + g` as a prefix for many custom actions.

### Split Management

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + g > h/j/k/l` | Navigate splits |
| `Ctrl + g > Ctrl + h/j/k/l` | Resize splits |
| `Ctrl + g > Ctrl + .` | New split to the right (Side-by-side) |
| `Ctrl + g > Ctrl + ,` | New split below (Top-bottom) |
| `Ctrl + g > [` / `]` | Previous / Next split |
| `Ctrl + g > Enter` | Toggle split zoom |

### Tab & Window Management

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + g > t` | New tab |
| `Ctrl + g > w` | New window |
| `Ctrl + g > q` | Close surface |
| `Ctrl + g > Tab / Shift+Tab` | Next / Previous tab |
| `Alt + [1-9]` | Go to tab 1-9 |
| `Ctrl + PageUp / PageDown` | Previous / Next tab |

### Other

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + g > p` | Toggle Command Palette |
| `Ctrl + g > Ctrl + +/-` | Increase / Decrease font size |
| `Ctrl + Shift + c / v` | Copy / Paste |
| `Ctrl + Shift + f` | Start search |
| `Shift + PageUp / PageDown` | Scroll page up / down |

---

## tmux (Terminal Multiplexer)

The default prefix (leader) key is **Ctrl + b**.

### Direct Actions (No Leader Required)

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + .` | Split window top-bottom (tmux vertical split) |
| `Ctrl + ,` | Split window side-by-side (tmux horizontal split) |

### Leader-Required Actions

Prefix command with `Ctrl + b`.

| Keybinding | Action |
| :--- | :--- |
| `Leader + Ctrl + h/j/k/l` | Resize pane (Left/Down/Up/Right) |
| `Leader + c` | New window (current path) |
| `Leader + b` | Toggle status bar visibility |

---

## Bash / Shell

### Readline (Command Line Editing)

Readline is set to **vi** editing mode.

| Keybinding | Action |
| :--- | :--- |
| `Tab` | Menu complete |
| `Shift + Tab` | Menu complete backward |
| `Up / Down` | History search backward / forward |

### fzf (Fuzzy Finder)

| Keybinding | Action |
| :--- | :--- |
| `Ctrl + t` | Find files |
| `Alt + c` | Change directory |
| `Ctrl + r` | Search command history |

### Aliases

| Alias | Command |
| :--- | :--- |
| `lsx` | eza tree (level 1) with icons |
| `k` | kubectl |
| `y` | yazi (terminal file manager) |
| `lg` | git log (graph, oneline) |
| `st` | git status -s |
| `co` | git checkout |
