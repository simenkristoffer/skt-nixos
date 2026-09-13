{
  description = "skt-nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
      };
      
    niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
    };

  };

    outputs = { self, nixpkgs, home-manager, niri, ... }: {
      nixosConfigurations.skt-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
	      };
	    }
	  ];
	};
      };
}
	   
