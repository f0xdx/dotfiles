{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    modules.printing.enable =
      lib.mkEnableOption "Enables system CUPS printing services.";
  };

  config = lib.mkIf config.modules.printing.enable {
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
