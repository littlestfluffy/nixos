{ config, pkgs, ... }:

{
  # Basic firewall
  networking.firewall.allowedTCPPorts = [ 3306 ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    configFile = pkgs.writeText "my.cnf" ''
       [mysqld]
       datadir=/var/lib/mysql
       bind-address=0.0.0.0
       port=3336
    '';
  };
}
