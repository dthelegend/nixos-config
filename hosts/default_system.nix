{
  config,
  lib,
  pkgs,
  nixpkgs,
  modulesPath,
  ...
}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # dev
    git

    # tty
    fish
    neovim
    file
  ];

  # YOU DONT NEED SUDO. RUN0 FOREVER
  security.sudo.enable = false;
}
