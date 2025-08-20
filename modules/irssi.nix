{ config, pkgs, ... }:

{
  systemd.services.irssi = {
    description = "Irssi IRC Client";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s irssi ${pkgs.irssi}/bin/irssi";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t irssi";
      Restart = "always";
      Environment = "TERM=xterm-256color";
      User = "${config.my.users.username}";
    };
  };
}

