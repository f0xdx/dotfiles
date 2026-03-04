{
  config,
  lib,
  ...
}: {
  imports = [
    ./gemini
  ];

  options = {
    agents.enable =
      lib.mkEnableOption "Enables support for agents based on https://agentskills.io";
  };

  config = lib.mkIf config.agents.enable {
    agents_gemini.enable = lib.mkDefault true;

    home.file.".agents/skills".source = ./skills;
  };
}


