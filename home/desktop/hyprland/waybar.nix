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
          modules-right = ["group/hardware" "hyprland/language" "clock"];

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

          "group/hardware" = {
            orientation = "horizontal";
            modules = [
              "bluetooth"
              "pulseaudio"
              "network"
              "battery"
            ];
          };

          "bluetooth" = {
            format-on = "";
            format-off = "";
            format-disabled = "󰂲";
            format-connected = "󰂴";
            format-connected-battery = "{device_battery_percentage}% 󰂴";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            on-click = "notify-send 'bzmenu not installed, use bluetoothctl'";
          };

          "network" = {
            format-wifi = " ";
            format-ethernet = " ";
            format-disconnected = "";
            tooltip-format = "{ipaddr}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)  | {ipaddr}";
            tooltip-format-ethernet = "{ifname}  | {ipaddr}";
            on-click = "notify-send 'iwmenu not installed, use nmcli'";
          };

          "battery" = {
            interval = 1;
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{capacity}%  {icon} ";
            format-charging = "{capacity}% 󰂄 ";
            format-plugged = "{capacity}% 󰂄 ";
            format-alt = "{time} {icon}";
            format-icons = [
              "󰁻"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰂂"
              "󰁹"
            ];
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-bluetooth = "󰂰";
            format-muted = "<span font='12'></span>";
            format-icons = {
              headphones = "";
              bluetooth = "󰥰";
              handsfree = "";
              headset = "󱡬";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            justify = "center";
            on-click = "notify-send 'pavucontrol not installed, use wireplumber'";
            tooltip-format = "{icon}  {volume}%";
          };
        };
      };
    };
  };
}
