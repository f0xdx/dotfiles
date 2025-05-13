{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    kanshi_support.enable =
      lib.mkEnableOption "Enables proprietary driver nvidia support.";
  };

  config = lib.mkIf config.kanshi_support.enable {
    # kanshi: automatic setup of multiple displays

    services.kanshi = {
      enable = true;

      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                mode = "1920x1080@60Hz";
              }
            ];
          };
        }
        {
          profile = {
            name = "single_l";
            outputs = [
              {
                criteria = "eDP-1";
                mode = "1920x1080@60Hz";
              }
              {
                criteria = "HDMI-A-2 'BNQ BenQ GW2470 86G02271019'";
                mode = "1920x1080@60Hz";
                position = "1920,0";
              }
            ];
          };
        }
        {
          profile = {
            name = "single_r";
            outputs = [
              {
                criteria = "eDP-1";
                mode = "1920x1080@60Hz";
              }
              {
                criteria = "DP-2 'BNQ BenQ GW2470 JBF03525SL0'";
                mode = "1920x1080@60Hz";
                position = "1920,0";
              }
            ];
          };
        }
        {
          profile = {
            name = "double";
            outputs = [
              {
                criteria = "eDP-1";
                mode = "1920x1080@60Hz";
              }
              {
                criteria = "HDMI-A-2 'BNQ BenQ GW2470 86G02271019'";
                mode = "1920x1080@60Hz";
                position = "1920,0";
              }
              {
                criteria = "DP-2 'BNQ BenQ GW2470 JBF03525SL0'";
                mode = "1920x1080@60Hz";
                position = "3840,0";
              }
            ];
          };
        }
      ];
    };
  };
}
