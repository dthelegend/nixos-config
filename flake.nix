{
  description = "NixOS Configurations for all daudi.dev infrastructure";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/25.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable = {
      url = "github:dthelegend/nixpkgs?ref=nixos-unstable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      home-manager-unstable,
      nix-flatpak,
      nix-minecraft,
    }:
    with (import ./.);
    {
      nixosConfigurations = {
        cambridge = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            nixpkgs = nixpkgs-unstable;
            home-manager = home-manager-unstable;
            nix-flatpak = nix-flatpak;
          };
          modules = [
            overlays
            hosts.default-mixins
            hosts.cambridge
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        milton-keynes = nixpkgs.lib.nixosSystem {
          specialArgs = {
            nixpkgs = nixpkgs;
            home-manager = home-manager;
            nix-flatpak = nix-flatpak;
          };
          modules = [
            # overlays
            hosts.default-mixins
            hosts.milton-keynes
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        minecraft-server = nixpkgs.lib.nixosSystem {
          specialArgs = {
            nixpkgs = nixpkgs;
            home-manager = home-manager;
            nix-flatpak = nix-flatpak;
            nix-minecraft = nix-minecraft;
          };
          modules = [
            # overlays
            hosts.default-mixins
            hosts.mixins.ssh-support
            hosts.minecraft-server
            users.daudi
          ];
        };
      };
    };
}
