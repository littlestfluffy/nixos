{inputs, pkgs, ...}:

{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.alacritty
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
  ];
}
