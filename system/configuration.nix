# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Matcha-dark-sea'
        gsettings set $gnome_schema color-scheme 'prefer-dark'
      '';
  };

in
{
  imports =
    [ # Include the results of the hardware scbrightnessctlan.
      ./hardware-configuration.nix
    ];

  # boot loader

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      # airplane mode button on msi ws65 (to fix suspend wireless deactivation)
      # activating this breaks the touchpad after resume on 5.15, fix after 5.19
      # "acpi_osi=!" 
      # "acpi_osi=\"Windows 2009\""
    ];
    blacklistedKernelModules = [
      "i2c_nvidia_gpu"  # RTX3000 does not have a usb-c port for monitors
      "psmouse"         # no ps-mouse on this system, only synaptics touchpad
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;


  # networking

  networking.hostName = "buildr"; 
  networking.networkmanager.enable = true;  


  # timezone
  
  time.timeZone = "Europe/Berlin";


  # i18n

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "ter-u18n";
    # keyMap = "de";
    useXkbConfig = true; # use xkbOptions in tty.
  };
 
  # TODO alternative: use kmscon for unicode support, faster rendering (hardware accell)
  # TODO: this seems to break sway+nvidia as it renders the dri device busy
  # https://search.nixos.org/options?channel=22.11&show=services.kmscon.extraConfig&from=0&size=50&sort=relevance&type=packages&query=kmscon
  # https://wiki.archlinux.org/title/KMSCON
  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   extraConfig = ''
  #     font-size=14
  #   '';
  #   fonts = [
  #     { name = "ter-u18n"; package = pkgs.terminus_font; }
  #   ];
  # };


  # fonts

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "Terminus" ]; })
  ];


  # graphics (nvidia)

  nixpkgs.config.allowUnfree = true;

  hardware.opengl.enable = true;
  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
  };
  security.polkit.enable = true;

  # configure xserver settings (even if we use wayland)
  services.xserver = {
    # support nvidia
    videoDrivers = [ "modesetting" "nvidia" ];
    
    # keyboard layouts
    layout = "de,us";
    xkbVariant = ",intl";
    xkbOptions = "grp:win_space_toggle,eurosign:e";
    
    # toucpad support
    libinput.enable = true;
  };
 

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # users

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.f0xdx = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
  };


  # system packages

  environment.systemPackages = with pkgs; [
    # general

    bluez
    brightnessctl
    glib
    glxinfo
    neovim 
    pciutils
    pipewire
    tmux
    vulkan-tools

    # wayland/sway

    configure-gtk
    dbus-sway-environment
    grim                  # screenshots, works with slurp
    mako                  # notification system developed by swaywm maintainer
    matcha-gtk-theme
    paper-icon-theme
    slurp                 # select regions on wayland comp
    sway
    swayidle
    swaylock
    waybar
    wayland
    wev                   # debug wayland events, e.g., key presses
    wl-clipboard          # wl-copy and wl-paste for copy/paste from stdin / stdout
    xdg-utils
  ];
  environment.pathsToLink = [ "/share/bash-completion" ];


  # bluetooth

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;


  # sound

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

    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
      }
    ];
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

