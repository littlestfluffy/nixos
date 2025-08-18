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
          "github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5"
          "github.com/mholt/caddy-dynamicdns@b846b9e8fb83f52be540fb7876116f944e56d551"
        ];
        hash = "sha256-vg/Reqd7dPqIpCHTmm5BNd/EV72I09ccAQ1y+5X0kUE=";
      };
  };
}
