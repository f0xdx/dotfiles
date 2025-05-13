{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    waybar_support.enable =
      lib.mkEnableOption "Enables proprietary driver nvidia support.";
  };

  config = lib.mkIf config.waybar_support.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = ["custom/logo"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["clock"];

          "custom/logo" = {
            "format" = "";
            "on-click" = lib.mkIf config.programs.wlogout.enable "${pkgs.wlogout}/bin/wlogout";
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons =
              builtins.listToAttrs (builtins.genList (x: let
                  ws = x + 1;
                in {
                  name = "${toString ws}";
                  value = "";
                })
                3)
              // {
                "active" = "";
              };
            persistent-workspaces = {
              "*" = [1 2 3];
            };
          };

          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%R}";
            format-alt = "{:%FT:%T:%z}";
            interval = 1;
          };
        };
      };
    };
  };
}
