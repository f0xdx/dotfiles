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
    zig2nix = {
      url = "github:Cloudef/zig2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zmx = {
      url = "github:neurosnap/zmx";
      inputs.zig2nix.follows = "zig2nix";
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
        localSystem = system;
        config = {
          allowUnfree = true;
        };

        overlays = with inputs; [
          nixneovimplugins.overlays.default
          (final: prev: {
            zmx = inputs.zmx.packages.${final.stdenv.hostPlatform.system}.default;
          })
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
      email,
      host,
    }: let
      pkgs = mkPkgs system;
    in {
      "${user}@${host}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit user;
          inherit email;
          inherit host;
          home =
            if pkgs.stdenv.isDarwin
            then "/Users/${user}"
            else "/home/${user}";
          theme = "modus-vivendi";
        };
        modules = [
          ./hosts/${host}/home.nix
          ./home
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
        email = "fheinrichs@heinrichs.it";
        host = "buildr";
      }
      // mkHomeConfig {
        system = "aarch64-darwin";
        user = "felixheinrichs";
        email = "felix.heinrichs@solactive.com";
        host = "PC90221.local";
        # host = "PC90221";
      };
  };
}
