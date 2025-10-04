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
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };
  };

  outputs =
    inputs@{
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
          specialArgs = { inherit inputs; };
          modules = [
            overlays
            hosts.default_mixins
            hosts.cambridge
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        minecraft-server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            hosts.default_mixins
            hosts.mixins.ssh-support
            hosts.
            hosts.minecraft-server
            home-manager.nixosModules.home-manager
            users.daudi
          ];
        };
      };
    };
}
