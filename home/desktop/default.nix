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
    desktop_support.enable =
      lib.mkEnableOption "Enables proprietary driver nvidia support.";
  };

  config = lib.mkIf config.desktop_support.enable {
    kanshi_support.enable = lib.mkDefault true;
    hyprland_support.enable = lib.mkDefault true;

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
    ];
  };
}
