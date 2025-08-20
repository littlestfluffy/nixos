{ config, pkgs, ... }:

{
  systemd.services.irssi = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Start the irssi client of username.";
    serviceConfig = {
      Type = "forking";
      User = "${config.home.username}";
      ExecStart = ''
        ${pkgs.tmux}/bin/tmux new-session -d -s irssi ${pkgs.irssi}/bin/irssi
      '';
      ExecStop = ''
        ${pkgs.tmux}/bin/tmux kill-session -t irssi
      '';
    };
  };
}
