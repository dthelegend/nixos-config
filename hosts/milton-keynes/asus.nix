{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    asusctl
  ];
  services.supergfxd = {
    enable = true;
    settings = {
      mode = "Hybrid";
      vfio_enable = true;
      hotplug_type = "Asus";
    };
  };
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
