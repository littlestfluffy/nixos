{
  description = "A simple NixOS flake";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = let
    nixosVersion = "25.05";
  in {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${nixosVersion}";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager/release-${nixosVersion}";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = let
      mkSystem = { hostname, disk ? "nodev" }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/${hostname}/configuration.nix
          { networking.hostName = hostname; boot.loader.grub.device = disk; }
        ];
      };
    in {
      krolik = mkSystem { hostname = "krolik"; };
      test = mkSystem {
        hostname = "test";
        disk = "/dev/sda";
      };
    };
  };
}
