{inputs, pkgs, ...}:

{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.rofi-wayland
    pkgs.waybar
    pkgs.waypaper
    pkgs.swaynotificationcenter
    pkgs.swww
    pkgs.nwg-displays
    pkgs.papirus-icon-theme
    pkgs.jq
    pkgs.nautilus
  ];

  services.displayManager = {
    defaultSession = "hyprland";
    gdm.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adwaita-dark";
        icon-theme = "Papirus-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];
}
