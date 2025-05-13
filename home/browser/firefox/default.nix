{
  config,
  lib,
  ...
}: {
  options = {
    firefox_support.enable =
      lib.mkEnableOption "Enables the firefox web browser.";
  };

  config = lib.mkIf config.firefox_support.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
    };

    programs.firefox = {
      enable = true;
      # wrapperConfig = {
      #   pipewireSupport = true;
      # };
      policies = {
        DefaultDownloadDirectory = "\${home}/downloads";
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        ExtensionSettings = {
          "bing@search.mozilla.org" = {
            installation_mode = "blocked";
          };

          "ecosia@search.mozilla.org" = {
            installation_mode = "blocked";
          };

          # lastpass
          "support@lastpass.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        SearchEngines = {
          Default = "google";
          Remove = [
            "bing"
            "ecosia"
          ];
          Add = [
            {
              Name = "nix-pkgs";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              Method = "GET";
              Alias = "@np";
              Description = "Nix Packages (unstable)";
              IconURL = "https://search.nixos.org/images/nix-logo.png";
            }
            {
              Name = "nix-opts";
              URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              Method = "GET";
              Alias = "@no";
              Description = "Nix Options (unstable)";
              IconURL = "https://search.nixos.org/images/nix-logo.png";
            }
            {
              Name = "nix-hm";
              URLTemplate = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
              Method = "GET";
              Alias = "@nh";
              Description = "Nix HomeManager Options (unstable)";
              IconURL = "https://search.nixos.org/images/nix-logo.png";
            }
            {
              Name = "nixos-wiki";
              URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              Method = "GET";
              Alias = "@nw";
              Description = "NixOS Wiki";
              IconURL = "https://search.nixos.org/images/nix-logo.png";
            }
          ];
        };
      };

      # NOTE currently the above policy does not work; it is, however, possible
      # to override with the below profile config; currently, this is not planned, as it
      # conflicts with the remote profile setting in use

      # profiles = {
      #   "${user}@${host}" = {
      #     isDefault = true;
      #     search = {
      #       force = true;
      #       default = "Google";
      #       privateDefault = "DuckDuckGo";
      #       order = [
      #         "google"
      #         "ddg"
      #         "nix-pkgs"
      #         "nix-opts"
      #         "nixos-wiki"
      #         "nixhm-opts"
      #       ];
      #       engines = {
      #         nix-pkgs = {
      #           name = "Nix Packages";
      #           urls = [
      #             {
      #               template = "https://search.nixos.org/packages";
      #               params = [
      #                 {
      #                   name = "channel";
      #                   value = "unstable";
      #                 }
      #                 {
      #                   name = "query";
      #                   value = "{searchTerms}";
      #                 }
      #               ];
      #             }
      #           ];

      #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #           definedAliases = ["@np"];
      #         };
      #         nix-opts = {
      #           name = "Nix Options";
      #           urls = [
      #             {
      #               template = "https://search.nixos.org/options";
      #               params = [
      #                 {
      #                   name = "channel";
      #                   value = "unstable";
      #                 }
      #                 {
      #                   name = "query";
      #                   value = "{searchTerms}";
      #                 }
      #               ];
      #             }
      #           ];

      #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #           definedAliases = ["@no"];
      #         };
      #         nixos-wiki = {
      #           name = "NixOS Wiki";
      #           urls = [
      #             {
      #               template = "https://wiki.nixos.org/w/index.php";
      #               params = [
      #                 {
      #                   name = "search";
      #                   value = "{searchTerms}";
      #                 }
      #               ];
      #             }
      #           ];

      #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #           definedAliases = ["@nw"];
      #         };
      #         nixhm-opts = {
      #           name = "Nix HomeManager Options";
      #           urls = [
      #             {
      #               template = "https://home-manager-options.extranix.com/";
      #               params = [
      #                 {
      #                   name = "query";
      #                   value = "{searchTerms}";
      #                 }
      #                 {
      #                   name = "release";
      #                   value = "master";
      #                 }
      #               ];
      #             }
      #           ];

      #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #           definedAliases = ["@nh"];
      #         };
      #       };
      #     };

      #     settings = {
      #       "browser.startup.homepage" = "https://nixos.org";
      #       "general.useragent.locale" = "en-GB";
      #     };
      #   };
      # };
    };
  };
}
