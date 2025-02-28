{ config, lib, pkgs, ... }:
{
  # config example: https://wiki.nixos.org/wiki/Zed#LSP_Support

  programs.zed-editor = {
    enable = true;

    extensions = [
      "basher"
      "make"
      "marksman"
      "modus-themes"
      "nix"
    ];

    userKeymaps = [
      {
        context = "GitPanel || ProjectPanel || CollabPanel || OutlinePanel || ChatPanel || VimControl || EmptyPane || SharedScreen || MarkdownPreview || KeyContextView";
        bindings = {
          # NOTE this masks "ctrl-k": "editor::KillRingCut", but it currently does not allow for cycling through yanks anyway
          # once that has been implemented, we may need to figure out an alternative mapping
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
        };
      }
    ];

    userSettings = {
      # AI assistant
      assistant = {
        enabled = false;
        # TODO enable ai assistant through local ollama
      };

      # base
      auto_update = false;
      hour_format = "hour24";
      load_direnv = "shell_hook";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      node = with lib; {
        path = getExe pkgs.nodejs;
        npm_path = getExe' pkgs.nodejs "npm";
      };


      # font settings
      ui_font_family = "FiraCode Nerd Font";
      ui_font_size = 14;
      buffer_font_family = "FiraCode Nerd Font";
      buffer_font_size = 14;


      # key bindings

      base_keymap = "VSCode";
      vim_mode = true;
      vim = {
          toggle_relative_line_numbers = false;
          use_multiline_find = true;
          use_smartcase_find = true;
      };
      relative_line_numbers = false;

      # theme
      theme = {
          mode = "system";
          light = "Modus Operandi";
          dark = "Modus Vivendi";
      };

      icon_theme = {
          mode = "system";
          light = "Light Icon Theme";
          dark = "Dark Icon Theme";
      };


      # lsp
      lsp = {
          gopls = {
              path_lookup = true;
              initialization_options = {
                  # options found here: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
                  usePlaceholders = true;
                  staticcheck = true;
                  gofumpt = true;
                  vulncheck = "Imports";

                  # TODO may also need hints: https://github.com/golang/tools/blob/master/gopls/doc/settings.md#inlayhint
                  # TODO may also need analyzers: https://github.com/golang/tools/blob/master/gopls/doc/settings.md#analyses-mapstringbool
                  # TODO need to check whether this is also needed
                  # buildFlags = [
                  #   "-tags=it"
                  # ];

                  env = {
                    GOFLAGS = "-tags=it";
                  };
              };
          };
          nixd = {
            # path = lib.getExe pkgs.nixd;
            path_lookup = true; # set this for using system wide install
          };
          nil = {
            # path = lib.getExe pkgs.nil;
            path_lookup = true; # set this for using system wide install
          };
          shellcheck = {
              path_lookup = true;
          };
      };
    };

    extraPackages = with pkgs; [
      go
      gofumpt
      golangci-lint
      gopls
      govulncheck
      marksman
      nodejs
      nixd
      nil
      shellcheck
    ];
  };

  # local LLM support

  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.enable
  services.ollama = {
    enable = true;
  };
}
