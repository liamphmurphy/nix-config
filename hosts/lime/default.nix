{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/virtualisation.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # Prevents a split-lock crash seen in A Plague Tale: Requiem.
  boot.kernelParams = [ "split_lock_detect=off" ];

  networking.hostName = "lime";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.nftables.enable = true;
  services.tailscale.enable = true;

  time.timeZone = "America/Los_Angeles";
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

  services.xserver = {
    enable = false;
    xkb.layout = "us";
  };

  services.power-profiles-daemon.enable = false;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  programs.zsh.enable = true;
  users.users.liam = {
    isNormalUser = true;
    description = "Liam Murphy";
    extraGroups = [
      "lp"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = [ pkgs.kdePackages.kate ];
  };

  programs.nix-ld.enable = true;
  hardware.amdgpu.overdrive.enable = true;
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.liam = import ../../home/liam;
  };

  system.stateVersion = "25.05";
}
