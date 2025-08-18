{ inputs, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./locales.nix
    ./network.nix
    ./users.nix
    ./zram.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
