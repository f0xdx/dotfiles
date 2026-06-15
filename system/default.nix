{lib, ...}: {
  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    ./console.nix
    ./desktop.nix
    ./sound.nix
    ./bluetooth.nix
    ./nvidia.nix
    ./printing.nix
  ];

  modules.console.enable = lib.mkDefault true;
  modules.desktop.enable = lib.mkDefault true;
  modules.sound.enable = lib.mkDefault true;
  modules.bluetooth.enable = lib.mkDefault true;
  modules.printing.enable = lib.mkDefault true;
}
