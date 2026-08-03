{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    modules.emacs = {
      enable = lib.mkEnableOption "Enables Emacs editor configuration.";
    };
  };

  config = lib.mkIf config.modules.emacs.enable {
    programs.emacs = {
      enable = true;
      package =
        if pkgs.stdenv.isLinux
        then
          (
            if (pkgs ? emacs30-pgtk)
            then pkgs.emacs30-pgtk
            else pkgs.emacs-pgtk
          )
        else
          (
            if (pkgs ? emacs30)
            then pkgs.emacs30
            else pkgs.emacs
          );
      extraPackages = epkgs: with epkgs; [
        difftastic
        magit
        orderless
	ultra-scroll
        vertico
      ];
    };

    home.shellAliases = {
      ex = "emacsclient -c -a ''";
      et = "emacsclient -t -a ''";
    };

    xdg.configFile."emacs" = {
      source = ./cfg;
      recursive = true;
    };
  };
}
