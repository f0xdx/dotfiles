{ pkgs, lib, config, ... }: {

  options = {
    sound_support.enable =
      lib.mkEnableOption "Enables support for a wayland based desktop environment.";
  };

  config = lib.mkIf config.sound_support.enable {
    # disabled to not conflict with pipewire
    sound.enable = false;

    # optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

      wireplumber.extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pipewire
    ];

  };
}
