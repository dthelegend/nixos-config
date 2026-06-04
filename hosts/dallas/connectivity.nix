{ config, lib, pkgs, ... }:

let
  network = import ../network.nix;
  hostConfig = network.hosts.dallas;
in
{
  networking = {
    hostName = "dallas";
    interfaces = {
      "${hostConfig.interface}" = {
        ipv4.addresses = [
          {
            address = hostConfig.ip;
            prefixLength = hostConfig.prefixLength;
          }
        ];
      };
    };
    defaultGateway = {
      address = hostConfig.gateway;
      interface = hostConfig.interface;
    };
  };
}
