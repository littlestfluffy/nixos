{ config, pkgs, ... }:

{
  systemd.user.services.irssi = {
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    description = "Start the irssi client of username.";
    serviceConfig = {
      ExecStart = ''
        ${pkgs.tmux}/bin/tmux new-session -d -s irssi ${pkgs.irssi}/bin/irssi
      '';
      ExecStop = ''
        ${pkgs.tmux}/bin/tmux kill-session -t irssi
      '';
    };
  };
}
