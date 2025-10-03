{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "keep";
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "nvidia_drm.fbdev=1"
      "video=efifb:5120x2160"
    ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    consoleLogLevel = 3;
    initrd.verbose = false;
    plymouth = {
      enable = true;
      extraConfig = ''
        DeviceScale = 1
      '';
      theme = "black_hud";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "black_hud" ];
        })
      ];
    };
  };
}
