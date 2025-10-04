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
    packHash = "sha256-VHf8nSS5zZSxJg760CqXVU2Y6Bo4SsHSc51M8bp4gL4=";
  };
  forge-installer = pkgs.fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.33/forge-1.20.1-47.3.33-installer.jar";
    hash = "sha256-s7SlV2eYM3sABLS1hFzBGq6goCkRa/We2bpCK5nLsmU=";
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
