---
name: list-keybinds
description: Synchronize application keybindings via codebase discovery.
---

# List Keybinds

## Workflow

1. search for binding patterns (e.g., `bind`, `keymap`, `shortcut`) to find active config files
1. parse files for key sequences and actions, grouping by application and category
1. normalize split terminology ("Side-by-side", "Top-bottom") per [conventions.md](references/conventions.md)
1. update `keybinds.md` using [keybinds-template.md](assets/keybinds-template.md)

## Guidelines

* discover config files dynamically by searching for binding patterns — never hardcode paths that may change
* document the Leader/Prefix/Modifier key for each application at the top of its section
* when the same keybinding is defined in multiple places, document the version that takes effect last (wins)

## Resources

* [conventions.md](references/conventions.md): Terminology and table standards
* [keybinds-template.md](assets/keybinds-template.md): Reference file structure
