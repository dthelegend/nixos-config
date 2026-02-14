{
  description = "NixOS Configurations for all daudi.dev infrastructure";
  inputs = {
    nixpkgs = {
      url = "github:dthelegend/nixpkgs?ref=nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nix-flatpak,
      nix-minecraft,
    }:
    with (import ./.);
    {
      nixosConfigurations = {
        cambridge = nixpkgs.lib.nixosSystem {
          specialArgs = {
            nix-flatpak = nix-flatpak;
	    home-manager = home-manager;
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
            nix-flatpak = nix-flatpak;
	    home-manager = home-manager;
          };
          modules = [
            overlays
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
