{ inputs, configs, pkgs, ... }:


{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.username = "simen";
  home.homeDirectory = "/home/simen";
  programs.git = {
    enable = true;
    userName = "Simen";
    userEmail = "simenkristoffer95@gmail.com";
    };

  home.stateVersion = "26.05";

  # == Programs == #
    programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    };

  programs.neovim = {
    enable = true;
    # Make neovim the default editor
    defaultEditor = true;
    # Extra neovim settings
    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      '';
    };

  # bash settings
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nix, btw";
      # Nix configuration
      nixcfg = "sudo -e /etc/nixos/configuration.nix";
      hmcfg = "sudo -e /etc/nixos/home.nix";
      flcfg = "sudo -e /etc/nixos/flake.nix";
      nrs = "sudo nixos-rebuild switch";
      };
    };
}

