{
  config,
  lib,
  ...
}: {
  options = {
    agents_gemini.enable =
      lib.mkEnableOption "Enables support for Gemini agent";
  };

  config = lib.mkIf config.agents_gemini.enable {
    programs.gemini-cli = {
      enable = true;
      settings = {
        security = {
          auth = {
            selectedType = "oauth-personal";
          };
        };

        general = {
          vimMode= true;
          preferredEditor = "zed";
          enableAutoUpdate = false;
          sessionRetention = {
            enabled = true;
            maxAge = "120d";
          };
        };

        experimental = {
          modelSteering = true;
          enableAgents = true;
        };

        tools = {
          useRipgrep = true;
        };

        context = {
          fileName = [
            "AGENTS.md"
            "CONTEXT.md"
            "GEMINI.md"
          ];
        };
      };
    };
  };
}

