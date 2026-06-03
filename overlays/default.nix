{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./buf)
    (import ./gsl)
    (import ./linux-firmware)
    (import ./lib2geom)
    (import ./libsecret)
    (import ./libtpms)
    (import ./rustup)
    (import ./valkey)
    (import ./ffmpeg)
  ];
}
