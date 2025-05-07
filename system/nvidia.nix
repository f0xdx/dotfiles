{ pkgs, lib, config, ... }: {
  
  options = {
    nvidia_support.enable =
      lib.mkEnableOption "Enables proprietary driver nvidia support.";
  };

  config = lib.mkIf config.nvidia_support.enable {
    nixpkgs.config = {
      allowUnfree = true;
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    hardware.nvidia = {
      enabled = true;
      open = true;
      powerManagement.enable = true;
      # modesetting.enable = true;
    };

    services.xserver.videoDrivers = lib.mkIf config.desktop_support.enable [
      "nvidia"
    ];

    environment.systemPackages = with pkgs; [
      vulkan-tools
    ];
  };
}
