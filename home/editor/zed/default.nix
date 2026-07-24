{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    modules.zed = {
      enable = lib.mkEnableOption "Enables Zed editor configuration.";

      ollamaIntegration = {
        enable = lib.mkEnableOption "Enables Ollama local AI edit predictions in Zed.";
        model = lib.mkOption {
          type = lib.types.str;
          default = config.modules.ollama.defaultModel;
          description = "Ollama model to use for edit predictions in Zed.";
        };
      };
    };
  };

  config = lib.mkIf config.modules.zed.enable {
    warnings = lib.optional (
      config.modules.zed.ollamaIntegration.enable
      && !config.modules.ollama.enable
    ) "modules.zed.ollamaIntegration is enabled, but modules.ollama is disabled.";

    assertions = [
      {
        assertion =
          config.modules.zed.ollamaIntegration.enable
          -> (lib.elem config.modules.zed.ollamaIntegration.model config.modules.ollama.models);
        message = "modules.zed.ollamaIntegration.model ('${config.modules.zed.ollamaIntegration.model}') must be included in modules.ollama.models.";
      }
    ];

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
        edit_predictions =
          if config.modules.zed.ollamaIntegration.enable
          then {
            provider = "ollama";
            ollama = {
              api_url = "http://localhost:${toString config.services.ollama.port}";
              model = config.modules.zed.ollamaIntegration.model;
              prompt_format = "infer";
            };
          }
          else {
            provider = "zed";
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
  };
}
