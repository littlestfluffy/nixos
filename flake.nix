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
      mkSystem = { hostname, profile ? hostname, disk ? null }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/${profile}/configuration.nix
          { networking.hostName = hostname; disk = disk; }
        ] ++ (if disk != null then [
          {
            nixos.install.postBootCommands = ''
              wipefs -a ${disk}
              parted ${disk} -- mklabel gpt

              # EFI / boot partition (512MiB)
              parted ${disk} -- mkpart ESP fat32 1MiB 513MiB
              parted ${disk} -- set 1 boot on
              mkfs.fat -F32 ${disk}1 -n NIXBOOT

              # Root partition (rest of disk)
              parted ${disk} -- mkpart primary ext4 513MiB 100%
              mkfs.ext4 ${disk}2 -L NIXROOT

              # Mount
              mount ${disk}2 /mnt
              mkdir -p /mnt/boot
              mount ${disk}1 /mnt/boot
            '';
          }
        ] else []);
      };
    in {
      krolik = mkSystem { hostname = "krolik"; };
      test   = mkSystem { hostname = "test"; profile = "qemu"; disk = "/dev/sda"; };
    };
  };
}
