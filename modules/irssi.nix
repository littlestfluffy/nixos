  { config, pkgs, ... }:

 {
   systemd.services.irssi = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start the irssi client of username.";
      serviceConfig = {
        Type = "forking";
        User = "${config.my.users.username}";
        ExecStart = ''${pkgs.screen}/bin/screen -dmS irssi ${pkgs.irssi}/bin/irssi'';
        ExecStop = ''${pkgs.screen}/bin/screen -S irssi -X quit'';
      };
   };

   environment.systemPackages = [ pkgs.screen ];
 }
