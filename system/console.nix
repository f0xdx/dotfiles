{ pkgs, lib, config, ... }: {

  options = {
    modules.console.enable =
      lib.mkEnableOption "Enables console support with nerd-fonts.";
  };

  config = lib.mkIf config.modules.console.enable {
    # console setup

    console = {
      earlySetup = true;
      packages = with pkgs; [ nerd-fonts.fira-mono ];
      # font = "ter-u18n";
      # keyMap = "de";
      useXkbConfig = true; # use xkbOptions in tty.
      # TODO make this depend on whether or not desktop support and hence xkb is
      #      enabled
    };
  


    environment.systemPackages = with pkgs; [
      neovim 
      tmux
    ];
  };
}
