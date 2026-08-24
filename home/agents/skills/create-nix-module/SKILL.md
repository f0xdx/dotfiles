---
name: create-nix-module
description:
  Create new Nix modules in the dotfiles repository. Use when asked to add new
  functionality or system configuration that should be managed via Nix or
  Homemanager.
---

# Create Nix Module

## When to use

* when asked to add a new Nix module for a tool or service
* when organizing system or home configurations into modular components
* before manually creating a Nix file to ensure consistency with repo patterns

## Workflow

1.  **Analyze Requirements**: Identify the tool/service, its configuration
    needs, and whether it applies to Darwin, Linux, or both.
2.  **Dependency Audit**: Check if the tool requires a new flake input. Apply
    the "Deep Follows" pattern for nested dependencies to ensure nixpkgs
    consistency.
3.  **Determine Location**:
    *   `home/`: User-level (Home Manager) configurations.
    *   `system/`: System-level (NixOS/nix-darwin) configurations.
4.  **Create Directory**: Create a new directory for the module if it's
    complex, or just a `default.nix` for simple cases.
5.  **Populate with Template**: Use the `module-template.nix` asset as a base.
6.  **Define Options**: Use `lib.mkEnableOption` to allow the user to toggle
    the module.
7.  **Implement Logic**:
    *   Use `lib.mkIf` to apply configuration conditionally.
    *   **Bundle Enhancements**: Include shell completions
        and helper functions (e.g., fzf pickers) within the same activation
        block as the main tool.
    *   Use `pkgs.stdenv.hostPlatform.isDarwin` and `pkgs.stdenv.hostPlatform.isLinux` for system-specific
        logic.
8.  **Register Module**: Add the new module to the appropriate `default.nix`
    (e.g., `home/default.nix` or `system/default.nix`) or include it in the
    host configuration.

## Requirements

*   **Consistency**: Always use the `{ config, pkgs, lib, ... }` pattern.
*   **Modularity**: Each tool/service should have its own toggleable option.
*   **System Awareness**: Explicitly handle OS differences if the tool behaves
    differently on macOS vs Linux, requires different configuration or does not
    have a supported nix package.
*   **Idiomatic Nix Flake**: use idiomatic nix flake patterns
*   **No Workarounds**: Use existing nix home manager options where possible and
    avoid `xdg.configFile` unless absolutely necessary (e.g., Neovim setup).

## References

*   [Nix Conventions](references/nix-conventions.md): Detailed local patterns
    for options and OS checks.

## Assets

*   [Module Template](assets/module-template.nix): Standard boilerplate for new
    modules.
