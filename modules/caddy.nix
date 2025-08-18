{ inputs, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    services.caddy.environmentFile = "/run/secrets/caddy.env";
  };
}