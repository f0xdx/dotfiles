{ config, pkgs, lib, ... }:
{
  programs.alacritty = {
    enable = true;
  };

  xdg.configFile.alacritty = {
    source = ./cfg;
    recursive = true;
 };
}
