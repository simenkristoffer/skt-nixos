{
  description = "skt-nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
      };
      
    niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    
    zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs = {
      # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
      nixpkgs.follows = "nixpkgs-unstable";
      # Use my home-manager instead of the Zen flake's own copy.
      # Why: without this, flake.lock pins two different home-manager versions.
      # That means extra downloads and a risk of the versions behaving differently.
      # With this, Zen always follows the same version as the rest of the system.
      home-manager.follows = "home-manager";
    };
  };

  };

    outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: {
      nixosConfigurations.skt-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
	modules = [
	  ./configuration.nix
      niri.nixosModules.niri
	  home-manager.nixosModules.home-manager 
	  {
	    home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      users.simen = import ./home.nix;
	      backupFileExtension = "backup";

          extraSpecialArgs = { inherit inputs; };
	      };
	    }
	  ];
	};
      };
}
	   
