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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # krever nyeste quickshell
    };
  };

  outputs = { self, nixpkgs, zen-browser, home-manager, niri, noctalia, ... }@inputs: {
    nixosConfigurations."skt-thinkpad" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # <-- IMPORTANT: this must be included!
      modules = [
        ./configuration.nix
	      home-manager.nixosModules.default
        ./modules/mysql-server.nix
      ];
    };
  };
} 
