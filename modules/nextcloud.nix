{ config, pkgs, lib, utils, ... }:

{
  imports = [
    ./docker.nix
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/n8n 0755 1000 1000 -"
  ];

  networking.firewall.allowedTCPPorts = [ 5678 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.nextcloud-aio-mastercontainer = {
      serviceName = "nextcloud-aio-mastercontainer";
      image = "ghcr.io/nextcloud-releases/all-in-one:latest";
      ports = [ "8080:8080" ];
      extraOptions = ["--network=bridge"];
      volumes = [
        "/var/lib/nextcloud:/mnt/docker-aio-config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        GENERIC_TIMEZONE = "Europe/Amsterdam";
        TZ = "Europe/Amsterdam";
        N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true";
      };
    };
  };
}
