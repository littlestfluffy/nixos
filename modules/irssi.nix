{ config, pkgs, ... }:

{
  systemd.user.services.irssi = {
    Unit = {
      Description = "Irssi IRC Client";
      After = [ "network.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s irssi ${pkgs.irssi}/bin/irssi";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t irssi";
      Restart = "never";
      Environment = "TERM=xterm-256color";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
