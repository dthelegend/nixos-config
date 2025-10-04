{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Majonez57/MunchCraft/raw/0.0.5-alpha/pack.toml";
    packHash = "sha256-L5RiSktqtSQBDecVfGj1iDaXV+E90zrNEcf4jtsg+wk=";
  };
  forge-installer = pkgs.fetchurl "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.33/forge-1.20.1-47.3.33-installer.jar";
in
{
  services.minecraft-servers.munchcraft = {
    enable = true;
    eula = true;
    package = pkgs.vanillaServers.vanilla-1_20_1.overrideAttrs (
      final: prev: {
        preFixupPhase = prev.preFixupPhase + ''
          	    cat > $out/bin/minecraft-server << EOF
                      #!/bin/sh
              	    exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
                      EOF
          	    
          	    java -Duser.dir=$out/lib -jar ${forge-installer} --installServer
          	'';
      }
    );
    declarative = true;
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
}
