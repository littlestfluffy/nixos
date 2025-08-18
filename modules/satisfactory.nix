{config, pkgs, lib, utils, ...}: let
	steam-app = "1690800";
	steam-name = "satisfactory";
in {
#	imports = [
#		./steamcmd.nix
#	];

  nixpkgs.config.allowUnfreePredicate = pkg:
  let n = lib.getName pkg;
  in builtins.elem n [
    "steamcmd"
    "steam-run"
    "steam-unwrapped"
  ];

	users.users.${steam-name} = {
    isSystemUser = true;
    group = "${steam-name}";
    home = "/var/lib/${steam-name}";
  };

  users.groups.${steam-name} = {};

  networking.firewall.allowedTCPPorts = [ 7777 8888 ];
  networking.firewall.allowedUDPPorts = [ 7777 ];

  systemd.services.${steam-name} = {
    description = "Dedicated Server: ${steam-name}";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "${steam-name}";
      WorkingDirectory = "/var/lib/${steam-name}";
      ExecStartPre = ''
        ${pkgs.steamcmd}/bin/steamcmd
        +@sSteamCmdForcePlatformType linux
        +login anonymous
        +force_install_dir /var/lib/${steam-name}
        +app_update ${steam-app} validate
        +quit
        '';
			ExecStart = utils.escapeSystemdExecArgs [
			  "${pkgs.steam-run}/bin/steam-run"
				"/var/lib/${steam-name}/FactoryServer.sh"
				"-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=10"
				"-ini:Engine:[/Script/FactoryGame.FGSaveSession]:mNumRotatingAutosaves=10"
			];
      Restart = "always";
      RestartSec = 5;
    };
  };

#	systemd.services.satisfactory = {
#		wantedBy = [ "multi-user.target" ];
#
#		# Install the game before launching.
#		wants = [ "steam@${steam-app}.service" ];
#		after = [ "steam@${steam-app}.service" ];
#
#		serviceConfig = {
#			ExecStart = utils.escapeSystemdExecArgs [
#			  "${pkgs.steam-run}/bin/steam-run"
#				"/var/lib/steam-app-${steam-app}/FactoryServer.sh"
#				"-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=10"
#				"-ini:Engine:[/Script/FactoryGame.FGSaveSession]:mNumRotatingAutosaves=10"
#			];
#			Nice = "-5";
#			PrivateTmp = true;
#			Restart = "always";
#			User = "steam";
#			WorkingDirectory = "~";
#		};
#	};
#
#  services.restic.backups.satisfactory = {
#    initialize = true; # create repo if missing
#    repositoryFile = "/etc/nixos/restic-repository";
#    passwordFile = "/etc/nixos/restic-password";
#    paths = [
#      "/var/lib/steam/.config/Epic/FactoryGame/Saved/SaveGames"
#    ];
#    pruneOpts = [
#      "--keep-hourly 24"
#      "--keep-daily 7"
#      "--keep-weekly 5"
#      "--keep-monthly 12"
#      "--keep-yearly 4"
#    ];
#    timerConfig = {
#      OnCalendar = "hourly";
#      Persistent = true;
#    };
#    user = "restic";
#    package = pkgs.writeShellScriptBin "restic" ''
#      exec /run/wrappers/bin/restic "$@"
#    '';
#  };
}
