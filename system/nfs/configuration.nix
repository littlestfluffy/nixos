# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules
    ./../../modules/boot-legacy.nix
    ./../../modules/qemu-guest.nix
    ./../../modules/openssh-server.nix
  ];

  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    git
    htop
    vim
  ];

  my.users = {
    username = "emily";
    sshKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3LE6HunHPEvtNs4Tg3Nud0uHRMeihcCdiORosXrmfY" ];
    packages = with pkgs; [
      fish
    ];
  };


  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /mnt/pve        192.168.2.0/24(rw,nohide,insecure,no_subtree_check,async,no_root_squash,no_all_squash)
  '';

  networking.firewall = {
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
  };

  users.users.emily.linger = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
