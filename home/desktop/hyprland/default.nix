{
  config,
  pkgs,
  lib,
  ...
}: let
  bg_color = "#0000009e";
  border_color = "#595959aa";
  highlight_color = "#00ff99ee";
in {
  imports = [
    ./waybar.nix
  ];

  options = {
    hyprland_support.enable =
      lib.mkEnableOption "Enables a wayland desktop based on hyprland.";
  };

  config = lib.mkIf config.hyprland_support.enable {
    waybar_support.enable = lib.mkDefault true;

    home = {
      sessionVariables = {
        SDL_VIDEODRIVER = "wayland";
      };
    };

    # hyprlock: lock the screen

    programs.hyprlock = {
      enable = true;
    };

    # wlogout: waland compatible logout utility

    programs.wlogout = {
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
      settings = {
        "urgency=high" = {
          border-color = highlight_color;
        };
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

    # hypridle

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid multiple instances
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 60;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          # NOTE not supported on the current MSI WS65 as device will
          #      not be found; needs to be conditional on device
          # {
          #   timeout = 150;
          #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          #   on-resume = "brightnessctl -rd rgb:kbd_backlight";
          # }
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

    services.hyprpolkitagent = {
      enable = true;
    };

    # enable sway window manager
    wayland.windowManager.hyprland = {
      enable = true;

      systemd.variables = ["--all"];
      extraConfig = builtins.readFile ./cfg/hyprland.conf;
      settings = {
        "$mod" = "SUPER";

        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$terminal" = "alacritty";
        "$menu" = "wofi";
        "$lock" = "loginctl lock-session";
        "$exit" = "wlogout";

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = ",preferred, auto, 1";

        bind = [
          "$mod, T, exec, $terminal"
          # "$mod, Q, exit,"
          "$mod, Q, exec, $exit"
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

    # additional packages
    home.packages = with pkgs; [
      hyprpicker
    ];

    xdg.desktopEntries = {
      hyprpicker = {
        type = "Application";
        name = "Hyprpicker";
        genericName = "Colorpicker";
        exec = "${pkgs.hyprpicker}/bin/hyprpicker";
        terminal = false;
        icon = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}/32/actions/color-picker.svg";
        categories = ["Utility"];
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
