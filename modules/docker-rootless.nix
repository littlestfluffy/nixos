{ inputs, pkgs, ... }:

{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      log-driver = "journald";
    };
  };
}
