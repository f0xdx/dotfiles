{ pkgs, lib, config, ... }: {

  options = {
    desktop_support.enable =
      lib.mkEnableOption "Enables support for a wayland based desktop environment.";
  };

  config = lib.mkIf config.desktop_support.enable {

    # xserver settings (even if we use wayland)

    services.xserver = {
      # keyboard layouts
      xkb = {
        layout = "de,us";
        variant = ",intl";
        options = "grp:win_space_toggle,eurosign:e";
      };
    };

    # touchpad support
    services.libinput.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.hyprland}/bin/Hyprland";
        };
      };
    };
    # TODO use wlgreet wiht hyprland to start session

    programs.uwsm = {
      enable = true;
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
# trace: evaluation warning: The option `services.xserver.xkbVariant' defined in `/nix/store/n171h57mwf839rfkz3rzhplgiqcmk86w-source/system/desktop.nix' has been renamed to `services.xserver.xkb.variant'.
# trace: evaluation warning: The option `services.xserver.xkbOptions' defined in `/nix/store/n171h57mwf839rfkz3rzhplgiqcmk86w-source/system/desktop.nix' has been renamed to `services.xserver.xkb.options'.
# trace: evaluation warning: The option `services.xserver.layout' defined in `/nix/store/n171h57mwf839rfkz3rzhplgiqcmk86w-source/system/desktop.nix' has been renamed to `services.xserver.xkb.layout'.
# trace: evaluation warning: The option `services.xserver.libinput.enable' defined in `/nix/store/n171h57mwf839rfkz3rzhplgiqcmk86w-source/system/desktop.nix' has been renamed to `services.libinput.enable'.
