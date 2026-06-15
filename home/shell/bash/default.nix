{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.bash.utilities;
  binDir = ./bin;
in {
  options.bash.utilities = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enables custom bash utility scripts in ~/.local/bin.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/bin/lib".source = ./bin/lib;
    } // lib.mapAttrs' (name: value: {
      name = ".local/bin/${name}";
      value = {
        source = ./bin + "/${name}";
        executable = true;
      };
    }) (lib.filterAttrs (name: type: type == "regular") (builtins.readDir binDir));

    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
