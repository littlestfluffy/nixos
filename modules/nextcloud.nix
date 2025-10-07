{ config, pkgs, lib, utils, ... }:

{
  imports = [
    ./docker.nix
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.nextcloud-aio-mastercontainer = {
      serviceName = "nextcloud-aio-mastercontainer";
      image = "ghcr.io/nextcloud-releases/all-in-one:latest";
      ports = [ "8080:8080" ];
      extraOptions = ["--network=bridge"];
      volumes = [
        "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        AIO_DISABLE_BACKUP_SECTION = "true";
        TZ = "Europe/Amsterdam";
        NEXTCLOUD_STARTUP_APPS = "memories recognize";
        SKIP_DOMAIN_VALIDATION = "true";
      };
    };
  };
}
