{ config, pkgs, ... }:

{
  systemd.user.services.irssi = {
    Unit = {
      Description = "Irssi IRC Client";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s irssi ${pkgs.irssi}/bin/irssi";
      ExexStop = "${pkgs.tmux}/bin/tmux kill-session -t irssi";
      Restart = "never";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
