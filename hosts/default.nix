let
  options = {
    ssh-support = ./ssh_support.nix;
    default-system = ./default_system.nix;
    nix-config = ./nix_config.nix;
  };
in
{
  inherit options;

  defaults = (
    {
      ...
    }:
    {
      imports = with options; [
        default-system
        nix-config
      ];
    }
  );
  cambridge = import ./cambridge;
  minecraft-server = import ./minecraft-server;
}
