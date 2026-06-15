{ pkgs, lib, config, ... }: {
  
  options = {
    modules.nvidia.enable =
      lib.mkEnableOption "Enables proprietary driver nvidia support.";
  };

  config = lib.mkIf config.modules.nvidia.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    hardware.nvidia = {
      open = true;
      powerManagement.enable = true;
      # modesetting.enable = true;
    };

    services.xserver.videoDrivers = lib.mkIf config.modules.desktop.enable [
      "nvidia"
    ];

    environment.systemPackages = with pkgs; [
      vulkan-tools
    ];
  };
}
