{
  description = "system and home configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
	config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in {

      # NixOS config entry point
      # organized by hostname, apply through 'sudo nixos-rebuild --flake .#'
      nixosConfigurations = {
        buildr = lib.nixosSystem {
          inherit system;
	  specialArgs = { inherit inputs; }; # pass flake inputs through

	  modules = [
            ./system/configuration.nix
	  ];
	};
      };

      # HomeManager standalone entry point
      # organized by username, apply through 'homemanager switch --flake .#f0xdx'
      homeConfigurations = {
        f0xdx = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/home.nix
          ];
	};
      };
    };
}