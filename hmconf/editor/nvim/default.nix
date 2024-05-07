{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = (with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      telescope-zf-native-nvim
      telescope-undo-nvim
      telescope-file-browser-nvim
      telescope-nvim
      nvim-lspconfig
      lspkind-nvim
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer	
      cmp-path	
      cmp-cmdline
      cmp-git
      nvim-cmp
      luasnip
      nvim-treesitter-textobjects	
      nvim-treesitter-context
      playground
      (nvim-treesitter.withPlugins (p: with p; [
        bash
        comment
        css
        diff
        dockerfile
        elm
        fennel
        go
        gomod
        gowork
        haskell
        hcl
        html
        javascript
        json
        lua
        make
        markdown
        markdown_inline
        nix
        proto
        sql
        terraform
        typescript
        yaml
        zig
      ]))
      nvim-surround
      comment-nvim
    ]) ++ (with pkgs.vimExtraPlugins; [
      modus-themes-nvim
      express-line-nvim
      # LuaSnip
      cmp-luasnip
    ]);

    extraPackages = with pkgs; [
      fd
      ripgrep
      lua-language-server
    ];
  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}

# TODO Extension points
#
# nvim-treesitter-textsubjects	- do what I mean navigation and motion commands
#                                 based on TS nodes
# nvim-dap / nvim-dap-cmp       - debug adapter for various languages, supports
#                                 debugging from within nvim
# add more language servers to the list (go, zig, haskell, fennel etc.)
