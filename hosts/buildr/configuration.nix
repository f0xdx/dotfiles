{ pkgs, user, host, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # YOLO
    # kernelPackages = pkgs.linuxPackages_xanmod;

    # silent boot (press ESC to select)
    consoleLogLevel = 3;
    initrd.verbose = false;

    kernelParams = [
      # airplane mode button on msi ws65 (to fix suspend wireless deactivation)
      # activating this breaks the touchpad after resume on 5.15, fix after 5.19
      # "acpi_osi=!" 
      # "acpi_osi=\"Windows 2009\""
      # "acpi_osi=\"Windows 2018\""
      # "acpi_osi=\"Windows 2018.2\""
      # "acpi_osi=\"Windows 2020\""
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    blacklistedKernelModules = [
      "i2c_nvidia_gpu"  # RTX3000 does not have a usb-c port for monitors
      "psmouse"         # no ps-mouse on this system, only synaptics touchpad
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0; # press ESC to override
    };
    
    plymouth = {
      enable = true;
      theme = "deus_ex";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = ["deus_ex"]; })
      ];
    };

  };


  # networking

  networking = {
    hostName = host;
    networkmanager.enable = true;  
  };


  # timezone & locale
  
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # users

  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "video" ]; # enable ‘sudo’ for the user.
  };
  # NOTE after install set a password with ‘passwd’.


  # system packages

  environment.systemPackages = with pkgs; [
    brightnessctl
    pciutils
  ];

  security.polkit.enable = true;

  # modules (see /system)

  nvidia_support.enable = true;
  
  
  # state version

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "25.05"; # Did you read the comment?

}
