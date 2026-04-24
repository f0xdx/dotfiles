---
name: update-readme
description: Audit and update the project README.md for accuracy, structure, and link integrity while enforcing specific formatting constraints.
---

# Update README

## Workflow

1. Verify Context: Confirm project state (hosts, OS, tools) and consult [conventions.md](references/conventions.md).
2. Audit Structure: Verify all required sections defined in [conventions.md](references/conventions.md) are present and ordered correctly.
3. Validate Links: Check all tool URLs and relative file links (e.g., `keybindings.md`).
4. Apply Constraints: Remove leading bold face from lists; use `*` or `1.` markers; use `> [!NOTE]` for warnings.
5. Setup Guide: Ensure `nix flake update` and switch commands are accurate.

## Guidelines

* Use descriptive phrasing: `[Tool](url) handles X` instead of `**Tool**: X`.
* Use exact tool names and commands as they appear in the flake configuration — read the source rather than guessing.
* Omit hardware specs and external contribution guides.

## Resources

* [conventions.md](references/conventions.md): Formatting rules and required content.
