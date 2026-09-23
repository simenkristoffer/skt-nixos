{ config, pkgs, inputs, ...}:

{
  imports = [ inputs.zen-browser.homeModules.beta ];  # Loads Zen's module.

  home.username = "simen";
  home.homeDirectory = "/home/simen";
  home.stateVersion = "26.05";

# -- zsh
  programs.zsh = {
    enable = true;
    };

  programs.zsh.antidote = {
      enable = true;
      plugins = [
        "mattmc3/zfunctions"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-history-substring-search"
      ];
  };

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

      -- Tree-sitter: slå på for alle filtyper som har en parser
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    '';      };

# -- McFly
    programs.mcfly = {
      enable = true;
      enableZshIntegration = true;
      fuzzySearchFactor = 2;
      interfaceView = "BOTTOM";
      keyScheme = "vim";
    };

# -- Zen Browser 
#    https://github.com/0xc000022070/zen-browser-flake
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
  }; 

# -- QuickShell
    programs.quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    #  systemd.enable = true;
  };
}
