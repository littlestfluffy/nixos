{ config, lib, pkgs, inputs, ... }:

let
  candidates = [
    ./hardware-configuration.nix
    /mnt/etc/nixos/hardware-configuration.nix
    /etc/nixos/hardware-configuration.nix
  ];

  # filter only existing paths
  existing = builtins.filter builtins.pathExists candidates;

  # take the first if any, otherwise null
  hwConfig = if existing == [] then null else builtins.head existing;
in
{
  imports = lib.cleanNull [
    hwConfig          # first existing hardware config
    ./..               # your main modules
    ./../../modules/pipewire.nix
  ];

  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
