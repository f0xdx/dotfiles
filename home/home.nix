{ config, pkgs, lib, ... }:

let
  user = "f0xdx";
  home = "/home/${user}";
in
{
  imports =
    [ 
      ./alacritty
      ./neovim
      ./starship
    ];

  home = {
    # TODO refactor those to variables when moving to a flake - they may be different across machines
    username = user;
    homeDirectory = home;
    
    shellAliases = {
      lsx = "exa -T -L1 --color always --icons -s name --group-directories-first";
    };
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    delta
    jq
    openssh
    ripgrep
    fd
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # shell environment

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      # enableFlakes = true;
    };
  };

  programs.bash = {
    enable = true;

    historyControl = [ 
      "erasedups"
      "ignorespace"
      "ignoredups"
    ];
    historyIgnore = [
      "ls"
      "exit"
    ];

    shellOptions = [
      "extglob"
      "histappend"
    ];

    initExtra = ''
      _fzf_setup_completion path exa lsx bat nvim.sh
    '';

    # note: can also source complete files like this
    # initExtra = ''
    #   . ~/projects/dotfiles/bash/bashrc
    # '';
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\t" =   "menu-complete";
      "\\e[Z" = "menu-complete-backward";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      editing-mode = "vi";
      colored-completion-prefix =    true;
      colored-stats =                true;
      menu-complete-display-prefix = true;
      show-all-if-ambiguous =        true;
      completion-ignore-case =       true;
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    # configures alt-c command
    changeDirWidgetCommand = "fd --type d --hidden --color always --exclude .git";
    changeDirWidgetOptions = [
      # TODO $LINES arithmetic not working
      "--preview 'exa -T -L1 --color always --icons -s name --group-directories-first {} | sed \\\"$(( $LINES-1 ))s/.*/.../; $LINES,$ d\\\"'"
      "--ansi"
      "--height 40%"
    ];

    # configures default command
    defaultCommand = "fd --hidden --color always --exclude .git";
    defaultOptions =[
      "--ansi"
      "--height 40%"
    ];

    # configures ctrl-t command
    fileWidgetCommand = "fd --type f --hidden --color always --exclude .git";
    fileWidgetOptions = [
      "--ansi"
      "--preview 'bat --style=numbers,changes --color=always --line-range=:$LINES {}'"
      "--height 40%"
    ];

    historyWidgetOptions = [
      "--tac"
      "--height 40%"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.tmux = {
    enable = true;

    historyLimit = 10000;
    escapeTime = 12;
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    
    customPaneNavigationAndResize = true;
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      yank
      open
      sessionist
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

    ];

    extraConfig = ''
      
      # Set XTerm key bindings
      setw -g xterm-keys on
      
      # Set colors
      set -ga terminal-overrides ",xterm-256color:RGB"
      
      # Enable focus-events to enable vim to refresh accordingly.
      set-option -g focus-events on
      
      
      set -g mouse on
      
      # Resize the current pane using Alt + direction
      # those might not work on mac
      bind -n M-k resize-pane -U
      bind -n M-j resize-pane -D
      bind -n M-h resize-pane -L
      bind -n M-l resize-pane -R
      
      # Open new panes and windows in current directory.
      bind '|' split-window -h -c '#{pane_current_path}'
      bind '-' split-window -v -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      
      
      # Enable pbcopy/pbpaste in tmux.
      if-shell \
        'test "$(uname -s)" = Darwin && type reattach-to-user-namespace > /dev/null' \
      'set-option -g default-command "exec reattach-to-user-namespace -l zsh"'
      
      # status bar
      set-option -g status-position bottom
      bind b set-option -g status

      # status line style
      set-option -g status-left "#{session_name}   "
      #set-option -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %d-%b-%y"
      set-option -g status-right "{} #{=21:pane_title} %H:%M"
      set-option -g window-status-format "#W"
      set-option -g window-status-current-format "#W"
      
      #set-window-option -g window-status-current-style bg=yellow,fg=black
    '';
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;

    # this seems to not yet be in stable
    # icons = true;
    # git = true;
    # extraOptions = [
    #   "--group-directories-first"
    # ];
  };

  # dev tools

  programs.git = {
    # TODO switch on ssh key
    # TODO use ssh key for signing commits
    enable = true;
    userEmail = "fheinrichs@heinrichs.it";
    userName = "Dr. Felix Heinrichs";

    signing = {
      key = "${home}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    aliases = {
      lg = "log --graph --oneline --decorate";
      st = "status -s";
      co = "checkout";
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      push = {
        default = "current";
      };
      pull = {
        rebase = true;
      };
      fetch = {
        prune = true;
	pruneTags = true;
      };
      init = {
        defaultbranch = "main";
      };
      gpg = {
        format = "ssh";
      };
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
	side-by-side = true;
	navigate = true;
	# features = "GitHub";
      };
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
    };
  };


  # firefox

  home.sessionVariables = {
    # TODO refactor so that firefox only sets those relevant for firefox
    # those are firefox specific

    MOZ_ENABLE_WAYLAND = 1;
    MOZ_USE_XINPUT2 = "1";
    
    # those are sway specific
    XDG_CURRENT_DESKTOP = "sway"; 
    # to make sway play with nvidia after suspend
    # WLR_NO_HARDWARE_CURSORS = "1";

    # those are generic session variables

    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };


  # sway
  # TODO refactor this for flake setup: this is only relevant for the unix machine with wayland/sway/pipewire

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

  # enable sway window manager
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # TODO include mako
    # TODO use kanshi instead ?
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
        { command = "configure-gtk"; }
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
}
