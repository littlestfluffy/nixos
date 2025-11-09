{ config, pkgs, ... }:

{
  # Basic firewall
  networking.firewall.allowedTCPPorts = [ 3306 ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
