{
  config,
  lib,
  home,
  ...
}: {
  options = {
    modules.agents.codex.enable =
      lib.mkEnableOption "Enables support for codex agent.";
  };

  config = lib.mkIf config.modules.agents.codex.enable {
    programs.codex = {
      enable = true;
      # settings = {
      # };

      skills = ../skills;
    };
  };
}
