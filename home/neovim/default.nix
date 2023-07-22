{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimExtraPlugins; [
      plenary-nvim
      nvim-tree-lua
      nvim-web-devicons
      nvim-surround
      comment-nvim
      express-line-nvim
      tokyonight-nvim
    ];
  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}
