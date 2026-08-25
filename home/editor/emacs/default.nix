{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    modules.emacs = {
      enable = lib.mkEnableOption "Enables Emacs editor configuration.";
    };
  };

  config = lib.mkIf config.modules.emacs.enable {
    programs.emacs = {
      enable = true;
      package =
        if pkgs.stdenv.hostPlatform.isLinux
        then
          (
            if (pkgs ? emacs30-pgtk)
            then pkgs.emacs30-pgtk
            else pkgs.emacs-pgtk
          )
        else
          (
            if (pkgs ? emacs30)
            then pkgs.emacs30
            else pkgs.emacs
          );
      extraPackages = epkgs: with epkgs; [
        consult
        consult-eglot
        difftastic
        direnv
        embark
        embark-consult
        exec-path-from-shell
        expreg
        # ghostel # v0.51.0 doesn't build on mac os, check https://search.nixos.org/packages?channel=unstable&query=emacsPackages.ghostel#show=emacsPackages.ghostel
        hl-todo
        marginalia
        markdown-ts-mode
        nerd-icons
        nerd-icons-grep
        nerd-icons-xref
        nerd-icons-dired
        nerd-icons-completion
        nix-ts-mode
        orderless
        (treesit-grammars.with-grammars (p: [
          p.tree-sitter-bash
          p.tree-sitter-c
          p.tree-sitter-dockerfile
          p.tree-sitter-elisp
          p.tree-sitter-go
          p.tree-sitter-gomod
          p.tree-sitter-gotmpl
          p.tree-sitter-hcl
          p.tree-sitter-json
          p.tree-sitter-make
          p.tree-sitter-markdown
          p.tree-sitter-markdown-inline
          p.tree-sitter-mermaid
          p.tree-sitter-nix
          p.tree-sitter-proto
          p.tree-sitter-python
          p.tree-sitter-rust
          p.tree-sitter-sql
          p.tree-sitter-toml
          p.tree-sitter-yaml
          p.tree-sitter-zig
        ]))
        wgrep
	ultra-scroll
        vertico
        zig-ts-mode
      ];
    };

    home.shellAliases = {
      ex = "emacsclient -c -a ''";
      et = "emacsclient -t -a ''";
    };

    home.packages = with pkgs; [


      # bash
      shellcheck
      shfmt
      bash-language-server

      # golang
      gopls
      go
      gofumpt
      golangci-lint

      #nix
      nixd
      nil
      nixfmt

      # zig
      zig
      zig-zlint
      zig-shell-completions
      zls
    ];

    xdg.configFile."emacs" = {
      source = ./cfg;
      recursive = true;
    };
  };
}
