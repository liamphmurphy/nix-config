{ config, pkgs, lib, ... }:

{

  programs.git = {
	enable = true;
	userEmail = "liam@phmurphy.com";
	userName = "Liam Murphy";
  };

}
