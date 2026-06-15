{
  config,
  lib,
  ...
}: {
  imports = [
    ./antigravity
  ];

  options = {
    agents.enable =
      lib.mkEnableOption "Enables support for agents based on https://agentskills.io";
  };

  config = lib.mkIf config.agents.enable {
    agents_antigravity.enable = lib.mkDefault true;
  };
}
