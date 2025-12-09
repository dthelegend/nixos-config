{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./busybox)
    (import ./cosmic-session)
    (import ./openrgb)
    (import ./pycparser)
    (import ./rustc)
  ];
}
