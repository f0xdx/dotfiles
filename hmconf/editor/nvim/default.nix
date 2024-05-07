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
      telescope-fzf-native-nvim
      # TODO add instead: telescope-zf-native-nvim
      telescope-undo-nvim
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
# telescope-file-browser        - get rid of netrw and use telescope for fuzzy
#                                 search on directories and directory overview
# nvim-treesitter-textsubjects	- do what I mean navigation and motion commands
#                                 based on TS nodes
# nvim-dap / nvim-dap-cmp       - debug adapter for various languages, supports
#                                 debugging from within nvim
# manage treesitter grammars here instead of through the plugin, something like
# this https://gist.github.com/nat-418/d76586da7a5d113ab90578ed56069509?permalink_comment_id=4851047#gistcomment-4851047
# although it seems to not work directly with our overlay
