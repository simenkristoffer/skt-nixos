{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
    	url = "github:nix-community/home-manager/release-26.05";
	inputs.nixpkgs.follows = "nixpkgs";
	};
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";

      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, zen-browser, home-manager, ... }@inputs: {
    nixosConfigurations."skt-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # <-- VIKTIG: Denne må være med!
      modules = [
        ./configuration.nix
	home-manager.nixosModules.default
      ];
    };
  };
} 
