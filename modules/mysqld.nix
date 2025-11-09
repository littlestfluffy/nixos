{ config, pkgs, ... }:

{
  # Basic firewall
  networking.firewall.allowedTCPPorts = [ 3306 ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    configFile = ''
      [mysqld]
      bind-address = 0.0.0.0
    '';
  };
}
