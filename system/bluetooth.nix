{ pkgs, lib, config, ... }: {

  options = {
    bluetooth_support.enable =
      lib.mkEnableOption "Enables support for a wayland based desktop environment.";
  };

  config = lib.mkIf config.bluetooth_support.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
    ];

  };
}
