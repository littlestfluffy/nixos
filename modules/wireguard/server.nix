{ inputs, pkgs, ... }:

let
  externalInterface = "ens18";
in
{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "${externalInterface}";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard = {
    enable = true;

    interfaces.wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      generatePrivateKeyFile = true;
      privateKeyFile = "/etc/wireguard/private.key";

      peers = [
#        {
#          name = "MobilePhone";
#          publicKey = "8t+Ek6ka0e2iR0/Mc/oVLQMqA8HxVU582qJKvdTJxQY=";
#          allowedIPs = [ "10.100.0.2/32" ];
#        }
#        {
#          name = "WorkLaptop";
#          publicKey = "{john doe's public key}";
#          allowedIPs = [ "10.100.0.3/32" ];
#        }
      ];
    };
  };
}