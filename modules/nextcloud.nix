{config, pkgs, lib, utils, ...}:

{
  environment.etc."nextcloud-admin-pass".text = "PWD";
  environment.etc."nextcloud-user-pass".text = "PWD";

  services.nextcloud = {
    enable = true;
    configureRedis = true;
    maxUploadSize = "10G";
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
    settings.enabledPreviewProviders = [
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
}
