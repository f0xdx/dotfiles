{ config, pkgs, lib, ... }:
{

  # sway
  # TODO refactor this for flake setup: this is only relevant for the unix
  # machine with wayland/sway/pipewire

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        # height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "battery" "sway/language" "clock" ];

	"sway/window" = {
          max-length = 50;
	};
    
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

	"clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "network" = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{essid} ({ifname} via {gwaddr}) ";
          format-linked = "{ifname} ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{essid} {ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = " {volume}% {icon} {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
	        # TODO pavucontrol doesn't exist - alacritty + some TUI for wireplumber/pipewire?
          on-click = "pavucontrol";
        };
      };
    };

    # style = ''
    #   * {
    #     border: none;
    #     border-radius: 0;
    #   }
    #   window#waybar {
    #     background: rgba(43, 48, 59, 0.7);
    #   }
    # '';
  };

  # kanshi
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
          }
        ];
      };
      single_l = {
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
      single_r = {
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
      double = {
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
    };
  };

  # wofi application launcher
  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      matching = "fuzzy";
      height = "38%";
      width = "62%";
      location = "center";
    };
    style = builtins.readFile ./cfg/wofi/style.css;
  };

  # enable sway window manager
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # TODO include mako
    systemdIntegration = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = rec {
      startup = [
        # { command = "dbus-sway-environment"; } # this fails currently, not sure why
        # TODO kanshi doesn seem to be picked up, why?
        { command = "configure-gtk"; }
        { command = "sleep 3; systemctl --user start kanshi.service"; }
      ];
      modifier = "Mod4";
      terminal = "alacritty";
      input = {
        "*" = {
          xkb_layout = "de,us";
          xkb_variant = ",intl";
          xkb_options = "grp:win_space_toggle,eurosign:e";	
        };
        "type:touchpad" = {
          tap = "enabled";
	        natural_scroll = "disabled";
          scroll_method = "two_finger";
          pointer_accel = "0.4";
        };
      };
      bars = [
        {
          command = "\${pkgs.waybar}/bin/waybar";
        }
      ];

      menu = "wofi";

      keybindings = 
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "XF86MonBrightnessUp" = "exec 'brightnessctl set -e +5%'";
          "XF86MonBrightnessDown" = "exec 'brightnessctl set -e 5%-'";

          "XF86AudioRaiseVolume" = "exec 'wpctl set-volume @DEFAULT_SINK@ 5%+'";
          "XF86AudioLowerVolume" = "exec 'wpctl set-volume @DEFAULT_SINK@ 5%-'";
          "XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_SINK@ toggle'";
        };
      keycodebindings = lib.mkOptionDefault {
         "93" = "exec 'swaymsg input type:touchpad events toggle enabled disabled'";
      };
    };
  };

  services.mpris-proxy.enable = true;

  # for reading raw config files use this trick:
  # xdg.configFile.nvim = {
  #   source = ./cfg;
  #   recursive = true;
  # };
}
