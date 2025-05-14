{
  pkgs,
  lib,
  config,
  ...
}: let
  kb_name = "at-translated-set-2-keyboard";
in {
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
          modules-right = ["hyprland/language" "clock"];

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
                9)
              // {
                "active" = "";
              };
            persistent-workspaces = {
              "*" = [1 2 3];
            };
          };

          # NOTE this is currently not properly displaying the us variant
          "hyprland/language" = {
            format = "{short}";
            on-click = "hyprctl switchxkblayout ${kb_name} next";
            keyboard-name = kb_name;
          };

          "clock" = {
            tooltip-format = "<big>{:%FT:%T:%z}</big>\n\n<tt><small>{calendar}</small></tt>";
            format = "{:%R}";
            interval = 1;
            today-format = "<span id=\"today\"><b>{}</b></span>";
            calendar-week-pos = "right";
            on-click = "date +'%FT%T%z' | wl-copy";
          };
        };
      };
    };
  };
}
