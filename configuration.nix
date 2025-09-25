# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
    nix-flatpak = ./aux/nix-flatpak;
    home-manager = ./aux/home-manager;
in {
  
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Fetch nix-flatpak and home-manager
    "${home-manager}/nixos"
    "${nix-flatpak}/modules/nixos.nix"
  ];

  # Package Overrides
  nixpkgs.overlays = [
    (final: prev: {
    openrgb = prev.openrgb.overrideAttrs (old: {
      src = prev.fetchFromGitLab {
        owner = "CalcProgrammer1";
        repo="OpenRGB";
        rev = "release_candidate_1.0rc2";
        sha256 = "vdIA9i1ewcrfX5U7FkcRR+ISdH5uRi9fz9YU5IkPKJQ=";
      };
      patches = [
        ./apps/openrgb/remove_systemd_service.patch
      ];
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail /usr/bin/env "${prev.coreutils}/bin/env"
      '';
      version = "1.0rc2";
    });
    })
  ];

  # Bootloader.

  # Use lts kernel for compatibility :/
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
	consoleMode = "max";
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
    ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    consoleLogLevel = 3;
    initrd.verbose = false;
    plymouth = {
      enable = true;
      theme = "black_hud";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "black_hud" ];
        })
      ];
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
  
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
     package = pkgs.openrgb;
     enable = true;
     motherboard = "amd";
  };
  systemd.services.openrgb = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "lm_sensors.service" ];
    description = "OpenRGB SDK Server";
    serviceConfig = {
      RemainAfterExit="yes";
      ExecStart=''${pkgs.openrgb}/bin/openrgb --server'';
      Restart="always";
    };
    enable = false;
  };

  systemd.services.initialise_rgb = let
    colour = "red";
    openrgb_config = ./apps/openrgb/config;
  in {
    wantedBy = ["multi-user.target"];
    after = [ "network.target" "lm_sensors.service" ];
    description = "OpenRGB set all to '${colour}'";
    serviceConfig = {
      ExecStart = ''${pkgs.openrgb}/bin/openrgb -vv --noautoconnect --config ${openrgb_config} --mode direct -c "${colour}"'';
      Type = "oneshot";
    };
  };

  # firmware updates
  services.fwupd.enable = true;

  # SSH Agent
  services.gnome.gnome-keyring.enable = true;

  # Automount disks
  services.udisks2.enable = true;

  networking.hostName = "cambridge"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.enable = true;

  # User Accounts
  users = {
    users.daudi = {
      isNormalUser = true;
      description = "Daudi Wampamba";
      extraGroups = [ "networkmanager" "wheel" ];
    };
    defaultUserShell = pkgs.fish;
  };
  
  home-manager.useUserPackages = true;
  home-manager.users.daudi = { pkgs, lib, ... }: {
    imports = [
      "${nix-flatpak}/modules/home-manager.nix"
    ];

    home.packages = with pkgs; [
        # Hardware
	udiskie
	
	# Desktop Environment
        alacritty
	wl-clipboard
	seahorse

	# Flatpak
	flatpak
    ];

    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      userName = "Daudi Wampamba";
      userEmail = "me@daudi,dev";
      extraConfig = {
      	credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
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
	  location = "https://gl.flathub.org/repo/";
	}
        {
	  name = "cosmic";
	  location = "https://apt.pop-os.org/cosmic/";
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
          appId = "org.freedesktop.Platform.VulkanLayer.gamescope";
	}
	{
          origin = "cosmic";
	  appId = "io.github.cosmic_utils.cosmic-ext-applet-clipboard-manager";
	}
      ];
      enable = true;
    };
    
    xdg = {
      enable = true;
      desktopEntries = {
      };
      autostart = {
        enable = true;
        readOnly = true;
        entries = [];
      };
    };
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # dev
    git

    # tty
    fish
    neovim
  ];

  # YOU DONT NEED SUDO. RUN0 FOREVER
  security.sudo.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ]; 
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking = {
    interfaces = {
      enp10s0.ipv4.addresses = [{
        address = "192.168.1.99";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp10s0";
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ]; 
  };

  # Enable Graphics
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;
   
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Desktop Environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-term
    cosmic-edit
    cosmic-store
    cosmic-files
  ];
  services.desktopManager.cosmic.showExcludedPkgsWarning = false;

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable-small/";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
