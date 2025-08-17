{ config, pkgs, ... }:

{
  # Allow unfree packages (needed for NVIDIA driver)
  nixpkgs.config.allowUnfree = true;

  # Your graphics config
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
