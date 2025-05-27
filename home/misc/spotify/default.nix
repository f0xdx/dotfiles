{
  pkgs,
  lib,
  config,
  host,
  ...
}: {
  options = {
    spotify.enable =
      lib.mkEnableOption "Enables spotify setup with spotifyd and spotify-player.";

    spotify.premium =
      lib.mkEnableOption "Whether a spotify premium account is setup.";
  };

  config = lib.mkIf config.spotify.enable {
    # spotify: music streaming
    #
    # NOTE the spotify setup consists of two parts
    #
    # * [spotifyd](https://github.com/Spotifyd/spotifyd)
    # * [spotify-player](https://github.com/aome510/spotify-player)
    #
    # The spotifyd service is a systemd unit that connects and enables
    # streaming, the spotify-player then provides a TUI to control the
    # daemon. Authentication is done for the daemon and requires a [manual
    # step](https://docs.spotifyd.rs/configuration/auth.html)
    # (browser based login), after which credentials are cached:
    #
    # ```sh
    # spotifyd authenticate
    # ```
    services.spotifyd = lib.mkIf config.spotify.premium {
      enable = true;
      settings = {
        # see https://docs.spotifyd.rs/configuration/index.html
        global = {
          device_name = "${host}-spotifyd";
          device_type = "computer";
          # disable_discovery = true;
        };
      };
    };

    programs.spotify-player = lib.mkIf config.spotify.premium {
      enable = true;
      # settings = {
      #   # see https://github.com/aome510/spotify-player/blob/master/docs/config.md
      # };
    };

    home.packages = with pkgs; [
      spotify
    ];
  };
}
