{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-darwin";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };

        overlays = with inputs; [
          nixneovimplugins.overlays.default
        ];
      };
    in {
      homeConfigurations."fheinrichs" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix, e.g., to pass through inputs
        # use:
        # inherit inputs;
        extraSpecialArgs = rec {
          user = "fheinrichs";
          home = "/Users/${user}";
          theme = "modus-vivendi";
        };

        modules = [ ./home.nix ];
      };
    };
}
