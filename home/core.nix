{ config, pkgs, ... }:
{
  imports = [
    ./../modules/irssi.nix
  ];

  home.stateVersion = "25.05";
  home.username = "emily";
  home.homeDirectory = "/home/emily";

  home.packages = [
    pkgs.htop
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Jane Doe";
    userEmail = "jane.doe@example.org";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
