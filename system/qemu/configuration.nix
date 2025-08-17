# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, inputs, ... }:

{
  imports =
    (if builtins.pathExists /mnt/etc/nixos/hardware-configuration.nix
     then [ /mnt/etc/nixos/hardware-configuration.nix ]
     else if builtins.pathExists /etc/nixos/hardware-configuration.nix
     then [ /etc/nixos/hardware-configuration.nix ]
     else []);

  boot = {
    kernelParams = ["ipv6.disable=1"];
    tmp.cleanOnBoot = true;
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
      };
      timeout = 10;
    };
  };

  services.qemuGuest.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  users.users.littlestfluffy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      git
      fish
      screen
      irssi
    ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3LE6HunHPEvtNs4Tg3Nud0uHRMeihcCdiORosXrmfY"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };

  security.sudo = {
      wheelNeedsPassword = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
}