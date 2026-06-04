{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./buf)
    (import ./gsl)
    (import ./keyutils)
    (import ./linux-firmware)
    (import ./lib2geom)
    (import ./libsecret)
    (import ./libtpms)
    (import ./rustup)
    (import ./valkey)
    (import ./ffmpeg)
  ];
}
