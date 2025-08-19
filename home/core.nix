{ config, pkgs, ... }:
{
  home.username = "emily";
  home.homeDirectory = "/home/emily";

  programs.zsh.enable = true;
  programs.git.enable = true;
}
