{
  modulesPath,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  minecraft-version = "1.20.1";
  forge-version = "47.4.0";
  
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Majonez57/MunchCraft/raw/0.0.7-alpha/pack.toml";
    packHash = "sha256-IKEbRLrwKNgZpwKQoOeeYXS1gkZB4/qX7QnM+aDSzjE=";
  };

  forge-installer = pkgs.fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${minecraft-version}-${forge-version}/forge-${minecraft-version}-${forge-version}-installer.jar";
    hash = "sha256-8/V0ZeLL3DKBk/d7p/DJTLZEBfMe1VZ1PZJ16L3Abiw=";
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      munchcraft = let
        minecraft-version-fixed = (lib.strings.concatStringsSep "_" (lib.versions.splitVersion minecraft-version));
      in {
        enable = true;
        package = pkgs.vanillaServers."vanilla-${minecraft-version-fixed}".overrideAttrs (
          final: prev:
          let
            jre = pkgs.jdk17;
          in
          {
            installPhase = prev.installPhase + ''
                            mv $out/lib/minecraft/server.jar $out/lib/minecraft/server-${prev.version}.jar 

                            cat > $out/bin/minecraft-server << EOF
              	        #!/bin/sh
              		${jre}/bin/java -jar ${forge-installer} --installServer || true
              		echo "\$@" > user_jvm_args.txt
              		exec ${jre}/bin/java @user_jvm_args.txt @libraries/net/minecraftforge/forge/${minecraft-version}-${forge-version}/unix_args.txt nogui
              		EOF
            '';
          }
        );

        symlinks = {
          "mods" = "${modpack}/mods";
        };

        openFirewall = true;
        serverProperties = {
          difficulty = 3;
          gamemode = 1;
          motd = "It's declarative as f**k!";
          white-list = false;
          allow-cheats = true;
	  seed = "munchingrn";
        };

	operators = {
	  DTheLegend = "602b1408-6464-453f-a79e-18372981700c";
	};

        jvmOpts = "-Xms2G -Xmx16G";
      };
    };
  };
}
