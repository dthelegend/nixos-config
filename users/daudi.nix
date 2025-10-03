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
  options.users.daudi = {
    graphical = lib.mkEnableOption "Enable graphical features";
  };

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

  imports = [
    lib.mkIf
    cfg.graphical
    (
      {
        config,
        pkgs,
        lib,
        ...
      }:

      {
        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.daudi =
          { pkgs, lib, ... }:
          {
            imports = [
              "${nix-flatpak}/modules/home-manager.nix"
            ];

            home.packages = with pkgs; [
              # Hardware
              udiskie

              # Desktop Environment
              wl-clipboard
              seahorse

              # Flatpak
              flatpak

              # Misc
              prismlauncher
            ];

            home.sessionVariables = {
              SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
              SSH_ASKPASS_REQUIRE = "prefer";
            };

            home.shell.enableFishIntegration = true;

            programs.fish = {
              enable = true;
            };

            programs.git = {
              enable = true;
              userName = "Daudi Wampamba";
              userEmail = "me@daudi,dev";
              extraConfig = {
                credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
                init.defaultBranch = "main";
                safe.directory = "*";
              };
            };

            # Udisk automount support
            services.udiskie = {
              enable = true;
              settings = {
                program_options = {
                  tray = true;
                  notify = true;
                  automount = true;
                };
                notifications = {
                  timeout = 3;
                  device_mounted = 6;
                };
              };
            };

            services.flatpak = {
              remotes = [
                {
                  name = "flathub";
                  location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
                }
                {
                  name = "flathub-beta";
                  location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
                }
                {
                  name = "cosmic";
                  location = "https://apt.pop-os.org/cosmic/cosmic.flatpakrepo";
                }
              ];
              packages = [
                {
                  origin = "flathub";
                  appId = "com.valvesoftware.Steam";
                }
                {
                  origin = "flathub";
                  appId = "com.discordapp.Discord";
                }
                {
                  origin = "flathub";
                  appId = "app.zen_browser.zen";
                }
                {
                  origin = "flathub";
                  appId = "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08";
                }
                {
                  origin = "flathub";
                  appId = "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08";
                }
                {
                  origin = "flathub";
                  appId = "io.github.ungoogled_software.ungoogled_chromium";
                }
                {
                  origin = "flathub-beta";
                  appId = "net.lutris.Lutris";
                }
              ];
              enable = true;
              uninstallUnmanaged = true;
              update.onActivation = true;
            };

            xdg = {
              enable = true;
              desktopEntries = {
                via = {
                  name = "Via";
                  genericName = "Keyboard configuration software";
                  exec = ''flatpak run io.github.ungoogled_software.ungoogled_chromium --new-window --app="https://usevia.app/"'';
                  terminal = false;
                  categories = [ "Application" ];
                };
                fractal-adjust = {
                  name = "Fractal Adjust";
                  genericName = "Headphone configuration software";
                  exec = ''flatpak run io.github.ungoogled_software.ungoogled_chromium --new-window --app="https://adjust.fractal-design.com/"'';
                  terminal = false;
                  categories = [ "Application" ];
                };
                "io.github.ungoogled_software.ungoogled_chromium" = {
                  name = "Ungoogled Chromium (disabled)";
                  noDisplay = true;
                };
              };
              autostart = {
                enable = true;
                readOnly = true;
                entries = [ ];
              };
            };

            # The state version is required and should stay at the version you
            # originally installed.
            home.stateVersion = "25.05";
          };

        # Automount disks
        services.udisks2.enable = true;

        # SSH Agent
        services.gnome.gnome-keyring.enable = true;

        # Desktop Environment
        services.desktopManager.cosmic.enable = true;
        services.displayManager.cosmic-greeter.enable = true;

        environment.cosmic.excludePackages = with pkgs; [
          cosmic-edit
          cosmic-store
          cosmic-files
          cosmic-player
        ];
        services.displayManager.sessionPackages = [ ];
        services.desktopManager.cosmic.showExcludedPkgsWarning = false;
      }
    )
  ];
}
