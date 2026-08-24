{
  config,
  pkgs,
  lib,
  ...
}: let
  ollamaPort = 11434;

  syncScript = pkgs.writeShellScript "ollama-sync-models" ''
    OLLAMA="${pkgs.ollama}/bin/ollama"
    DESIRED=(${lib.concatMapStringsSep " " (m: "\"${m}\"") config.modules.ollama.models})

    # Wait for server readiness
    max_retries=30
    count=0
    until $OLLAMA list >/dev/null 2>&1 || [ $count -eq $max_retries ]; do
      sleep 1
      count=$((count + 1))
    done

    # Pull desired models
    for model in "''${DESIRED[@]}"; do
      $OLLAMA pull "$model"
    done

    # Prune unlisted models
    INSTALLED=$($OLLAMA list | tail -n +2 | ${pkgs.gawk}/bin/awk '{print $1}')
    for installed in $INSTALLED; do
      keep=false
      for desired in "''${DESIRED[@]}"; do
        if [ "$installed" = "$desired" ] || [ "$installed:latest" = "$desired" ]; then
          keep=true
          break
        fi
      done
      if [ "$keep" = false ]; then
        $OLLAMA rm "$installed"
      fi
    done
  '';
in {
  options = {
    modules.ollama = {
      enable = lib.mkEnableOption "Enables Ollama local LLM service.";

      acceleration = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum ["cuda" "rocm"]);
        default = null;
        description = "Hardware acceleration framework to use (e.g. cuda, rocm).";
      };

      models = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "hf.co/mradermacher/zeta-2.1-GGUF:Q4_K_M"
        ];
        description = "List of Ollama models to automatically fetch and sync on service start.";
      };

      defaultModel = lib.mkOption {
        type = lib.types.str;
        default = "hf.co/mradermacher/zeta-2.1-GGUF:Q4_K_M";
        description = "Default model referenced by editor integrations.";
      };
    };
  };

  config = lib.mkIf config.modules.ollama.enable {
    assertions = [
      {
        assertion = lib.elem config.modules.ollama.defaultModel config.modules.ollama.models;
        message = "modules.ollama.defaultModel ('${config.modules.ollama.defaultModel}') must be included in modules.ollama.models.";
      }
    ];

    services.ollama = {
      enable = true;
      port = ollamaPort;
      acceleration = config.modules.ollama.acceleration;
      environmentVariables =
        {
          OLLAMA_NO_CLOUD = "1";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          OLLAMA_MLX = "1";
        };
    };

    systemd.user.services.ollama-model-loader = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
      Unit = {
        Description = "Synchronize specified Ollama models";
        After = ["ollama.service"];
        Wants = ["ollama.service"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${syncScript}";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };

    launchd.agents.ollama-model-loader = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin) {
      enable = true;
      config = {
        ProgramArguments = ["${syncScript}"];
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/OllamaModelLoader.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/OllamaModelLoader.log";
      };
    };
  };
}
