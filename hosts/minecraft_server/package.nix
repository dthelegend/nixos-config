{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      munchcraft = pkgs.fetchFromGitHub {
        owner = "Majonez57";
        repo = "MunchCraft";
        rev = "master";
        hash = "sha256-0GxNIqLEOhqssYfp+7rVWnppoTyyGZQC65qwgNp0akk=";
      };
    })
  ];
}
