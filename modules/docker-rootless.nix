{ inputs, pkgs, ... }:

{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
#  boot.kernel.sysctl."net.ipv6.ip_forward" = 1;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      log-driver = "journald";
    };
  };
}
