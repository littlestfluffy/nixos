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

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = let
      mkSystem = { hostname, profile ? hostname }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/${profile}/configuration.nix
          { networking.hostName = hostname; }
        ];
      };
    in {
      krolik = mkSystem { hostname = "krolik"; };
      test = mkSystem { hostname = "test"; profile = "qemu"; };
    };
  };
}
