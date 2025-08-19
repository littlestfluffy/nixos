{config, pkgs, lib, utils, ...}: let
	steam-app = "1690800";
	steam-name = "satisfactory";
in {
	imports = [
		./restic.nix
	];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steamcmd"
    "steam-run"
    "steam-unwrapped"
  ];

	users.users.${steam-name} = {
    isSystemUser = true;
    createHome = true;
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
      ExecStartPre = utils.escapeSystemdExecArgs [
        "${pkgs.steamcmd}/bin/steamcmd"
        "+force_install_dir /var/lib/${steam-name}"
        "+login anonymous"
        "+app_update ${steam-app} validate"
        "+quit"
      ];
			ExecStart = utils.escapeSystemdExecArgs [
			  "${pkgs.steam-run}/bin/steam-run"
				"/var/lib/${steam-name}/FactoryServer.sh"
				"-NetDriverListenSocketsUseIPv6=false"
				"-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=10"
				"-ini:Engine:[/Script/FactoryGame.FGSaveSession]:mNumRotatingAutosaves=5"
			];
      Restart = "always";
      RestartSec = 5;
    };
  };

  services.restic.backups.${steam-name} = {
    initialize = true; # create repo if missing
    repositoryFile = "/etc/nixos/restic-repository";
    passwordFile = "/etc/nixos/restic-password";
    paths = [
      "/var/lib/${steam-name}"
    ];
    pruneOpts = [
      "--keep-hourly 24"
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 1"
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
