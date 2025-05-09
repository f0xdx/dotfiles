{ pkgs, lib, config, ... }: 
let
  hyprland_wlgreet_shell = pkgs.writeTextFile {
    name = "hyprland_wlgreet_shell.conf";
    destination = "/share/hyprland_wlgreet_shell.conf";
    text = ''
      $mod = SUPER

      exec-once = wlgreet --command hyprland; hyprctl dispatch exit

      bind = $mod, Q, exec, systemctl poweroff
      bind = $mod, R, exec, systemctl reboot
    '';
  };
in {

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
        options = "grp:win_space_toggle,eurosign:e,ctrl:nocaps";
      };
    };

    # touchpad support
    services.libinput.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.hyprland}/bin/Hyprland";
          command = "${pkgs.hyprland}/bin/hyprland --config ${hyprland_wlgreet_shell}/share/hyprland_wlgreet_shell.conf";
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

    services.hypridle.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = {};

    environment.systemPackages = with pkgs; [
      alacritty
      glib                  # gsettings
      grim                  # screenshots, works with slurp
      greetd.wlgreet
      hyprpaper
      libnotify
      mako
      slurp                 # select regions on wayland comp
      wayland
      waybar
      wev                   # debug wayland events, e.g., key presses
      wl-clipboard          # wl-copy and wl-paste for copy/paste from stdin / stdout
      xdg-utils             # open default programs when clicking links
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # fonts

    fonts.packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
    ];

    xdg.portal = {
      enable = true;
      wlr.enable = true;

      extraPortals = with pkgs; [ 
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        # xdg-desktop-portal-hyprland
      ];
    };
  };
}
