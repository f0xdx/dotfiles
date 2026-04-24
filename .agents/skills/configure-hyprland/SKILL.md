---
name: configure-hyprland
description:
  Audit, fix, and validate Hyprland configurations in a hybrid Nix/Home Manager
  environment. Use when identifying syntax errors, applying modern rules, or
  verifying configuration integrity.
---

# Configure Hyprland

## Workflow

1. consult [Hyprland Wiki](https://wiki.hyprland.org/) for modern syntax and dispatchers
1. identify legacy syntax and map to modern patterns using [syntax-patterns.md](references/syntax-patterns.md)
1. update `home/desktop/hyprland/default.nix` (Nix settings) or `cfg/hyprland.conf` (raw config)
1. run [validate-hypr-config.sh](assets/validate-hypr-config.sh) to assemble and headless-test the configuration
1. debug specific "Config error" output by searching [GitHub Discussions](https://github.com/hyprwm/Hyprland/discussions)

## Guidelines

* prefer the unified `windowrule` format with explicit `match:` prefixes over any legacy alternatives found in [syntax-patterns.md](references/syntax-patterns.md)
* use `snake_case` property names and explicit boolean values (`on`, `true`/`false`)
* maintain the hybrid strategy: Nix `settings` for globals/hardware, `extraConfig` for verbose or dynamic blocks
* always validate headlessly before applying to the active session — config errors in a live session require a restart

## Resources

* [syntax-patterns.md](references/syntax-patterns.md): Deprecation and modernization mappings.
* [validate-hypr-config.sh](assets/validate-hypr-config.sh): Headless validation tool.
