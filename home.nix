{ config, pkgs, ... }:

{
  home.username = "simen";
  home.homeDirectory = "/home/simen";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
