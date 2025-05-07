{ lib, ... }: {

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./console.nix
    ./desktop.nix
    ./sound.nix
    ./bluetooth.nix
    ./nvidia.nix
  ];

  console_support.enable = lib.mkDefault true;
  desktop_support.enable = lib.mkDefault true;
  sound_support.enable = lib.mkDefault true;
  bluetooth_support.enable = lib.mkDefault true;
}
