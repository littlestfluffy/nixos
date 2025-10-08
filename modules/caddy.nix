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
          "github.com/WeidiDeng/caddy-cloudflare-ip"
          "github.com/mholt/caddy-dynamicdns"
          "github.com/mholt/caddy-l4"
        ];
        hash = "sha256-vg/Reqd7dPqIpCHTmm5BNd/EV72I09ccAQ1y+5X0kUE=";
      };
  };
}
