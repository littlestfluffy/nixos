# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, inputs, ... }:

{
  imports = let
    candidates = [
      ./hardware-configuration.nix
      /mnt/etc/nixos/hardware-configuration.nix
      /etc/nixos/hardware-configuration.nix
    ];
  in (builtins.filter builtins.pathExists candidates) ++ [ ];

  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
