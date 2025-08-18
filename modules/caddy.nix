{ inputs, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    environmentFile = "/run/secrets/caddy.env";
    package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare"
          "github.com/WeidiDeng/caddy-cloudflare-ip"
          "github.com/mholt/caddy-dynamicdns"
        ];
        hash = "sha256-F/jqR4iEsklJFycTjSaW8B/V3iTGqqGOzwYBUXxRKrc=";
      };
  };
}
