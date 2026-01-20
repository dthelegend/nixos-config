{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hostName = "milton-keynes"; # Define your hostname.
    networkmanager = {
      enable = true;
      dns = "none";
    };
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
}
