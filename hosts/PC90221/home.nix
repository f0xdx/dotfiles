{pkgs, ...}: {
  modules.desktop.enable = false;
  modules.firefox.enable = true;
  modules.ghostty.enable = false;
  modules.spotify.enable = false;

  home.packages = with pkgs; [
    _1password-cli
    glab
    markdownlint-cli2
  ];

  home.sessionPath = [
    "$HOME/.rd/bin"
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

  programs.firefox = {
    policies = {
      ExtensionSettings = {
        "bing@search.mozilla.org" = {
          installation_mode = "blocked";
        };

        "ecosia@search.mozilla.org" = {
          installation_mode = "blocked";
        };

        # 1password
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
