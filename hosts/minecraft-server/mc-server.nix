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
    packHash = "sha256-L5RiSktqtSQBDecVfGj1iDaXV+E90zrNEcf4jtsg+wk=";
  };
  forge-installer = pkgs.fetchurl "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.33/forge-1.20.1-47.3.33-installer.jar";
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
              cat > $out/bin/minecraft-server << EOF
              #!/bin/sh
              exec ${jre}/bin/java \$@ -jar $out/lib/minecraft/forge.jar nogui
              EOF

              ${jre}/bin/java -Duser.dir=$out/lib -jar ${forge-installer} --installServer
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
