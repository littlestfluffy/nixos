{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "emily";
  home.homeDirectory = "/home/emily";

  programs.zsh.enable = true;
  programs.git.enable = true;
}
