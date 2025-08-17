{ config, lib, pkgs, inputs, ... }:

{
  boot = {
    kernelParams = ["ipv6.disable=1"];
    tmp.cleanOnBoot = true;
    loader = {
      grub = {
        enable = true;
        # device is (dynamically) set in flake.nix
        useOSProber = true;
        timeoutStyle = "menu";
      };
      timeout = 10;
    };
  };

  users.users.emily = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3LE6HunHPEvtNs4Tg3Nud0uHRMeihcCdiORosXrmfY"
    ];
  };

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Amsterdam";

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

  system.stateVersion = "25.05";
}
