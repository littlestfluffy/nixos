{ config, lib, pkgs, inputs, ... }:

let
  candidates = [
    ./hardware-configuration.nix
    /mnt/etc/nixos/hardware-configuration.nix
    /etc/nixos/hardware-configuration.nix
  ];

  existing = builtins.filter builtins.pathExists candidates;
  hwConfig = if existing == [] then null else builtins.head existing;

  # function to filter nulls from a list
  filterNulls = list: builtins.filter (x: x != null) list;
in
{
  imports = filterNulls [
    hwConfig
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
