{inputs, pkgs, ...}:

{
  boot = {
    kernelParams = ["ipv6.disable=1"];
    tmp.cleanOnBoot = true;
#    loader = {
#      grub = {
#        enable = true;
#        # device is (dynamically) set in flake.nix
#        useOSProber = true;
#      };
#    };

    loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
    };
  };
}
