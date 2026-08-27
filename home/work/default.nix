{ ... }:

{
  home.username = "lmurphy";
  home.homeDirectory = "/Users/lmurphy";
  home.stateVersion = "25.05";

  imports = [
    ../../modules/terminal.nix
    ../../modules/dev.nix
  ];

  programs.home-manager.enable = true;
}
