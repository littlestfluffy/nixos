# satisfactory.nix
{config, pkgs, lib, utils, ...}: let
	# Set to {id}-{branch}-{password} for betas.
	steam-app = "1690800";
in {
	imports = [
		./steamcmd.nix
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
#
#	# This is my custom backup machinery. Substitute your own 🙂
#	kevincox.backup.satisfactory = {
#		paths = [
#			"/var/lib/satisfactory/save/"
#		];
#	};
}
