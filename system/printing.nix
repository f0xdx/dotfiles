{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    printing_support.enable =
      lib.mkEnableOption "Enables support for printing.";
  };

  config = lib.mkIf config.printing_support.enable {
    # NOTE you may need to configure/enable the printer w/ lpadmin -p <NAME> -E after
    #      auto discovery (also need to configure the drivers); alternatively, you can
    #      configure printers at https://localhost:631 in your browser or through any
    #      desktop client.
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        hplipWithPlugin
      ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
