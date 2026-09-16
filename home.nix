{ config, pkgs, ...}:

{
  home.username = "simen";
  home.homeDirectory = "/home/simen";
  home.stateVersion = "26.05";

  programs.zsh.enable = true;
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Simen Kristoffer";
        email = "post@simenkristoffer.no";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    initLua = ''
      -- Linjenumre
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Tabs og innrykk
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.autoindent = true
      vim.opt.smartindent = true

      -- Utseende
      vim.opt.wrap = false
      vim.opt.cursorline = true
      vim.opt.scrolloff = 8
    '';
      };

    programs.mcfly = {
        enable = true;
        enableZshIntegration = true;
        fuzzySearchFactor = 2;
        interfaceView = "BOTTOM";
        keyScheme = "vim";
    };
}
