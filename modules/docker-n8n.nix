{config, pkgs, lib, utils, ...}:

{
	imports = [
		./docker.nix
	];

  networking.firewall.allowedTCPPorts = [ 5678 ];

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers.n8n = {
    image = "docker.n8n.io/n8nio/n8n:latest";
    ports = [ "5678:5678" ];
    volumes = [
      "n8n_data:/var/lib/n8n"
    ];
  };
}
