{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./cosmic-session)
    (import ./buf)
    (import ./openrgb)
    (import ./gsl)
    (import ./linux-firmware)
    (import ./lib2geom)
    (import ./valkey)
    (import ./ffmpeg)
  ];
}
