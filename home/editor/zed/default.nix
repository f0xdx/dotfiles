{
  lib,
  pkgs,
  ...
}: let
  ollamaPort = 11434;
in {
  # config example: https://wiki.nixos.org/wiki/Zed#LSP_Support

  programs.zed-editor = {
    enable = true;

    extensions = [
      "basedpyright"
      "basher"
      "dockerfile"
      "git-firefly"
      "golangci-lint"
      "graphql"
      "make"
      "marksman"
      "modus-themes"
      "nix"
      "proto"
      "ruff"
      "toml"
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
          "ctrl-w %" = "pane::SplitVertical";
          "ctrl-w \"" = "pane::SplitHorizontal";
          "space f f" = "file_finder::Toggle";
          "space f t" = "tab_switcher::Toggle";
          "space f c" = "command_palette::Toggle";
          "space f g" = "pane::DeploySearch";
        };
      }
    ];

    userSettings = {
      # base
      auto_update = false;
      journal = {
        hour_format = "hour24";
      };
      load_direnv = "shell_hook";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      node = with lib; {
        path = getExe pkgs.nodejs;
        npm_path = getExe' pkgs.nodejs "npm";
      };

      # editor
      preferred_line_length = 80;
      show_wrap_guides = true;
      wrap_guides = [
        81
        121
      ];

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
        use_smartcase_find = true;
      };
      relative_line_numbers = false;

      # theme
      theme = {
        # mode = "system";
        mode = "dark"; # TODO this should be system on mac, hardcoded on linux
        light = "Modus Operandi";
        dark = "Modus Vivendi";
      };

      icon_theme = {
        mode = "system";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };

      # lsp

      languages = {
        "Nix" = {
          formatter.external = {
            command = "alejandra";
            arguments = [
              "--quiet"
              "--"
            ];
          };
        };
        "Python" = {
          language_servers = [
            "ruff"
            "basedpyright"
          ];
          format_on_save = "on";
          formatter = [
            {
              code_actions = {
                "source.organizeImports.ruff" = true;
                "source.fixAll.ruff" = true;
              };
            }
            {
              language_server = {
                name = "ruff";
              };
            }
          ];
        };
      };
      file_types = {
        Dockerfile = [
          "Dockerfile.*"
        ];
      };
      lsp = {
        gopls = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.gopls;
          };
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
        graphql = {
          binary = {
            path = lib.getExe pkgs.graphql-language-service-cli;
          };
        };
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
          };
        };
        shellcheck = {
          binary = {
            path = lib.getExe pkgs.shellcheck;
          };
        };
        dockerfile-language-server = {
          binary = {
            path = lib.getExe pkgs.dockerfile-language-server;
          };
        };
        golangci-lint = {
          binary = {
            path = lib.getExe pkgs.golangci-lint;
          };
        };
        # ruff = {
        #   binary = {
        #     path = lib.getExe pkgs.ruff;
        #   };
        # };
        # basedpyright = {
        #   binary = {
        #     path = lib.getExe pkgs.basedpyright;
        #   };
        # };
      };
    };

    extraPackages = with pkgs; [
      alejandra
      basedpyright
      dockerfile-language-server
      go
      gofumpt
      golangci-lint
      gopls
      govulncheck
      graphql-language-service-cli
      marksman
      nil
      nixd
      nodejs
      python313
      ruff
      shellcheck
    ];
  };

  # local LLM support

  # note that this will require to install the model through ollama first
  #
  # ollama run hf.co/zed-industries/zeta
  #
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.enable
  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  #   port = ollamaPort;
  # };

  # using vllm
  # home.packages = with pkgs; [
  #   vllm
  # ];
}
