{ config, pkgs, ... }:

{
  systemd.services.signal-messenger = {
    description = "Gurk Signal Messenger Client";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s signal-messenger ${pkgs.gurk-rs}/bin/gurk";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t signal-messenger";
      Restart = "always";
      Environment = "TERM=xterm-256color";
      User = "${config.my.users.username}";
    };
  };
}

