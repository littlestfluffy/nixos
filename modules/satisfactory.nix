{config, pkgs, lib, utils, ...}: let
	steam-app = "1690800";
	steam-name = "satisfactory";
in {
#	imports = [
#		./steamcmd.nix
#	];

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
}
