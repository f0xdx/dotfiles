{ pkgs, lib, config, ... }: {

  options = {
    desktop_support.enable =
      lib.mkEnableOption "Enables support for a wayland based desktop environment.";
  };

  config = lib.mkIf config.desktop_support.enable {

    # xserver settings (even if we use wayland)

    services.xserver = {
      # keyboard layouts
      layout = "de,us";
      xkbVariant = ",intl";
      xkbOptions = "grp:win_space_toggle,eurosign:e";
      
      # touchpad support
      libinput.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.hyprland}/bin/Hyprland";
        };
      };
    };
    # TODO use wlgreet wiht hyprland to start session

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor (UWSM)";
          binPath = "${pkgs.hyprland}/bin/Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = false;
    };
    
    environment.systemPackages = with pkgs; [
      hyprland
      glib                  # gsettings
      grim                  # screenshots, works with slurp
      slurp                 # select regions on wayland comp
      wayland
      wev                   # debug wayland events, e.g., key presses
      wl-clipboard          # wl-copy and wl-paste for copy/paste from stdin / stdout
      xdg-utils             # open default programs when clicking links
    ];

    xdg.portal = {
      enable = true;
      wlr.enable = true;

      extraPortals = with pkgs; [ 
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
