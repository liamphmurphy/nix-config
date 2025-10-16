# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # kernel params
  boot.kernelParams = [
    "split_lock_detect=off" # TODO: adding this since a split lock detection caused a crash when playing plague tale requiem...
  ];

  networking.hostName = "lime"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Get that x11 shizz outta here
  services.xserver.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  services.power-profiles-daemon.enable = false;
  powerManagement = {
	enable = true;
	cpuFreqGovernor = "performance";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 8192;
      };
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.liam = {
    isNormalUser = true;
    description = "Liam Murphy";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };


  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;     
    autoLogin.enable = true;
    autoLogin.user = "liam";        
  };


  virtualisation = {
     libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          runAsRoot = false;
        };
      };
  
     containers.enable = true;
     podman = {
       enable = true;
       dockerCompat = true;
       defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
     };
   };

  programs.virt-manager.enable = true;

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam config
  programs.steam = {
    enable = true;
  };
  programs.steam.gamescopeSession.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  	wget
    discord
    gnome-disk-utility
    vulkan-tools
    obs-studio
    obsidian
    megasync
    protonup-qt
    fastfetch
    hyprlock
    protonvpn-gui
    audacity
    gamemode
    distrobox
    heroic
    lact
    nextcloud-client
  ];

  # Allow overclicking of my AMD 7900 GRE
  hardware.amdgpu.overdrive.enable = true;
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["mult-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  networking.firewall.enable = true;
  networking.nftables.enable = true;

# Tailscale 
 services.tailscale.enable = true;


  #programs.hyprland = {
  #  enable = true;
  #  withUWSM = true;
  #  xwayland.enable = true;
  #};

  #programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;


  # Setup home manager
  home-manager = {
    # pass inputs to home-manager module
    extraSpecialArgs = {inherit inputs;};
    users = {
      "liam" = import ./home/homepc.nix;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
