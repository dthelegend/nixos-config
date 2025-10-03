{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.minecraft-server = {
    package = pkgs.minecraftServers.vanilla-1-20;
    enable = true;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    serverProperties = {
      difficulty = 3;
      gamemode = 1;
      motd = "NixOS Minecraft server!";
      white-list = true;
      allow-cheats = true;
    };
    jvmOpts = "-Xms2048M -Xmx8G";
  };
}
