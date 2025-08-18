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

    security.sudo = {
      wheelNeedsPassword = false;
    };

    services.getty.autologinUser = mkIf config.my.users.autologin
      config.my.users.username;
    };

    programs.bash = {
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
}
