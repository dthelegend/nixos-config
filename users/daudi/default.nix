{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  cfg = config.users.daudi;
in
{
  imports = [
    ./graphical.nix
  ];

  config = {
    # User Accounts
    users = {
      users.daudi = {
        isNormalUser = true;
        description = "Daudi Wampamba";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
      defaultUserShell = pkgs.fish;
    };
  };
}
