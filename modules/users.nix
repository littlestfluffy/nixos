{ config, pkgs, ... }:

{
  users.users.emily = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3LE6HunHPEvtNs4Tg3Nud0uHRMeihcCdiORosXrmfY"
    ];
  };

  # Enable automatic login for the user.
  #services.getty.autologinUser = "emily";

  security.sudo = {
      wheelNeedsPassword = false;
  };
}