{ pkgs, lib, config, ... }: {

  options = {
    modules.sound.enable =
      lib.mkEnableOption "Enables system sound support via Pipewire.";
  };

  config = lib.mkIf config.modules.sound.enable {
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
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
          ];
        };
      };

      wireplumber.extraConfig."11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pipewire
    ];

  };
}
