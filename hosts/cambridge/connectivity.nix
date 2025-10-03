{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  networking = {
    interfaces = {
      enp10s0.ipv4.addresses = [
        {
          address = "192.168.1.99";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp10s0";
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hostName = "cambridge"; # Define your hostname.
  };

  hardware.bluetooth = {
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # firmware updates
  services.fwupd.enable = true;

  # Enable modifying keyboard firmware
  hardware.keyboard.qmk.enable = true;
}
