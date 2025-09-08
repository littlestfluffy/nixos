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
    containers.n8n = {
      image = "docker.n8n.io/n8nio/n8n:latest";
      ports = [ "5678:5678" ];
      volumes = [
        "/var/lib/n8n:/home/node/.n8n"
      ];
      environment = {
        N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true";
      };
    };
  };
}
