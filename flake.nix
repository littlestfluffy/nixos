{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixosConfigurations = let
      mkSystem = { hostname, disk ? "nodev" }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/${hostname}/configuration.nix
          { networking.hostName = hostname; boot.loader.grub.device = disk; }

          # Enable Home Manager as a NixOS module
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.emily = import ./home/${hostname}.nix;
          }
        ];
      };
    in {
      krolik = mkSystem { hostname = "krolik"; };
      satisfactory = mkSystem { hostname = "satisfactory"; disk = "/dev/sda"; };
      core = mkSystem { hostname = "core"; disk = "/dev/sda"; };
    };
  };
}
