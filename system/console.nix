{ pkgs, lib, config, ... }: {

  options = {
    console_support.enable =
      lib.mkEnableOption "Enables console support with nerd-fonts.";
  };

  config = lib.mkIf config.console_support.enable {
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
