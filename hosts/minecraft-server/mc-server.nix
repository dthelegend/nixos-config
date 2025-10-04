{
  modulesPath,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Majonez57/MunchCraft/raw/0.0.5-alpha/pack.toml";
    packHash = "sha256-175qWQJaW0io4dkTgFar6Ih70EAY7xVkLghBKZmQueU=";
  };
  forge-installer = pkgs.fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.4.0/forge-1.20.1-47.4.0-installer.jar";
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
      munchcraft = {
        enable = true;
        package = pkgs.vanillaServers.vanilla-1_20_1.overrideAttrs (
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
              		exec ${jre}/bin/java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.3.33/unix_args.txt nogui
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
          white-list = true;
          allow-cheats = true;
        };

        jvmOpts = "-Xms2G -Xmx8G";
      };
    };
  };
}
