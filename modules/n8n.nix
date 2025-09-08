{config, pkgs, lib, utils, ...}:

{
#	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  	"n8n"
  ];

  environment.systemPackages = [
    pkgs.n8n
  ];
}
