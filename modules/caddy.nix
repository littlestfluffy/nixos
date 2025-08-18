{ inputs, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
    environmentFile = "/etc/caddy/caddy.env";
  };
}
