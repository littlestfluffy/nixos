{inputs, pkgs, ...}:

{
  boot = {
#    kernelParams = ["ipv6.disable=1"];
    tmp.cleanOnBoot = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    };
  };
}
