{ config, pkgs, ... }:

{
  home.username = "simen";
  home.homeDirectory = "/home/simen";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

# -- Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Simen Kristoffer";
        email = "post@simenkristoffer.no";
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

# -- Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;


   plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars # Installer Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
      pkgs.vimPlugins.vim-moonfly-colors
      pkgs.vimPlugins.neo-tree-nvim
    ];

    initLua = ''
      -- Linjenumre
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Tabs og innrykk
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.autoindent = true
      vim.opt.smartindent = true

      -- Utseende
      vim.opt.wrap = false
      vim.opt.cursorline = true
      vim.opt.scrolloff = 8

      vim.cmd.colorscheme('moonfly')

      -- Tree-sitter: slå på for alle filtyper som har en parser
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    '';      
    };


}
