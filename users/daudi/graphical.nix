{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  graphical_enabled = config.users.daudi.graphical;
in
{
  options.users.daudi = {
    graphical = lib.mkEnableOption "Enable graphical features";
  };

  imports = with inputs; [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs.flake-inputs = inputs;
      home-manager.users.daudi.imports = [
        nix-flatpak.homeManagerModules.nix-flatpak
      ];
      home-manager.users.daudi.home.stateVersion = "25.05";
    }
    nix-flatpak.nixosModules.nix-flatpak
  ];

  config = lib.mkIf graphical_enabled {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
    };

    home-manager.users.daudi =
      { pkgs, lib, ... }:
      {
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
            {
              origin = "flathub";
              appId = "com.spotify.Client";
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
  };
}
