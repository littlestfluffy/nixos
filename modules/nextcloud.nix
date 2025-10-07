{config, pkgs, lib, utils, ...}:

{
  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  ];

  environment.etc."nextcloud-admin-pass".text = "PWD";

  networking.firewall.allowedTCPPorts = [ 80 ];

  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  services.nextcloud = {
    enable = true;
    configureRedis = true;
    hostName = "192.168.2.67";
    config = {
      adminpassFile = toString (pkgs.writeText "adminpass" "root");
      dbtype = "pgsql";
    };
    database.createLocally = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) memories recognize;
    };
    extraAppsEnable = true;
  };
}
