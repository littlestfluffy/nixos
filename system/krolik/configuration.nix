# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = let
    candidates = [
      ./hardware-configuration.nix
      /mnt/etc/nixos/hardware-configuration.nix
      /etc/nixos/hardware-configuration.nix
    ];
  in (builtins.filter builtins.pathExists candidates) ++ [ ./.. ];

   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = false;
}
