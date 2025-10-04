let
  mixins = {
    ssh-support = ./ssh-support.nix;
    default-system = ./default-system.nix;
    nix-config = ./nix-config.nix;
  };
in
{
  inherit mixins;

  default_mixins = (
    {
      ...
    }:
    {
      imports = with mixins; [
        default-system
        nix-config
      ];
    }
  );
  cambridge = import ./cambridge;
  minecraft-server = import ./minecraft-server;
}
