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
        };

        experimental = {
          plan = true;
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

