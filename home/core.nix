{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "emily";
  home.homeDirectory = "/home/emily";

  programs.git.enable = true;
  programs.home-manager.enable = true;
}
