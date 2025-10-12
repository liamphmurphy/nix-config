# This file serves as the main home manager nix file for my nixos desktop
{ config, pkgs, inputs, ... }:

{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "liam";
  home.homeDirectory = "/home/liam";

  imports = [
	./webapps.nix 
	#./hyprland.nix
	./firefox.nix
	./git.nix
	./terminal.nix
	./dev.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    pay-respects
    btop

    # nerd fonts, for things like waybar, some vim things etc
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.fira-code
    font-awesome
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.home-manager.enable = true;
}
