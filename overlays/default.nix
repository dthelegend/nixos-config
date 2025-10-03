{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./cosmic-session)
    (import ./openrgb)
  ];
}
