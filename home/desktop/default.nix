{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprland
    ./kanshi.nix
  ];

  options = {
    modules.desktop.enable =
      lib.mkEnableOption "Enables desktop environment configurations (GTK theme, icons, and dconf).";
  };

  config = lib.mkIf config.modules.desktop.enable {
    modules = {
      kanshi.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
    };

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
      gtk4.theme = config.gtk.theme;
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
    ];
  };
}
