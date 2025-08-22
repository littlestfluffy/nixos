{inputs, pkgs, ...}:

{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.rofi-wayland
    pkgs.waybar
    pkgs.waypaper
    pkgs.swww
    pkgs.nwg-displays
    pkgs.papirus-icon-theme
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
  ];
}
