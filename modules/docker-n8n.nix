{ config, pkgs, lib, utils, ... }:

{
  imports = [
    ./docker.nix
  ];

  networking.firewall.allowedTCPPorts = [ 5678 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.n8n = {
      image = "docker.n8n.io/n8nio/n8n:latest";
      ports = [ "5678:5678" ];
      volumes = [
        "n8n_data:/home/node/.n8n"
      ];
      environment = {
        GENERIC_TIMEZONE = "Europe/Amsterdam";
        TZ = "Europe/Amsterdam";
        N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true";
        N8N_RUNNERS_ENABLED = "true";
      };
    };
  };
}
