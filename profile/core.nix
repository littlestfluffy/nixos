{ config, pkgs, ... }:

{
  imports = [
    ./../modules/boot.nix
    ./../../modules/boot.nix
#    ./../nvidia.nix
    ./../../modules/qemu-guest.nix
    ./../../modules/pipewire.nix
    ./../../modules/hyprland.nix
    ./../../modules/vivaldi.nix
  ];
}