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
          { networking.hostName = hostname; boot.loader.grub.device = disk; }
        ] ++ (if profile == "qemu" && disk != null then [
          {
            nixos.install.postBootCommands = ''
              wipefs -a ${disk}
              parted ${disk} -- mklabel MBR
              parted ${disk} -- mkpart primary ext4 1MiB 512MiB
              parted ${disk} -- mkpart primary ext4 513MiB 100%
              mkfs.ext4 ${disk}1 -L NIXBOOT
              mkfs.ext4 ${disk}2 -L NIXROOT
              mount ${disk}2 /mnt
              mount --mkdir ${disk}1 /mnt/boot
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
