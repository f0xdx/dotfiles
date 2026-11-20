{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.agents.homeManagerModules.codex-acp
  ];
  options = {
    modules.agents.codex.enable = lib.mkEnableOption "Enables support for codex agent.";
  };

  config = lib.mkIf config.modules.agents.codex.enable {
    programs.codex = {
      enable = true;
      acp.enable = true;
      # settings = {
      # };

      skills = ../skills;
    };
  };
}
