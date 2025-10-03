{
  description = "NixOS Configurations for all daudi.dev infrastructure";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
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
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            homeManagerModules.nix-flatpak
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
