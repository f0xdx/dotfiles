{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    modules.bluetooth.enable =
      lib.mkEnableOption "Enables Bluetooth system services.";
  };

  config = lib.mkIf config.modules.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
    ];
  };
}
