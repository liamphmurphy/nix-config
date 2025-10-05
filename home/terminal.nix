# Setup anything related to the terminal config, e.g. kitty / zsh
{ config, pkgs, lib, ... }:

{

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      background_opacity = "0.7";
      background_blur = 5;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      eval "$(pay-respects zsh --alias)"
    '';

    shellAliases = {
       ll = "ls -l";
       update = "sudo nixos-rebuild switch --flake ~/nixos#homepc";
    };
    
    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "kubectl" "helm" "golang" ];
      theme = "robbyrussell";
    };
  };

}
