{ inputs, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    environmentFile = "/run/secrets/caddy.env";
  };
}
