{config, pkgs, lib, utils, ...}:

{
  environment.etc."nextcloud-admin-pass".text = "PWD";

  networking.firewall.allowedTCPPorts = [ 80 ];

  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  services.nextcloud = {
    enable = true;
    configureRedis = true;
    maxUploadSize = "10G";
    hostName = "192.168.2.67";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
#    datadir = "/mnt";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) memories recognize;
    };

    settings = {
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";

      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
    };
  };

  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  ];

  environment.etc."nextcloud-user-pass".text = "PWD";

  services.nextcloud = {
    ensureUsers = {
      user1 = {
        email = "user1@localhost";
        passwordFile = "/etc/nextcloud-user-pass";
      };
      user2 = {
        email = "user2@localhost";
        passwordFile = "/etc/nextcloud-user-pass";
      };
    };
  };
}
