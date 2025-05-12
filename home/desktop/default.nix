{ config, pkgs, lib, ... }:
let
  bg_color = "#0000009e";
  border_color = "#595959aa";
  highlight_color = "#00ff99ee";
in {

  programs.waybar = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };


  # wofi: application launcher

  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      matching = "fuzzy";
      height = "38%";
      width = "62%";
      location = "center";
      allow_images = true;
    };
    style = builtins.readFile ./cfg/wofi/style.css;
  };


  # mako: notifications

  services.mako = {
    enable = true;
    criteria = {
      "urgency=high" = {
        border-color = highlight_color;
      };
    };
    settings = {
      actions = "true";
      anchor = "top-right";
      background-color = bg_color;
      border-color = border_color;
      border-radius = 10;
      default-timeout = 5000;
      height = 100;
      icons = true;
      layer = "top";
      markup = true;
      width = 300;
    };
  };


  # kanshi: automatic setup of multiple displays

  services.kanshi = {
    enable = true;

    settings = [
      { 
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
            }
          ];
        };
      }
      {
        profile = {
          name = "single_l";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "HDMI-A-2 'BNQ BenQ GW2470 86G02271019'";
              mode = "1920x1080@60Hz";
              position = "1920,0";
            }
          ];
        };
      }
      {
        profile = {
          name = "single_r";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "DP-2 'BNQ BenQ GW2470 JBF03525SL0'";
              mode = "1920x1080@60Hz";
              position = "1920,0";
            }
          ];
        };
      }
      {
        profile = {
          name = "double";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "HDMI-A-2 'BNQ BenQ GW2470 86G02271019'";
              mode = "1920x1080@60Hz";
              position = "1920,0";
            }
            {
              criteria = "DP-2 'BNQ BenQ GW2470 JBF03525SL0'";
              mode = "1920x1080@60Hz";
              position = "3840,0";
            }
          ];
        };
      }
    ];
  };


  # hypridle

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid multiple instances
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 150;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
          on-resume = "notify-send -u critical \"Welcome back, \${USER}!\"";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
      ];
    };
  };

  # enable sway window manager
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./cfg/hyprland.conf;
    settings = {
      "$mod" = "SUPER";

      # See https://wiki.hyprland.org/Configuring/Keywords/
      "$terminal" = "alacritty";
      "$menu" = "wofi";
      "$lock" = "loginctl lock-session";

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor= ",preferred, auto, 1";

      bind = [
        "$mod, T, exec, $terminal"
        "$mod, Q, exit,"
        "$mod, space, exec, $menu"
      ];

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "de,us";
        kb_variant = ",intl";
        kb_options = "grp:alt_altgr_toggle,eurosign:e,ctrl:nocaps";

        follow_mouse = 1;
        sensitivity = 0.4; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;
        };
      };
    };
  };

  services.mpris-proxy.enable = true;


  # gtk theme support

  gtk = {
    enable = true;
    iconTheme = {
      name = "Qogir-Manjaro-Dark";
      package = pkgs.qogir-icon-theme;
    };
    theme = {
      name = "Qogir-Dark";
      package = pkgs.qogir-theme;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };


  # additional packages
  home.packages = with pkgs; [
    dconf
    qogir-theme
    qogir-icon-theme
    hyprpicker
  ];
}
