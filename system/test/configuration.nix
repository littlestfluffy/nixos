{ config, lib, pkgs, inputs, ... }:

let
  candidates = [
    ./hardware-configuration.nix
    /mnt/etc/nixos/hardware-configuration.nix
    /etc/nixos/hardware-configuration.nix
  ];
  existing = builtins.filter builtins.pathExists candidates;
in
{
  imports = [
    (if existing == [] then null else builtins.head existing)
    ./..
    ./../../modules/pipewire.nix
  ];

  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
