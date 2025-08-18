{ config, inputs, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  config.virtualisation.oci-containers.containers = {
    hackagecompare = {
      image = "chrissound/hackagecomparestats-webserver:latest";
      ports = ["0.0.0.0:3010:3010"];
      volumes = [
        "/root/hackagecompare/packageStatistics.json:/root/hackagecompare/packageStatistics.json"
      ];
      cmd = [
        "--base-url"
        "\"/hackagecompare\""
      ];
    };
  };
}
