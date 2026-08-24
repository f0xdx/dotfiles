# Nix Conventions

In this repository, Nix modules follow specific patterns to ensure consistency
and modularity across both Darwin (macOS) and Linux systems.

## Options and Toggles

Always use `lib.mkEnableOption` to provide a clear way for the user to enable or
disable the module.

```nix
options = {
  user_options.<module_name> = {
    enable = lib.mkEnableOption "Enables <module_name> configuration.";
  };
};
```

## Conditional Configuration

Use `lib.mkIf` to apply configuration only when the module is enabled.

```nix
config = lib.mkIf cfg.enable {
  # ...
};
```

## OS Specificity

Use `pkgs.stdenv.hostPlatform.isDarwin` and `pkgs.stdenv.hostPlatform.isLinux` to handle system differences.

```nix
# In config section
(lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  # Darwin-specific options
})

(lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  # Linux-specific options
})
```

## Avoid xdg.configFile for General Use

The `xdg.configFile` approach is primarily used as a workaround (e.g., for
Neovim) and should not be used for general module configuration. Use
module-specific options where possible.
