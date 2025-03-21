{ config, pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    
    settings = builtins.fromTOML (builtins.readFile ./cfg/starship.toml);
  };
}

