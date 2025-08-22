{inputs, pkgs, ...}:

{
  boot = {
    kernelParams = ["ipv6.disable=1"];
    tmp.cleanOnBoot = true;
    loader = {
    systemd-boot.enable = false;
      grub = {
        enable = true;
        # device is (dynamically) set in flake.nix
        useOSProber = true;
      };
    };
  };
}
