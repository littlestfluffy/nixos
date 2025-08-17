{ config, lib, pkgs, ... }:

with lib;
{
  options.my.users = {
    username = mkOption {
      type = types.str;
      default = "user";
      description = "Primary username.";
    };

    sshKeys = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of SSH public keys for the user.";
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages installed for the user.";
    };

    autologin = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable TTY autologin for this user.";
    };
  };

  config = {
    users.users.${config.my.users.username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = config.my.users.sshKeys;
      packages = config.my.users.packages;
    };

    services.getty.autologinUser = mkIf config.my.users.autologin
      config.my.users.username;
  };
}
