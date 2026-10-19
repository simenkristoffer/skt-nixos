{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars # Install Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
      pkgs.vimPlugins.vim-moonfly-colors
      pkgs.vimPlugins.neo-tree-nvim
    ];

    initLua = builtins.readFile ./init.lua;
  };
}
