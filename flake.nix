{
  description = "NixOS Configurations for all daudi.dev infrastructure";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    with (import ./.);
    {
      nixosConfigurations = {
        cambridge = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            hosts.defaults
            hosts.cambridge
            users.daudi
            (
              { ... }:
              {
                users.daudi.graphical = true;
              }
            )
          ];
        };
        minecraft-server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            hosts.defaults
            hosts.minecraft-server
            users.daudi-tty
          ];
        };
      };
    };
}
