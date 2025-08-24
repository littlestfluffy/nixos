{inputs, pkgs, ...}:

{
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
        Experimental = true; # Show battery charge of Bluetooth devices
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
