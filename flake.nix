{
  description = "NixOS Configurations for all daudi.dev infrastructure";
  nixConfig = {
    substituters = [];
  };
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
      inputs.nixpkgs.follows = "nixpkgs";
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
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = [
                (final: prev: {
                  config = prev.config // {
		    cudaSupport = true;
		    replaceStdenv = ({ pkgs }: prev.impureUseNativeOptimisations pkgs.clangStdenv);
                  };
		  hostPlatform = {
		    # The system will take many hours and run out of space to rebuild with native support
			gcc.arch = "znver5";
			clang.arch = "znver5";
			gcc.tune = "znver5";
			clang.tune = "znver5";
 			system = "x86_64-linux";
 		   };
                })
              ];
            }
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
          specialArgs = { inherit inputs; };
          modules = [
            hosts.default_mixins
            hosts.mixins.ssh-support
            hosts.minecraft-server
            home-manager.nixosModules.home-manager
            users.daudi
          ];
        };
      };
    };
}
