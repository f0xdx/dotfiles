{
  description = "System and Home Manager Configuration";

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

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # prepare a pkgs attribute configured with required overlays
    mkPkgs = system:
      import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };

        overlays = with inputs; [
          nixneovimplugins.overlays.default
        ];
      };

    # create a nixos system definition
    mkNixosSystem = {
      system,
      user,
      host,
    }: let
      pkgs = mkPkgs system;
      lib = nixpkgs.lib;
    in {
      "${host}" = lib.nixosSystem {
        inherit system;
        inherit pkgs;
        specialArgs = {
          inherit inputs; # pass flake inputs through
          inherit user;
          inherit host;
        };

        modules = [
          ./hosts/${host}/configuration.nix
          ./system
        ];
      };
    };

    # create a home manager configuration
    mkHomeConfig = {
      system,
      user,
      host,
    }: let
      pkgs = mkPkgs system;
    in {
      "${user}@${host}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit user;
          inherit host;
          home =
            if pkgs.stdenv.isDarwin
            then "/Users/${user}"
            else "/home/${user}";
          theme = "modus-vivendi";
        };
        modules = [
          ./home/home.nix
        ];
      };
    };
  in {
    # NixOS config
    # organized by hostname, apply through 'sudo nixos-rebuild --flake .#'
    nixosConfigurations = mkNixosSystem {
      system = "x86_64-linux";
      user = "f0xdx";
      host = "buildr";
    };

    # HomeManager standalone
    # organized by username, apply through 'homemanager switch --flake .'
    homeConfigurations =
      mkHomeConfig {
        system = "x86_64-linux";
        user = "f0xdx";
        host = "buildr";
      }
      // mkHomeConfig {
        system = "x86_64-darwin";
        user = "fheinrichs";
        host = "workr";
      };
  };
}
