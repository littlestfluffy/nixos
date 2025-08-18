{ inputs, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    environmentFile = "/run/secrets/caddy.env";
    package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.1"
          "github.com/WeidiDeng/caddy-cloudflare-ip@main"
          "github.com/mholt/caddy-dynamicdns@master"
        ];
        hash = "sha256-F/jqR4iEsklJFycTjSaW8B/V3iTGqqGOzwYBUXxRKrc=";
      };
  };
}
