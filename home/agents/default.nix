{
  config,
  lib,
  ...
}:
{
  imports = [
    ./antigravity
    ./codex
  ];

  options = {
    modules.agents.enable = lib.mkEnableOption "Enables support for agents based on https://agentskills.io";
  };

  config = lib.mkIf config.modules.agents.enable {
    modules.agents.antigravity.enable = lib.mkDefault true;
    modules.agents.codex.enable = lib.mkDefault false;
  };
}
