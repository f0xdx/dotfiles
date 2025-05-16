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
    home.packages = with pkgs; [
      bottom
    ];

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      style = builtins.readFile ./cfg/waybar/style.css;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = ["custom/logo"];
          modules-center = ["hyprland/workspaces"];
          modules-right = [
            "group/hardware"
            "group/system"
            "hyprland/language"
            "clock"
          ];

          "custom/logo" = {
            format = " ";
            on-click = lib.mkIf config.programs.wlogout.enable "${pkgs.wlogout}/bin/wlogout";
            tooltip = false;
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
            format-on = "󰂯";
            format-off = "";
            format-disabled = "󰂲";
            format-connected = "󰂱";
            format-connected-battery = "󰂱";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t󰥈 {device_battery_percentage}%";
            on-click = "hyprctl keyword exec '$terminal -e bluetoothctl'";
          };

          "network" = {
            format-wifi = " ";
            format-ethernet = " ";
            format-disconnected = "";
            tooltip-format = "{ipaddr}";
            tooltip-format-wifi = "{essid} |   {signalStrength} %";
            tooltip-format-ethernet = "{ifname}   {ipaddr}";
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
            format-plugged = "{capacity}% ";
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
            format = "{icon}";
            format-bluetooth = "󰂰 {icon}";
            format-bluetooth-muted = "󰂰 {icon}";
            format-muted = "";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              headphone-muted = "󰟎";
              hands-free = "";
              hands-free-muted = "󰟎";
              headset = "";
              headset-muted = "󰟎";
              phone = "";
              phone-muted = "";
              portable = "";
              portable-muted = "";
              car = "";
              car-muted = "󰸜";
              default = ["" "" ""];
            };
            justify = "center";
            on-click = "notify-send 'pavucontrol not installed, use wireplumber'";
            tooltip-format = "{icon}  {volume}%";
          };

          "group/system" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 300;
              children-class = "system-child";
              transition-left-to-right = false;
            };
            modules = [
              "custom/system"
              "cpu"
              "memory"
              "disk"
              "temperature"
            ];
          };

          "custom/system" = {
            format = " ";
            on-click = "hyprctl keyword exec '$terminal -e ${pkgs.bottom}/bin/btm'";
            tooltip = false;
          };

          "cpu" = {
            interval = 1;
            format = "󰻠 {usage}%";
            format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };

          "memory" = {
            format = " {percentage}%";
          };

          "disk" = {
            interval = 30;
            format = " {percentage_used}%";
            path = "/";
          };

          "temperature" = {
            format = " {temperatureC}°C";
            format-critical = " {temperatureC}°C";
            interval = 1;
            critical-threshold = 80;
          };
        };
      };
    };
  };
}
