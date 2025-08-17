# satisfactory.nix
{config, pkgs, lib, utils, ...}: let
	# Set to {id}-{branch}-{password} for betas.
	steam-app = "1690800";
in {
	imports = [
		./steamcmd.nix
		./restic.nix
	];

	systemd.services.satisfactory = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "steam@${steam-app}.service" ];
		after = [ "steam@${steam-app}.service" ];

		serviceConfig = {
			ExecStart = utils.escapeSystemdExecArgs [
			  "${pkgs.steam-run}/bin/steam-run"
				"/var/lib/steam-app-${steam-app}/FactoryServer.sh"
				"-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=10"
				"-ini:Engine:[/Script/FactoryGame.FGSaveSession]:mNumRotatingAutosaves=10"
			];
			Nice = "-5";
			PrivateTmp = true;
			Restart = "always";
			User = "steam";
			WorkingDirectory = "~";
		};
	};

  services.restic.backups.satisfactory = {
    initialize = true; # create repo if missing
    repositoryFile = "/etc/nixos/restic-repository";
    passwordFile = "/etc/nixos/restic-password";
    paths = [
      "/var/lib/steam/.config/Epic/FactoryGame/Saved/SaveGames"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    user = "restic";
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';
  };
}
