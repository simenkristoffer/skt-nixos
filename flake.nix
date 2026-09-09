{
  description = "skt-nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";	
    };
    zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
    };
    niri.url = "github:sodiboo/niri-flake";
    };
  
  
  outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: {
      nixosConfigurations.skt-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.simen = import ./home.nix;
                backupFileExtension = "backup";
            		extraSpecialArgs = { inherit inputs; };
                sharedModules = [ niri.homeModules.niri ];
              };
            }
        ];
     };
  };
  }
