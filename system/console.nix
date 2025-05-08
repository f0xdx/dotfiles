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
      font = "FiraMono Nerd Font";
      # keyMap = "de";
      useXkbConfig = true; # use xkbOptions in tty.
    };
  

    # fonts

    fonts.packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
    ];


    environment.systemPackages = with pkgs; [
      neovim 
      tmux
    ];
  };
}
