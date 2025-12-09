{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./busybox/default.nix)
    (import ./pycparser)
    (import ./cosmic-session)
    (import ./openrgb)
  ];
}
