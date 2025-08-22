{config, pkgs, lib, utils, ...}:

{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  	"vivaldi"
  ];

  environment.systemPackages = [
    pkgs.vivaldi
    pkgs.vivaldi-ffmpeg-codecs
  ];
}
