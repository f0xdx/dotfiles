{
  config,
  lib,
  home,
  ...
}: {
  options = {
    modules.agents.antigravity.enable =
      lib.mkEnableOption "Enables support for the Antigravity agent CLI.";
  };

  config = lib.mkIf config.modules.agents.antigravity.enable {
    programs.antigravity-cli = {
      enable = true;
      settings = {
        # security = {
        #   auth = {
        #     selectedType = "oauth-personal";
        #   };
        # };
        #
        # general = {
        #   vimMode = true;
        #   preferredEditor = "neovim";
        #   enableAutoUpdate = false;
        #   sessionRetention = {
        #     enabled = true;
        #     maxAge = "120d";
        #   };
        # };
        #
        # experimental = {
        #   modelSteering = true;
        #   enableAgents = true;
        #   autoMemory = true;
        #   enableNotifications = true;
        #   plan = true;
        #   topicUpdateNarration = true;
        # };
        #
        # tools = {
        #   useRipgrep = true;
        # };
        # context = {
        #   fileName = [
        #     "AGENTS.md"
        #     "CONTEXT.md"
        #   ];
        # };
        colorScheme = "dark"; # TODO use system light/dark switch
        editor = "vim";
        enableTelemetry = false;
        enableTerminalSandbox = true;

        permissions = {
          allow = [
            "command(ls)"
            "command(git)"
          ];
          deny = [
            "command(rm -rf /)"
            "command(sudo)"
            "write_file(.git/)"
            "write_file(${home}/.ssh)"
          ];
        };

      };

      skills = ../skills;
    };
  };
}
