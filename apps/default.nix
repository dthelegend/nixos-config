{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (
      final: prev:
      lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = prev.callPackage;
        directory = ./apps;
      }
    )
  ];
}
