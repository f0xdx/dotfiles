{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.user_options.<module_name>;
in {
  options = {
    user_options.<module_name> = {
      enable = lib.mkEnableOption "Enables <module_name> configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    # System-specific logic
    # home.packages = if pkgs.stdenv.hostPlatform.isDarwin then [ ... ] else [ ... ];

    # Common configuration
    # programs.<module_name> = {
    #   enable = true;
    #   ...
    # };

    # Darwin-specific configuration
    # nix-darwin specific options if applicable
    # (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin { ... })

    # Linux-specific configuration
    # (lib.mkIf pkgs.stdenv.hostPlatform.isLinux { ... })
  };
}
