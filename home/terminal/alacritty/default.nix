{
  config,
  pkgs,
  lib,
  theme,
  ...
}: {
  options = {
    alacritty_support.enable =
      lib.mkEnableOption "Enables the alacritty terminal emulator.";
  };

  config = lib.mkIf config.alacritty_support.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          import = [
            "${config.xdg.configHome}/alacritty/themes/${builtins.replaceStrings ["-"] ["_"] theme}.toml"
          ];
        };

        window = {
          startup_mode = "Maximized";
        };

        font = {
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "FiraCode Nerd Font";
            style = "Bold";
          };
          size = 14;
        };
      };
    };

    xdg.configFile.alacritty = {
      source = ./cfg;
      recursive = true;
    };
  };
}
