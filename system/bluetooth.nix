{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bluetooth_support.enable =
      lib.mkEnableOption "Enables support for bluetooth.";
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
