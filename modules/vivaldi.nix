{inputs, pkgs, ...}:

{
  environment.systemPackages = [
    pkgs.vivaldi
    pkgs.vivaldi-ffmpeg-codecs
  ];
}
