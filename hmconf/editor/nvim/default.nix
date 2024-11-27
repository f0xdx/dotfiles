{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = (with pkgs.vimPlugins; [
      # basic
      plenary-nvim
      nvim-web-devicons

      # telescope
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
      luasnip
      cmp_luasnip
      nvim-cmp

      # treesitter
      nvim-treesitter-textobjects	
      nvim-treesitter-context
      playground
      (nvim-treesitter.withPlugins (p: with p; [
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
        vimdoc
        yaml
        zig
      ]))

      # misc
      nvim-surround
    ]) ++ (with pkgs.vimExtraPlugins; [
      modus-themes-nvim
      express-line-nvim
    ]);

    extraPackages = with pkgs; [
      # llm-ls # broken on mac, see: https://github.com/NixOS/nixpkgs/issues/273596
      fd
      gopls
      go
      gofumpt
      golangci-lint
      lua-language-server
      marksman
      nixd
      ripgrep
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
#
# TODO local LLM for better coding experience: huggingface infrastructure
#
# * build a flake for https://github.com/huggingface/llm-ls in order to use the
#   llm-ls in this config
# * use [TGI](https://github.com/huggingface/text-generation-inference), needs
#   to be built, put in a flake and then run `text-generation-launcher --model-id MODEL_HUB_ID --port 8080`
#   locally, ideally as a systemd unit
# * use [llm-nvim](https://github.com/huggingface/llm.nvim) to integrate its
#   suggestions into the current buffer
# * make a simple async make utility similar to this one: https://phelipetls.github.io/posts/async-make-in-nvim-with-lua/
#   that will just populate the quickfix buffer accordingly
