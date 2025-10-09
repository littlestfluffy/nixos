{ config, pkgs, ... }:

{
  # Basic firewall
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.haproxy = {
    enable = true;
    extraConfig = ''
      global
        log stdout format raw local0
        maxconn 2000
      defaults
        log     global
        mode    tcp
        option  tcplog
        timeout connect 5s
        timeout client  1m
        timeout server  1m

#      frontend talos_api
#        bind *:50000
#        default_backend talos_cp

      frontend kube_api
        bind *:6443
        default_backend talos_cp

      backend talos_cp
        server cp1 192.168.2.231:6443 check
        server cp2 192.168.2.232:6443 check
        server cp3 192.168.2.233:6443 check
    '';
  };
}
