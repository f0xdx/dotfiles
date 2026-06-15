{pkgs, ...}: {
  modules.desktop.enable = true;
  modules.firefox.enable = true;
  modules.spotify.enable = true;

  home.packages = with pkgs; [
    gopls
    go
    gofumpt
    golangci-lint
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  services.ollama = {
    acceleration = "cuda";
  };
}
