{ inputs, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    environmentFile = "/etc/caddy/caddy.env";
    package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.1"
          "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
          "github.com/mholt/caddy-dynamicdns@v0.0.0-20250430031602-b846b9e8fb83"
          "github.com/mholt/caddy-l4@v0.0.0-20251001194302-2e3e6cf60b25"
        ];
        hash = "sha256-vg/Reqd7dPqIpCHTmm5BNd/EV72I09ccAQ1y+5X0kUE=";
      };
  };
}
