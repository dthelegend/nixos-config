{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  networking = {
    hostName = "minecraft";
    interfaces = {
      "eth0".ipv4.addresses = [
        {
          address = "192.168.1.64";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
  };
}
